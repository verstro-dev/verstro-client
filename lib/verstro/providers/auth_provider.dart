// AuthState + AuthNotifier
//
// 单一来源: 当前用户的 (login / loading / error) 状态.
// page 通过 ref.watch(authNotifierProvider) 拿 AsyncValue<AuthState>,
// ref.read(authNotifierProvider.notifier) 调 action.
//
// 启动时 AuthNotifier.build() 尝试 token → /me 验证. 失败清 token 视为未登录.
//
// 手写 Provider 风格 (不用 @Riverpod codegen, Dart 3.10 跟 build_runner 2.7.1 冲突).

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../api/api_models.dart';
import '../api/device_identity.dart';
import 'backend_api_provider.dart';

class AuthState {
  /// 当前已登录的用户. null = 未登录.
  final UserDto? user;

  /// login / register 调用进行中 (按钮 loading 用).
  final bool loading;

  /// 最近一次操作的错误信息.
  final String? error;

  /// 错误是否针对邮箱字段 (UI 红色高亮邮箱输入框).
  final bool errorOnEmail;

  /// 错误是否针对密码字段.
  final bool errorOnPassword;

  const AuthState({
    this.user,
    this.loading = false,
    this.error,
    this.errorOnEmail = false,
    this.errorOnPassword = false,
  });

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    UserDto? user,
    bool? loading,
    String? error,
    bool? errorOnEmail,
    bool? errorOnPassword,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      errorOnEmail: errorOnEmail ?? this.errorOnEmail,
      errorOnPassword: errorOnPassword ?? this.errorOnPassword,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final api = await ref.read(backendApiProvider.future);
    final token = await ref.read(tokenStorageProvider.future);
    if (!(await token.isLoggedIn())) {
      return const AuthState();
    }
    try {
      final user = await api.me().timeout(const Duration(seconds: 10));
      unawaited(_reportDevice()); // 已登录启动: 刷新设备 last_seen (fire-and-forget)
      return AuthState(user: user);
    } on UnauthorizedException {
      return const AuthState();
    } on TokenExpiredException {
      return const AuthState();
    } on TokenInvalidException {
      return const AuthState();
    } catch (_) {
      // 网络问题 / timeout 等: 保持未登录, 让用户主动登录重试
      return const AuthState();
    }
  }

  Future<void> register({required String email, required String password}) async {
    state = const AsyncValue.data(AuthState(loading: true));
    try {
      final api = await ref.read(backendApiProvider.future);
      final auth = await api.register(email: email, password: password)
          .timeout(const Duration(seconds: 15));
      unawaited(_reportDevice());
      state = AsyncValue.data(AuthState(user: auth.user));
    } on EmailConflictException catch (e) {
      state = AsyncValue.data(AuthState(error: e.message, errorOnEmail: true));
    } on BadRequestException catch (e) {
      state = AsyncValue.data(AuthState(error: e.message));
    } on BackendException catch (e) {
      state = AsyncValue.data(AuthState(error: e.message));
    } catch (e) {
      // 兜底: timeout / 平台错误 / 等. 错误显示到 UI 而不是 silent hang.
      state = AsyncValue.data(AuthState(error: '注册失败: $e'));
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.data(AuthState(loading: true));
    try {
      final api = await ref.read(backendApiProvider.future);
      final auth = await api.login(email: email, password: password)
          .timeout(const Duration(seconds: 15));
      unawaited(_reportDevice());
      state = AsyncValue.data(AuthState(user: auth.user));
    } on InvalidCredentialsException catch (e) {
      state = AsyncValue.data(AuthState(error: e.message, errorOnPassword: true));
    } on BackendException catch (e) {
      state = AsyncValue.data(AuthState(error: e.message));
    } catch (e) {
      // 兜底: timeout / 平台错误 / 等
      state = AsyncValue.data(AuthState(error: '登录失败: $e'));
    }
  }

  Future<void> logout() async {
    final api = await ref.read(backendApiProvider.future);
    await api.logout();
    state = const AsyncValue.data(AuthState());
  }

  void clearError() {
    final current = state.value ?? const AuthState();
    state = AsyncValue.data(current.copyWith(clearError: true));
  }

  /// 上报当前设备给 billing (T4.2). 登录/注册/已登录启动时 fire-and-forget 调.
  /// 失败 (网络/后端旧版无端点/设备信息取不到) 绝不阻塞或影响登录态 — 仅吞掉.
  Future<void> _reportDevice() async {
    try {
      final api = await ref.read(backendApiProvider.future);
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final identity = DeviceIdentity(prefs);
      await api.registerDevice(
        deviceId: identity.getOrCreateDeviceId(),
        deviceName: await DeviceIdentity.resolveDeviceName(),
        platform: DeviceIdentity.platformName(),
      );
    } catch (_) {
      // device 注册是尽力而为, 失败不影响主流程
    }
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
