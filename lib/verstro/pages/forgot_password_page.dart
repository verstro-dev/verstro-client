// ForgotPasswordPage — 找回密码第一步 (plan 1-2 阶段D: 改验证码流)
//
// 用户从 LoginPage 跳过来, 输 email → backend 发 6 位验证码邮件 → 自动进 ResetPasswordPage
// 输码 + 设新密码. forgot-password 恒 202 (不泄漏邮箱是否注册), 故无论是否注册都进下一步.

import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../providers/backend_api_provider.dart';

class VerstroForgotPasswordPage extends ConsumerStatefulWidget {
  /// 用户点 "返回登录" 调用. 由父 widget 切回 LoginPage.
  final VoidCallback? onGoToLogin;

  /// 发送验证码成功后调用, 把 email 带到 ResetPasswordPage (验证码 + 新密码).
  final void Function(String email)? onGoToReset;

  /// 预填邮箱 (从 LoginPage 当前输入带过来)
  final String? initialEmail;

  const VerstroForgotPasswordPage({
    super.key,
    this.onGoToLogin,
    this.onGoToReset,
    this.initialEmail,
  });

  @override
  ConsumerState<VerstroForgotPasswordPage> createState() =>
      _VerstroForgotPasswordPageState();
}

class _VerstroForgotPasswordPageState
    extends ConsumerState<VerstroForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;
  bool _busy = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _busy = true;
      _errorMsg = null;
    });

    try {
      final api = await ref.read(backendApiProvider.future);
      final email = _emailCtrl.text.trim().toLowerCase();
      await api.forgotPassword(email).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      // 恒 202 (不泄漏邮箱是否注册) → 直接进输码界面.
      widget.onGoToReset?.call(email);
    } on BackendException catch (e) {
      if (!mounted) return;
      setState(() => _errorMsg = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMsg = appLocalizations.vAuthSendFailedNetwork);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vAuthForgotPasswordTitle)),
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
                      appLocalizations.vAuthForgotIntro,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('forgot_email_field'),
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      decoration: InputDecoration(
                        labelText: appLocalizations.vAuthEmailLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return appLocalizations.vAuthEmailRequired;
                        if (!s.contains('@') || !s.contains('.')) {
                          return appLocalizations.vAuthEmailInvalid;
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                      enabled: !_busy,
                    ),
                    if (_errorMsg != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMsg!,
                        style: TextStyle(color: scheme.error),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('forgot_submit_button'),
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(appLocalizations.vAuthSendCodeButton),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      key: const Key('forgot_goto_login'),
                      onPressed: _busy ? null : widget.onGoToLogin,
                      child: Text(appLocalizations.vAuthBackToLogin),
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
