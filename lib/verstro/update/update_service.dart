// 升级检测服务: 拉 R2 静态 manifest + 决策. 不负责下载安装(那是 apk_installer 的事).
//
// 全程 fail-open: 任何网络/解析错误都吞掉、当作"无更新", 绝不阻断 app 使用.
// 数据源是 R2 CDN(dl.verstro.com), 不碰 billing 后端 → 抗控制面单点宕机; 即便 R2 也挂,
// fail-open 保证无害.

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'update_manifest.dart';

/// manifest 在 R2 的公开基址. 走下载域名(CDN), 与官网下载链接同源.
const String kUpdateManifestBaseUrl = 'https://dl.verstro.com/manifest';

class UpdateService {
  final Dio _dio;

  UpdateService({Dio? dio}) : _dio = dio ?? _buildDio();

  static Dio _buildDio() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      // 仅 2xx 算成功, 其余(含 5xx / Access 拦截的 HTML)抛 → fail-open
      validateStatus: (s) => s != null && s >= 200 && s < 300,
      // 拿原始字符串自己 jsonDecode, 配合 SyncTransformer 避开 macOS release 卡死
      responseType: ResponseType.plain,
      headers: {'Accept': 'application/json'},
    ));
    // 同 backend_api: 绕 dio 5.x BackgroundTransformer 在 macOS release isolate 卡死 bug
    dio.transformer = SyncTransformer();
    // 强制直连, 绕过 VPN proxy(FlClashHttpOverrides): 拉更新必须不依赖 VPN —— 否则
    // VPN 死时连"提示升级"都做不到; 且走 VPN 会形成循环依赖.
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (_) => 'DIRECT';
        return client;
      },
    );
    return dio;
  }

  /// 当前平台 → manifest 文件名 key.
  static String platformKey() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// 当前平台是否支持应用内下载安装(目前仅 Android).
  /// 其余平台只能"检测→提示→打开下载页", 见计划.
  static bool get supportsInAppInstall => Platform.isAndroid;

  Future<UpdateManifest> fetchManifest() async {
    final platform = platformKey();
    // cache-bust: manifest 是固定 URL, 加时间戳 query 避开 CDN/本地旧缓存
    final ts = DateTime.now().millisecondsSinceEpoch;
    final url = '$kUpdateManifestBaseUrl/$platform.json?_ts=$ts';
    final resp = await _dio.get<String>(url);
    final body = resp.data;
    if (body == null || body.isEmpty) {
      throw const FormatException('空 manifest');
    }
    final decoded = jsonDecode(body);
    return UpdateManifest.fromJson(decoded as Map<String, dynamic>);
  }

  /// 检查更新. fail-open: 出任何错都返回无更新(UpdateDecision.none).
  Future<UpdateDecision> check({required String currentVersion}) async {
    try {
      final m = await fetchManifest();
      return evaluateUpdate(currentVersion: currentVersion, manifest: m);
    } catch (_) {
      return UpdateDecision.none;
    }
  }
}
