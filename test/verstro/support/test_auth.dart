import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestAuth extends AuthNotifier {
  static AuthState user(int id) => AuthState(
    user: UserDto(
      id: id,
      email: '$id@example.test',
      emailVerifiedAt: null,
      createdAt: DateTime.utc(2026),
    ),
  );
  @override
  Future<AuthState> build() async => user(1);
  void switchUser(int id) => state = AsyncData(user(id));
  void loading() {
    // 构造认证刷新保留旧值的真实 Riverpod 状态，验证消费者不读取旧账号。
    // ignore: invalid_use_of_internal_member
    state = const AsyncLoading<AuthState>().copyWithPrevious(state);
  }

  void logoutForTest() => state = const AsyncData(AuthState());
}
