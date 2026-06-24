// Riverpod provider tree for Verstro backend
//
// 依赖图:
//   sharedPrefs ──┐
//                 ├─→ multiDomainRace ──→ activeBackendUrl ──┐
//   tokenStorage ─┴─────────────────────────────────────────┴─→ backendApi
//
// 用手写 Provider 风格 (不用 @Riverpod codegen) — Dart 3.10 跟 build_runner 2.7.1
// 有冲突 ("'dart compile' does not support build hooks"), 等 FlClash 上游升级
// 工具链后再改用 codegen 风格保持一致.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/backend_api.dart';
import '../api/multi_domain_race.dart';
import '../api/token_storage.dart';

/// SharedPreferences (异步初始化, 全 app 单例)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

/// JWT 持久化 (阶段 2.3.1: SharedPreferences; 2.6 dev team 后切 flutter_secure_storage)
final tokenStorageProvider = FutureProvider<TokenStorage>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return TokenStorage(prefs);
});

/// 多域名 race 实例
final multiDomainRaceProvider = FutureProvider<MultiDomainRace>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return MultiDomainRace(prefs: prefs);
});

/// active backend base URL (启动时 race + 缓存)
final activeBackendUrlProvider = FutureProvider<String>((ref) async {
  final race = await ref.watch(multiDomainRaceProvider.future);
  return race.resolveActiveBaseUrl();
});

/// BackendApi client (依赖 baseUrl + tokenStorage)
final backendApiProvider = FutureProvider<BackendApi>((ref) async {
  final baseUrl = await ref.watch(activeBackendUrlProvider.future);
  final token = await ref.watch(tokenStorageProvider.future);
  return BackendApi(baseUrl: baseUrl, token: token);
});
