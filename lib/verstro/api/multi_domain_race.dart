// 多域名 race: app 启动时并发 ping 3 备用域名, 选第一个返健康响应的作 active backend
//
// 设计原因 (见 docs/decisions.md § why-multi-domain-bootstrap):
// - 单域名被 GFW 封 → 全部用户掉线
// - Cloudflare 边缘节点偶发故障也类似
// - 客户端硬编码 3 域名 + 启动时 race, 任一域名活就连得上
// - 用 api.verstro.com/dev/io (3 个不同 TLD, 不同 registrar 持有, 一锅端概率低)
//
// 缓存策略:
// - 成功选出 active URL → 缓存到 shared_preferences, TTL 24h
// - 客户端检测到 active URL 失败 (e.g. timeout) → invalidate 缓存, 下次启动重 race
// - 应用启动时先读缓存, 缓存有效直接用; 缓存失效 / 全部 timeout → 重 race
//
// 备选 fallback (未实现): /api/billing/v1/bootstrap 返回的 domain list 更新硬编码列表
// 阶段 2.6 上线后再加 (运营加新备域名时不用发版).

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_exceptions.dart';

/// 判定 billing /healthz 响应是否健康。
/// 必须校验 JSON body `ok==true`——CF Access 挑战页返回 200 + HTML, 只判 status 会误判。
/// body 可能是 dio 已解码的 Map, 也可能是未按 content-type 解码的 JSON 字符串, 两种都接受。
bool isHealthyBillingResponse(int? statusCode, dynamic body) {
  if (statusCode != 200) return false;
  Map? json;
  if (body is Map) {
    json = body;
  } else if (body is String) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) json = decoded;
    } catch (_) {
      return false; // HTML / 非 JSON → 不健康
    }
  }
  return json != null && json['ok'] == true;
}

class MultiDomainRace {
  // ============================================================
  // 硬编码备用域名列表 (不要轻易改, 跟后端反代配置一致)
  // 顺序仅作偏好, 实际靠 race 选最快
  // ============================================================
  static const candidateDomains = <String>[
    'api.verstro.com',
    'api.verstro.dev',
    'api.verstro.io',
  ];

  static const apiPathPrefix = '/api/billing';

  // race 时 ping 这条 endpoint, 它最便宜 (billing 容器内置)
  static const healthPath = '/healthz';

  // 单个域名 race timeout
  static const _raceTimeout = Duration(seconds: 5);

  // cache TTL
  static const _cacheTtl = Duration(hours: 24);

  // SharedPreferences keys
  static const _kActiveUrl = 'verstro_active_base_url_v2';
  static const _kActiveUrlAt = 'verstro_active_base_url_at_v2';

  final Dio _probeDio;
  final SharedPreferences _prefs;

  MultiDomainRace({Dio? probeDio, required SharedPreferences prefs})
      : _probeDio = probeDio ??
            (Dio(BaseOptions(
              connectTimeout: _raceTimeout,
              receiveTimeout: _raceTimeout,
              sendTimeout: _raceTimeout,
              validateStatus: (s) => s != null && s < 500,
            ))
              // dio 5.x bug workaround (见 backend_api.dart 同名注释)
              ..transformer = SyncTransformer()
              // createHttpClient + findProxy=DIRECT: 绕过 FlClashHttpOverrides.global.
              // race 在 Application.attach() 前跑, appController 未初始化, 默认
              // adapter 会走 FlClashHttpOverrides.handleFindProxy → 卡死 / 抛错.
              // backend 探测必须永远直连 (理由同 backend_api.dart).
              ..httpClientAdapter = IOHttpClientAdapter(
                createHttpClient: () {
                  final client = HttpClient();
                  client.findProxy = (_) => 'DIRECT';
                  return client;
                },
              )),
        _prefs = prefs;

  /// 启动时调. 返回 active base URL (含 `https://` + api prefix), 如 `https://api.verstro.com/api/billing`
  Future<String> resolveActiveBaseUrl() async {
    // 1. 缓存有效直接用
    final cached = _readCache();
    if (cached != null) return cached;

    // 2. 缓存失效, race
    return _raceAndCache();
  }

  /// 客户端发现 active URL 不可达时主动调, 下次启动 / 下次请求时重 race
  Future<void> invalidateCache() async {
    await _prefs.remove(_kActiveUrl);
    await _prefs.remove(_kActiveUrlAt);
  }

  /// 强制 race (跳过缓存). 调试 / 用户手工切节点时用
  Future<String> forceRace() async {
    await invalidateCache();
    return _raceAndCache();
  }

  // === 内部 ===

  String? _readCache() {
    final url = _prefs.getString(_kActiveUrl);
    final atStr = _prefs.getString(_kActiveUrlAt);
    if (url == null || atStr == null) return null;
    final at = DateTime.tryParse(atStr);
    if (at == null) return null;
    if (DateTime.now().difference(at) > _cacheTtl) return null;
    return url;
  }

  Future<void> _writeCache(String url) async {
    await _prefs.setString(_kActiveUrl, url);
    await _prefs.setString(_kActiveUrlAt, DateTime.now().toIso8601String());
  }

  Future<String> _raceAndCache() async {
    final futures = candidateDomains.map(_probeDomain).toList();
    // 用 Future.any 拿第一个完成的 + 非 null 的; 简单实现: 串行 try until success
    // 实际并发 race 用 Completer 处理
    final completer = Completer<String>();
    int failedCount = 0;

    for (var i = 0; i < futures.length; i++) {
      futures[i].then((url) {
        if (url != null && !completer.isCompleted) {
          completer.complete(url);
        } else {
          failedCount++;
          if (failedCount >= candidateDomains.length && !completer.isCompleted) {
            completer.completeError(const NoActiveBackendException());
          }
        }
      }).catchError((Object e) {
        failedCount++;
        if (failedCount >= candidateDomains.length && !completer.isCompleted) {
          completer.completeError(const NoActiveBackendException());
        }
      });
    }

    // 总超时兜底: 防止 dio probe 在 macOS release build silent hang
    // (单个域名 dio timeout 5s, 但 dio 本身可能 hang 不 throw, race 永不 complete)
    final picked = await completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw const NoActiveBackendException(),
    );
    await _writeCache(picked);
    return picked;
  }

  /// 测单个域名, 返回 active base URL (含 prefix) 或 null
  Future<String?> _probeDomain(String domain) async {
    final url = 'https://$domain$apiPathPrefix$healthPath';
    try {
      final resp = await _probeDio.get<dynamic>(url);
      // 期望 200 + JSON {"ok":true,"service":"billing"}
      // CF Access 挑战页返回 200 + HTML body, 必须校验 JSON body ok==true
      if (isHealthyBillingResponse(resp.statusCode, resp.data)) {
        return 'https://$domain$apiPathPrefix';
      }
    } on DioException {
      // 任何 dio 错误 (timeout / connection / dns) 都视为该域名不可用
    } catch (_) {
      // 兜底
    }
    return null;
  }
}
