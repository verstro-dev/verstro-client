import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/core.dart';

import 'interface.dart';

class CoreService extends CoreHandlerInterface {
  static CoreService? _instance;

  final Completer<ServerSocket> _serverCompleter = Completer();

  Completer<Socket> _socketCompleter = Completer();

  Completer<bool> _shutdownCompleter = Completer();

  final Map<String, Completer> _callbackCompleterMap = {};

  // 与 core/server.go 一致的帧协议接收缓冲: [4字节小端长度][JSON payload]
  final List<int> _recvBuffer = [];

  Process? _process;

  factory CoreService() {
    _instance ??= CoreService._internal();
    return _instance!;
  }

  CoreService._internal() {
    _initServer();
  }

  Future<void> handleResult(ActionResult result) async {
    final completer = _callbackCompleterMap[result.id];
    final data = await parasResult(result);
    if (result.id?.isEmpty == true) {
      coreEventManager.sendEvent(CoreEvent.fromJson(result.data));
    }
    if (completer?.isCompleted == true) {
      return;
    }
    completer?.complete(data);
  }

  Future<void> _initServer() async {
    final server = await retry(
      task: () async {
        try {
          final address = !system.isWindows
              ? InternetAddress(unixSocketPath, type: InternetAddressType.unix)
              : InternetAddress(localhost, type: InternetAddressType.IPv4);
          await _deleteSocketFile();
          final server = await ServerSocket.bind(address, 0, shared: true);
          server.listen((socket) async {
            await _attachSocket(socket);
          });
          return server;
        } catch (_) {
          return null;
        }
      },
      retryIf: (server) => server == null,
    );
    if (server == null) {
      exit(0);
    }
    _serverCompleter.complete(server);
  }

  Future<void> _attachSocket(Socket socket) async {
    await _destroySocket();
    _recvBuffer.clear();
    _socketCompleter.complete(socket);
    socket.listen(
      (Uint8List chunk) {
        _recvBuffer.addAll(chunk);
        // 按 [4字节小端长度][payload] 帧切分, 支持粘包/半包
        while (_recvBuffer.length >= 4) {
          final len = _recvBuffer[0] |
              (_recvBuffer[1] << 8) |
              (_recvBuffer[2] << 16) |
              (_recvBuffer[3] << 24);
          if (_recvBuffer.length < 4 + len) break;
          final payload = Uint8List.fromList(_recvBuffer.sublist(4, 4 + len));
          _recvBuffer.removeRange(0, 4 + len);
          _handleFramePayload(payload);
        }
      },
      onDone: () {
        _handleInvokeCrashEvent();
        if (!_shutdownCompleter.isCompleted) {
          _shutdownCompleter.complete(true);
        }
      },
    );
  }

  Future<void> _handleFramePayload(Uint8List payload) async {
    final str = utf8.decode(payload).trim();
    if (str.isEmpty) return;
    final dataJson = await str.commonToJSON<dynamic>();
    handleResult(ActionResult.fromJson(dataJson));
  }

  void _handleInvokeCrashEvent() {
    coreEventManager.sendEvent(
      CoreEvent(type: CoreEventType.crash, data: 'socket done'),
    );
  }

  Future<void> start() async {
    if (_process != null) {
      await shutdown(false);
    }
    final serverSocket = await _serverCompleter.future;
    final arg = system.isWindows
        ? '${serverSocket.port}'
        : serverSocket.address.address;
    if (system.isWindows && await system.checkIsAdmin()) {
      final isSuccess = await request.startCoreByHelper(arg);
      if (isSuccess) {
        return;
      }
    }
    _process = await Process.start(appPath.corePath, [arg]);
    _process?.stdout.listen((_) {});
    _process?.stderr.listen((e) {
      final error = utf8.decode(e);
      if (error.isNotEmpty) {
        commonPrint.log(error, logLevel: LogLevel.warning);
      }
    });
    await _socketCompleter.future;
  }

  @override
  destroy() async {
    final server = await _serverCompleter.future;
    await shutdown(false);
    await server.close();
    await _deleteSocketFile();
    return true;
  }

  Future<void> sendMessage(String message) async {
    final socket = await _socketCompleter.future;
    final data = utf8.encode(message);
    // 与 core/server.go readFrame 一致: [4字节小端长度][payload]
    final frame = Uint8List(4 + data.length);
    frame[0] = data.length & 0xff;
    frame[1] = (data.length >> 8) & 0xff;
    frame[2] = (data.length >> 16) & 0xff;
    frame[3] = (data.length >> 24) & 0xff;
    frame.setRange(4, 4 + data.length, data);
    socket.add(frame);
  }

  Future<void> _deleteSocketFile() async {
    if (!system.isWindows) {
      final file = File(unixSocketPath);
      await file.safeDelete();
    }
  }

  Future<void> _destroySocket() async {
    if (_socketCompleter.isCompleted) {
      final socket = await _socketCompleter.future;
      _socketCompleter = Completer();
      await socket.close();
    }
  }

  @override
  shutdown(bool isUser) async {
    if (!_socketCompleter.isCompleted && _process == null) {
      return false;
    }
    _shutdownCompleter = Completer();
    await _destroySocket();
    _clearCompleter();
    if (system.isWindows) {
      await request.stopCoreByHelper();
    }
    _process?.kill();
    _process = null;
    if (isUser) {
      return _shutdownCompleter.future;
    } else {
      return true;
    }
  }

  void _clearCompleter() {
    for (final completer in _callbackCompleterMap.values) {
      completer.safeCompleter(null);
    }
  }

  @override
  Future<String> preload() async {
    await _serverCompleter.future;
    await start();
    return '';
  }

  @override
  Future<T?> invoke<T>({
    required ActionMethod method,
    dynamic data,
    Duration? timeout,
  }) async {
    final id = '${method.name}#${utils.id}';
    _callbackCompleterMap[id] = Completer<T?>();
    sendMessage(json.encode(Action(id: id, method: method, data: data)));
    return (_callbackCompleterMap[id] as Completer<T?>).future.withTimeout(
      timeout: timeout,
      onLast: () {
        final completer = _callbackCompleterMap[id];
        completer?.safeCompleter(null);
        _callbackCompleterMap.remove(id);
      },
      tag: id,
      onTimeout: () => null,
    );
  }

  @override
  Completer get completer => _socketCompleter;
}

final coreService = system.isDesktop ? CoreService() : null;
