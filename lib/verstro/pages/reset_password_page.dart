// ResetPasswordPage — 阶段 2.3.7 完整版
//
// 用户从 ForgotPasswordPage 跳过来, 输 reset token (从邮件 link 复制)
// + 新密码 + 确认 → backend resetPassword → 成功后跳回 LoginPage 让用户用新密码登录.
//
// 阶段 2.6 加 deep linking 后, 邮件 link verstro://reset?token=xxx 自动跳 app
// 并预填 token, 简化用户操作.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../providers/backend_api_provider.dart';

class VerstroResetPasswordPage extends ConsumerStatefulWidget {
  /// 重置成功后调用. 由父 widget 切回 LoginPage 用新密码登录.
  final VoidCallback? onResetSuccess;

  /// 用户点 "返回登录" 调用. 同上, 切回 LoginPage.
  final VoidCallback? onGoToLogin;

  /// 预填 token (deep linking 阶段 2.6 用; 现阶段总是空)
  final String? initialToken;

  const VerstroResetPasswordPage({
    super.key,
    this.onResetSuccess,
    this.onGoToLogin,
    this.initialToken,
  });

  @override
  ConsumerState<VerstroResetPasswordPage> createState() =>
      _VerstroResetPasswordPageState();
}

class _VerstroResetPasswordPageState
    extends ConsumerState<VerstroResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tokenCtrl;
  final _newPasswordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _busy = false;
  String? _errorMsg;
  bool _succeeded = false;

  @override
  void initState() {
    super.initState();
    _tokenCtrl = TextEditingController(text: widget.initialToken ?? '');
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmCtrl.dispose();
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
      await api
          .resetPassword(_tokenCtrl.text.trim(), _newPasswordCtrl.text)
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
      setState(() => _errorMsg = '重置失败, 检查 token 是否过期 (1 小时有效)');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_succeeded) return _SuccessView(scheme: scheme);

    return Scaffold(
      appBar: AppBar(title: const Text('重置密码')),
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
                      '从重置邮件复制 reset token (链接里 ?token= 后面那串),\n'
                      '粘贴到下方 + 设置新密码.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('reset_token_field'),
                      controller: _tokenCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Reset token',
                        hintText: '32-64 字符',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !_busy,
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return '请粘贴 reset token';
                        if (s.length < 16) return 'token 长度异常 (应至少 16 字符)';
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
                        labelText: '新密码 (≥ 6 位)',
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
                        if ((v ?? '').isEmpty) return '请填新密码';
                        if ((v ?? '').length < 6) return '密码至少 6 位';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('reset_confirm_field'),
                      controller: _confirmCtrl,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: const InputDecoration(
                        labelText: '确认新密码',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !_busy,
                      validator: (v) {
                        if ((v ?? '').isEmpty) return '请再次输入新密码';
                        if (v != _newPasswordCtrl.text) return '两次密码不一致';
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
                          : const Text('重置密码'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      key: const Key('reset_goto_login'),
                      onPressed: _busy ? null : widget.onGoToLogin,
                      child: const Text('返回登录'),
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
      appBar: AppBar(title: const Text('重置成功')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 80, color: Colors.green.shade400),
              const SizedBox(height: 16),
              Text(
                '密码已重置',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '即将跳回登录页, 请用新密码登录.',
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
