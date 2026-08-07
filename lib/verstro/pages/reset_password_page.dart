// ResetPasswordPage — 找回密码第二步 (plan 1-2 阶段D: 验证码流)
//
// 从 ForgotPasswordPage 发码后进入 (带 email). 用户输 6 位验证码 + 新密码 + 确认
// → backend resetPasswordWithCode → 成功后跳回 LoginPage 用新密码登录.
// 旧链接 token 流已弃 (邮件现在发码不发链接).

import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../providers/backend_api_provider.dart';

class VerstroResetPasswordPage extends ConsumerStatefulWidget {
  /// 找回密码第一步带过来的邮箱 (验证码发往此邮箱).
  final String email;

  /// 重置成功后调用. 由父 widget 切回 LoginPage 用新密码登录.
  final VoidCallback? onResetSuccess;

  /// 用户点 "返回登录" 调用. 同上, 切回 LoginPage.
  final VoidCallback? onGoToLogin;

  const VerstroResetPasswordPage({
    super.key,
    required this.email,
    this.onResetSuccess,
    this.onGoToLogin,
  });

  @override
  ConsumerState<VerstroResetPasswordPage> createState() =>
      _VerstroResetPasswordPageState();
}

class _VerstroResetPasswordPageState
    extends ConsumerState<VerstroResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _busy = false;
  String? _errorMsg;
  bool _succeeded = false;
  int _cooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmCtrl.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  // 重发倒计时 (UX): 后端另有发送频率限流, 此处只是按钮冷却.
  void _startCooldown([int secs = 60]) {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = secs);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _cooldown--);
      if (_cooldown <= 0) t.cancel();
    });
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
      await api
          .resetPasswordWithCode(
              widget.email, _codeCtrl.text.trim(), _newPasswordCtrl.text)
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() => _succeeded = true);
      // 显示成功 message 2s 让用户看到 → 自动跳回 LoginPage
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      widget.onResetSuccess?.call();
    } on BackendException catch (e) {
      if (!mounted) return;
      setState(() => _errorMsg = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMsg = appLocalizations.vAuthResetFailedNetwork);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _busy = true;
      _errorMsg = null;
    });
    try {
      final api = await ref.read(backendApiProvider.future);
      await api.forgotPassword(widget.email).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.vAuthCodeResent)),
      );
      _startCooldown(60);
    } on BackendException catch (e) {
      if (mounted) setState(() => _errorMsg = e.message);
    } catch (_) {
      if (mounted) setState(() => _errorMsg = appLocalizations.vAuthSendFailedRetry);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_succeeded) return _SuccessView(scheme: scheme);

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vAuthResetPasswordTitle)),
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
                      appLocalizations.vAuthResetIntro(widget.email),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('reset_code_field'),
                      controller: _codeCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: appLocalizations.vAuthCodeLabel,
                        hintText: appLocalizations.vAuthCodeHint,
                        counterText: '',
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !_busy,
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return appLocalizations.vAuthCodeRequired;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('reset_new_password_field'),
                      controller: _newPasswordCtrl,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: appLocalizations.vAuthNewPasswordLabelMin8,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      enabled: !_busy,
                      validator: (v) {
                        if ((v ?? '').isEmpty) return appLocalizations.vAuthNewPasswordRequired;
                        if ((v ?? '').length < 8) return appLocalizations.vAuthPasswordMin8;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('reset_confirm_field'),
                      controller: _confirmCtrl,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: appLocalizations.vAuthConfirmNewPasswordLabel,
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !_busy,
                      validator: (v) {
                        if ((v ?? '').isEmpty) return appLocalizations.vAuthConfirmNewPasswordRequired;
                        if (v != _newPasswordCtrl.text) return appLocalizations.vAuthPasswordMismatch;
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
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
                      key: const Key('reset_submit_button'),
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(appLocalizations.vAuthResetPasswordTitle),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      key: const Key('reset_resend'),
                      onPressed: (_busy || _cooldown > 0) ? null : _resend,
                      child: Text(_cooldown > 0
                          ? appLocalizations.vAuthResendCooldown(_cooldown)
                          : appLocalizations.vAuthResendCodeLink),
                    ),
                    TextButton(
                      key: const Key('reset_goto_login'),
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

class _SuccessView extends StatelessWidget {
  final ColorScheme scheme;

  const _SuccessView({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vAuthResetSuccessTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 80, color: Colors.green.shade400),
              const SizedBox(height: 16),
              Text(
                appLocalizations.vAuthPasswordResetDone,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                appLocalizations.vAuthResetSuccessDesc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
