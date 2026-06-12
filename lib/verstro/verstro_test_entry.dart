// Ad-hoc 测试入口: 直接渲染 Verstro 流程, 跳过 FlClash 主路由 + clash core 初始化
//
// 用法 (任一平台):
//   flutter run -t lib/verstro/verstro_test_entry.dart -d macos
//
// 阶段 2.3.1: _LoginGate (ConsumerStatefulWidget, 内部 _showRegister bool 切换)
// 阶段 2.3.2-2.3.3: logged-in 跳 PlanPickerPage / UsdtInvoicePage
// 阶段 2.3.4: AccountPage 取代简化版 _ActiveSubscriptionScreen
//
// 路由策略 (logged-in):
//   有效订阅 → AccountPage (订阅信息 + 订单历史 + 续费按钮)
//   无订阅 / 已过期 → PlanPickerPage (强制购买)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/account_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/login_page.dart';
import 'pages/plan_picker_page.dart';
import 'pages/register_page.dart';
import 'pages/reset_password_page.dart';
import 'providers/auth_provider.dart';
import 'providers/orders_provider.dart';

void main() {
  runApp(const ProviderScope(child: _VerstroTestApp()));
}

class _VerstroTestApp extends StatelessWidget {
  const _VerstroTestApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verstro (test entry)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2DD4BF), // Verstro 品牌青
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2DD4BF), // Verstro 品牌青
          brightness: Brightness.dark,
        ),
      ),
      home: const _LoginGate(),
    );
  }
}

/// 未登录 → Login/Register, 已登录 → 根据 subscription 状态分流
class _LoginGate extends ConsumerStatefulWidget {
  const _LoginGate();

  @override
  ConsumerState<_LoginGate> createState() => _LoginGateState();
}

class _LoginGateState extends ConsumerState<_LoginGate> {
  /// 未登录 sub-screen 切换. 互斥 enum-like:
  ///   _AuthScreen.login | .register | .forgot
  _AuthScreen _screen = _AuthScreen.login;
  String _forgotPrefillEmail = '';

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);

    return authAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('启动失败: $e')),
      ),
      data: (state) {
        if (state.isLoggedIn) {
          return const _LoggedInRouter();
        }
        switch (_screen) {
          case _AuthScreen.register:
            return VerstroRegisterPage(
              onGoToLogin: () => setState(() => _screen = _AuthScreen.login),
            );
          case _AuthScreen.forgot:
            return VerstroForgotPasswordPage(
              initialEmail: _forgotPrefillEmail,
              onGoToLogin: () => setState(() => _screen = _AuthScreen.login),
              onGoToReset: () => setState(() => _screen = _AuthScreen.reset),
            );
          case _AuthScreen.reset:
            return VerstroResetPasswordPage(
              onGoToLogin: () => setState(() => _screen = _AuthScreen.login),
              onResetSuccess: () => setState(() => _screen = _AuthScreen.login),
            );
          case _AuthScreen.login:
            return VerstroLoginPage(
              onGoToRegister: () => setState(() => _screen = _AuthScreen.register),
              onGoToForgot: (currentEmail) => setState(() {
                _forgotPrefillEmail = currentEmail;
                _screen = _AuthScreen.forgot;
              }),
            );
        }
      },
    );
  }
}

enum _AuthScreen { login, register, forgot, reset }

/// 登录后入口: 有效订阅 → AccountPage; 无订阅 / 已过期 → PlanPickerPage
class _LoggedInRouter extends ConsumerWidget {
  const _LoggedInRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(subscriptionProvider);

    return subAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          title: const Text('订阅查询失败'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline,
                    size: 48, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 12),
                Text('$e', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => ref.invalidate(subscriptionProvider),
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (sub) {
        if (!sub.hasSubscription || sub.isExpired) {
          return const VerstroPlanPickerPage();
        }
        return const VerstroAccountPage();
      },
    );
  }
}
