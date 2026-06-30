// VerstroGate — FlClash main.dart 集成 (阶段 2.3.6)
//
// 在 FlClash Application 外层包一个 auth gate. 未登录 / 无订阅时显示 Verstro
// Login/Register/PlanPicker/UsdtInvoice; 登录后有效订阅时渲染 child (FlClash
// Application), 进入 Mihomo core + 主页. 强制用户必须经 Verstro 流程.
//
// 跟 verstro_test_entry.dart 的 _LoginGate 区别:
// - VerstroGate 是 production main.dart 用的, logged-in 渲染 FlClash Application
// - _LoginGate 是 alpha 测试 entry 用的, logged-in 渲染 简化 AccountPage / PlanPicker
//
// 自动 import + 设默认配置逻辑在 application.dart initState 内 (verstroAutoIntegrate),
// VerstroGate 只负责门禁判定.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/forgot_password_page.dart';
import 'pages/login_page.dart';
import 'pages/plan_picker_page.dart';
import 'pages/register_page.dart';
import 'pages/reset_password_page.dart';
import 'providers/auth_provider.dart';
import 'providers/orders_provider.dart';

class VerstroGate extends ConsumerStatefulWidget {
  /// 登录后有效订阅时渲染的 widget. 通常是 FlClash Application.
  final Widget child;

  const VerstroGate({super.key, required this.child});

  @override
  ConsumerState<VerstroGate> createState() => _VerstroGateState();
}

class _VerstroGateState extends ConsumerState<VerstroGate> {
  _AuthScreen _screen = _AuthScreen.login;
  String _forgotPrefillEmail = '';
  String _resetEmail = ''; // 找回密码: forgot 发码后带到 reset 页 (验证码发往此邮箱)

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);

    return authAsync.when(
      loading: () => const _BootSplash(),
      error: (e, _) => _BootError(error: e),
      data: (state) {
        if (state.isLoggedIn) {
          return _SubscriptionGate(child: widget.child);
        }
        return _buildAuthScreen();
      },
    );
  }

  Widget _buildAuthScreen() {
    switch (_screen) {
      case _AuthScreen.register:
        return _scaffoldThemeWrap(
          VerstroRegisterPage(
            onGoToLogin: () => setState(() => _screen = _AuthScreen.login),
          ),
        );
      case _AuthScreen.forgot:
        return _scaffoldThemeWrap(
          VerstroForgotPasswordPage(
            initialEmail: _forgotPrefillEmail,
            onGoToLogin: () => setState(() => _screen = _AuthScreen.login),
            onGoToReset: (email) => setState(() {
              _resetEmail = email;
              _screen = _AuthScreen.reset;
            }),
          ),
        );
      case _AuthScreen.reset:
        return _scaffoldThemeWrap(
          VerstroResetPasswordPage(
            email: _resetEmail,
            onGoToLogin: () => setState(() => _screen = _AuthScreen.login),
            onResetSuccess: () => setState(() => _screen = _AuthScreen.login),
          ),
        );
      case _AuthScreen.login:
        return _scaffoldThemeWrap(
          VerstroLoginPage(
            onGoToRegister: () => setState(() => _screen = _AuthScreen.register),
            onGoToForgot: (email) => setState(() {
              _forgotPrefillEmail = email;
              _screen = _AuthScreen.forgot;
            }),
          ),
        );
    }
  }

  /// auth screen 是 Verstro 自己的 widget, 没在 FlClash 的 MaterialApp 内.
  /// 用一个最小 MaterialApp 包它, 提供基础 theme + navigator.
  Widget _scaffoldThemeWrap(Widget page) {
    return MaterialApp(
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
      home: page,
    );
  }
}

enum _AuthScreen { login, register, forgot, reset }

/// 已登录后的下一道关: 订阅有效 → child (FlClash Application);
/// 无订阅/已过期 → 强制 PlanPicker (购买后才进 FlClash).
class _SubscriptionGate extends ConsumerWidget {
  final Widget child;

  const _SubscriptionGate({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(subscriptionProvider);

    return subAsync.when(
      loading: () => const _BootSplash(message: '查询订阅状态...'),
      error: (e, _) => _wrapTheme(
        Scaffold(
          appBar: AppBar(
            title: const Text('订阅查询失败'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () =>
                    ref.read(authNotifierProvider.notifier).logout(),
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
      ),
      data: (sub) {
        if (!sub.hasSubscription || sub.isExpired) {
          return _wrapTheme(const VerstroPlanPickerPage());
        }
        // 有效订阅 → 渲染 FlClash Application (它自己有 MaterialApp + navigator)
        return child;
      },
    );
  }

  Widget _wrapTheme(Widget page) {
    return MaterialApp(
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
      home: page,
    );
  }
}

/// 启动 splash. Auth bootstrap (race + token verify + /me) 时显示.
class _BootSplash extends StatelessWidget {
  final String? message;

  const _BootSplash({this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2DD4BF), // Verstro 品牌青
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Verstro 品牌 logo (替代原 deepPurple 盾牌占位)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 88,
                  height: 88,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Verstro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BootError extends StatelessWidget {
  final Object error;

  const _BootError({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 64, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text(
                  '启动失败',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
