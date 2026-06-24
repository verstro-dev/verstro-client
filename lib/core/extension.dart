import 'dart:async';
import 'dart:convert';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:flutter/services.dart';

import 'interface.dart';

// iOS core handler —— 核心 (sing-box) 跑在 VerstroTunnel NE 扩展里, 不在 app 进程.
// 本类经 MethodChannel 控制 NETunnelProviderManager (装/起/停 VPN + 把配置写到 App Group),
// 对标桌面 CoreService (同为 IPC handler), 传输换成 NETunnelProvider.
//
// Phase C-1: 生命周期 (preload/init/startListener/stopListener/shutdown) 接原生 VPNManager.
// Phase C-2: 代理列表/流量/连接查询经 app 端 libbox CommandClient (CommandClientBridge.swift),
//   流式订阅 Status/Group 缓存; getProxies 返回 mihomo /proxies 形态供 UI 复用.
// Phase D: _config 的 sing-box JSON 来源已接 —— app 层 _setupConfig (lib/controller.dart) 起隧道前
//   读当前 profile 原始内容 (sing-box JSON) 设进 CoreExtension.config, start 时随之下发到 App Group;
//   订阅用 sing-box UA (lib/common/package.dart) 让订阅服务端返回 sing-box 格式.
// 见 docs/decisions.md why-ios-singbox-network-extension.
class CoreExtension extends CoreHandlerInterface {
  static CoreExtension? _instance;
  final Completer _completer = Completer();
  final MethodChannel _channel = const MethodChannel('com.verstro.app/vpn');
  String? _config;

  factory CoreExtension() {
    _instance ??= CoreExtension._internal();
    return _instance!;
  }

  CoreExtension._internal();

  @override
  Completer get completer => _completer;

  // app 层 _setupConfig 起隧道前把当前 profile 的 sing-box JSON 设进来, start 时下发给扩展
  set config(String? value) => _config = value;

  @override
  Future<String> preload() async {
    try {
      await _channel.invokeMethod('init');
    } catch (e) {
      commonPrint.log('iOS VPN init 失败: $e', logLevel: LogLevel.error);
    }
    if (!_completer.isCompleted) {
      _completer.complete(true);
    }
    return '';
  }

  @override
  Future<T?> invoke<T>({
    required ActionMethod method,
    dynamic data,
    Duration? timeout,
  }) async {
    switch (method) {
      case ActionMethod.startListener:
        // iOS 无独立 listener; "起 listener" = 起 NE 隧道 (扩展跑 sing-box + 建 tun)
        final ok =
            await _channel.invokeMethod<bool>('start', {'config': _config}) ??
                false;
        return ok as T?;
      case ActionMethod.stopListener:
      case ActionMethod.shutdown:
        final ok = await _channel.invokeMethod<bool>('stop') ?? false;
        return ok as T?;
      case ActionMethod.getIsInit:
      case ActionMethod.initClash:
        // 这两个上层按 bool 取
        return true as T?;
      case ActionMethod.setupConfig:
      case ActionMethod.updateConfig:
        // 上层按 String 取; iOS 不经此 ActionMethod 喂配置 —— 配置由 app 层 _setupConfig
        // 经 CoreExtension.config setter 设置, startListener 时下发. 此处仅满足接口签名.
        return '' as T?;
      case ActionMethod.changeProxy:
        // Phase C-2: 经 libbox standalone CommandClient 选节点
        final p = (data is String ? json.decode(data) : data) as Map;
        await _channel.invokeMethod('selectOutbound', {
          'group': p['group-name'],
          'tag': p['proxy-name'],
        });
        return '' as T?;
      case ActionMethod.closeConnections:
      case ActionMethod.resetConnections:
        final ok =
            await _channel.invokeMethod<bool>('closeConnections') ?? false;
        return ok as T?;
      case ActionMethod.closeConnection:
        await _channel.invokeMethod('closeConnection', {'id': data});
        return true as T?;
      case ActionMethod.getProxies:
        // Phase C-2: 流式 CommandClient 缓存的代理列表 (mihomo /proxies 形态)
        final s = await _channel.invokeMethod<String>('getProxies') ?? '{}';
        return json.decode(s) as T?;
      case ActionMethod.getTraffic:
        return (await _channel.invokeMethod<String>('getTraffic') ?? '') as T?;
      case ActionMethod.getTotalTraffic:
        return (await _channel.invokeMethod<String>('getTotalTraffic') ?? '')
            as T?;
      case ActionMethod.getMemory:
        final m = await _channel.invokeMethod<int>('getMemory') ?? 0;
        return m.toString() as T?;
      case ActionMethod.asyncTestDelay:
        // 单节点延迟测试: 原生触发该节点所属组的 libbox URLTest + 轮询回写延迟 (libbox 无单节点测速).
        final p = (data is String ? json.decode(data) : data) as Map;
        final s = await _channel.invokeMethod<String>('testDelay', {
              'proxy-name': p['proxy-name'],
              'test-url': p['test-url'],
              'timeout': p['timeout'],
            }) ??
            json.encode({'name': p['proxy-name'], 'url': p['test-url'], 'value': -1});
        return s as T?;
      default:
        // 其余查询 (getConnections 流式等) → C-2 后续
        return null;
    }
  }

  @override
  Future<bool> shutdown(bool isUser) async {
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {}
    return true;
  }

  @override
  FutureOr<bool> destroy() async {
    await shutdown(false);
    return true;
  }
}

final coreExtension = system.isIOS ? CoreExtension() : null;
