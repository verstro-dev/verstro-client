// RegisterPage — Verstro 注册
//
// 阶段 2.3.1 第一版. 跟 LoginPage 几乎对称, 区别:
// - 加 "确认密码" 字段 (本机校验, 不传 backend)
// - 注册成功后调 onRegisterSuccess (默认 pop) — 上层决定是否跳邮箱验证 reminder
// - 邮箱验证非强制 (后端注册策略 "完全开放")

import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class VerstroRegisterPage extends ConsumerStatefulWidget {
  final VoidCallback? onGoToLogin;
  final VoidCallback? onRegisterSuccess;

  const VerstroRegisterPage({super.key, this.onGoToLogin, this.onRegisterSuccess});

  @override
  ConsumerState<VerstroRegisterPage> createState() => _VerstroRegisterPageState();
}

class _VerstroRegisterPageState extends ConsumerState<VerstroRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _referralCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _referralCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    await ref.read(authNotifierProvider.notifier).register(
          email: _emailCtrl.text.trim().toLowerCase(),
          password: _passwordCtrl.text,
          referralCode: _referralCtrl.text.trim(),
        );

    if (!mounted) return;
    final state = ref.read(authNotifierProvider).value;
    if (state?.isLoggedIn == true) {
      widget.onRegisterSuccess?.call();
      // 不需要手工 Navigator pop: 上层 widget (_LoginGate) ref.watch 检测
      // isLoggedIn 自动 swap widget
    }
  }

  void _gotoLogin() {
    widget.onGoToLogin?.call();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);
    final state = authAsync.value ?? const AuthState();
    final loading = authAsync.isLoading || state.loading;

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vAuthRegisterTitle)),
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
                    const SizedBox(height: 8),
                    Text(
                      appLocalizations.vAuthRegisterIntro,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('register_email_field'),
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        labelText: appLocalizations.vAuthEmailLabel,
                        border: const OutlineInputBorder(),
                        errorText: state.errorOnEmail ? state.error : null,
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return appLocalizations.vAuthEmailRequired;
                        if (!s.contains('@') || !s.contains('.')) return appLocalizations.vAuthEmailInvalid;
                        return null;
                      },
                      enabled: !loading,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('register_password_field'),
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: appLocalizations.vAuthPasswordLabelMin6,
                        border: const OutlineInputBorder(),
                        errorText: state.errorOnPassword ? state.error : null,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if ((v ?? '').isEmpty) return appLocalizations.vAuthPasswordRequired;
                        if ((v ?? '').length < 6) return appLocalizations.vAuthPasswordMin6;
                        return null;
                      },
                      enabled: !loading,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('register_confirm_field'),
                      controller: _confirmCtrl,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: appLocalizations.vAuthConfirmPasswordLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if ((v ?? '').isEmpty) return appLocalizations.vAuthConfirmPasswordRequired;
                        if (v != _passwordCtrl.text) return appLocalizations.vAuthPasswordMismatch;
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                      enabled: !loading,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _referralCtrl,
                      decoration: InputDecoration(
                        labelText: appLocalizations.vAuthReferralCodeLabel,
                        prefixIcon: const Icon(Icons.card_giftcard_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
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
                      key: const Key('register_submit_button'),
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(appLocalizations.vAuthRegisterButton),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      key: const Key('register_goto_login'),
                      onPressed: loading ? null : _gotoLogin,
                      child: Text(appLocalizations.vAuthGoToLogin),
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
