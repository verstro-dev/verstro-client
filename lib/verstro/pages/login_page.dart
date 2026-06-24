// LoginPage — Verstro 登录
//
// 阶段 2.3.1 第一版, 用 Material 默认组件 (后续阶段 2.5 品牌化时换主题).
// 不直接集成到 FlClash 主路由 (那是阶段 2.4 工作), 现在作为独立 widget 提供, 由
// 任何 Navigator.push 唤起.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/backend_api_provider.dart';

class VerstroLoginPage extends ConsumerStatefulWidget {
  /// 用户点 "立即注册" 时调用. 由调用方控制切换 RegisterPage (不用 Navigator
  /// pushReplacement, 避免 _LoginGate home 被 stack 上 route cover 的 bug).
  final VoidCallback? onGoToRegister;

  /// 用户点 "忘记密码" 时调用. 由调用方控制切换 ForgotPasswordPage,
  /// 把当前邮箱字段值带过去预填.
  final void Function(String currentEmail)? onGoToForgot;

  /// 登录成功后调用. 阶段 2.4 集成时由上层处理跳主屏.
  final VoidCallback? onLoginSuccess;

  const VerstroLoginPage({
    super.key,
    this.onGoToRegister,
    this.onGoToForgot,
    this.onLoginSuccess,
  });

  @override
  ConsumerState<VerstroLoginPage> createState() => _VerstroLoginPageState();
}

class _VerstroLoginPageState extends ConsumerState<VerstroLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // 预填上次登录邮箱 (方便回头用户)
    _prefillEmail();
  }

  Future<void> _prefillEmail() async {
    final token = await ref.read(tokenStorageProvider.future);
    final email = await token.getEmail();
    if (email != null && mounted && _emailCtrl.text.isEmpty) {
      _emailCtrl.text = email;
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    await ref.read(authNotifierProvider.notifier).login(
          email: _emailCtrl.text.trim().toLowerCase(),
          password: _passwordCtrl.text,
        );

    if (!mounted) return;
    final state = ref.read(authNotifierProvider).value;
    if (state?.isLoggedIn == true) {
      widget.onLoginSuccess?.call();
      // 不需要手工 Navigator pop: 上层 widget (_LoginGate) ref.watch 检测
      // isLoggedIn 自动 swap widget
    }
  }

  void _gotoRegister() {
    widget.onGoToRegister?.call();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);
    final state = authAsync.value ?? const AuthState();
    final loading = authAsync.isLoading || state.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('登录 Verstro')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('login_email_field'),
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email, AutofillHints.username],
                      decoration: InputDecoration(
                        labelText: '邮箱',
                        border: const OutlineInputBorder(),
                        errorText: state.errorOnEmail ? state.error : null,
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return '请填邮箱';
                        if (!s.contains('@') || !s.contains('.')) return '邮箱格式不对';
                        return null;
                      },
                      enabled: !loading,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('login_password_field'),
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: '密码',
                        border: const OutlineInputBorder(),
                        errorText: state.errorOnPassword ? state.error : null,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if ((v ?? '').isEmpty) return '请填密码';
                        if ((v ?? '').length < 6) return '密码至少 6 位';
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                      enabled: !loading,
                    ),
                    if (state.error != null &&
                        !state.errorOnEmail &&
                        !state.errorOnPassword) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('login_submit_button'),
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('登录'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      key: const Key('login_goto_forgot'),
                      onPressed: loading
                          ? null
                          : () => widget.onGoToForgot
                              ?.call(_emailCtrl.text.trim()),
                      child: const Text('忘记密码?'),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      key: const Key('login_goto_register'),
                      onPressed: loading ? null : _gotoRegister,
                      child: const Text('没有账号? 立即注册'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
