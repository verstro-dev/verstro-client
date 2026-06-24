// ForgotPasswordPage — 阶段 2.3.7
//
// 用户从 LoginPage 跳过来, 输 email → backend 发 reset 邮件.
// 邮件含 reset token, 用户从邮件 link 跳浏览器进 reset 页 (阶段 2.6 加 deep
// linking 跳回 app 输新密码; 当前 backend 没自带 web reset 页, 留 task).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../providers/backend_api_provider.dart';

class VerstroForgotPasswordPage extends ConsumerStatefulWidget {
  /// 用户点 "返回登录" 调用. 由父 widget 切回 LoginPage.
  final VoidCallback? onGoToLogin;

  /// 用户点 "我有 reset token" 调用. 切到 ResetPasswordPage.
  final VoidCallback? onGoToReset;

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
  String? _successMsg;
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
      _successMsg = null;
      _errorMsg = null;
    });

    try {
      final api = await ref.read(backendApiProvider.future);
      await api
          .forgotPassword(_emailCtrl.text.trim().toLowerCase())
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() {
        _successMsg = '重置邮件已发送 ✉\n'
            '请检查邮箱 (含垃圾邮件箱), 按邮件指引重置密码.\n'
            '链接 1 小时内有效.';
      });
    } on BackendException catch (e) {
      if (!mounted) return;
      setState(() => _errorMsg = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMsg = '发送失败, 请检查网络或稍后重试');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('忘记密码')),
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
                      '输入你的注册邮箱, 我们会发送密码重置链接.',
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
                      decoration: const InputDecoration(
                        labelText: '邮箱',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return '请填邮箱';
                        if (!s.contains('@') || !s.contains('.')) {
                          return '邮箱格式不对';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                      enabled: !_busy && _successMsg == null,
                    ),
                    if (_errorMsg != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMsg!,
                        style: TextStyle(color: scheme.error),
                      ),
                    ],
                    if (_successMsg != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _successMsg!,
                          style: TextStyle(color: Colors.green.shade800),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (_successMsg == null)
                      FilledButton(
                        key: const Key('forgot_submit_button'),
                        onPressed: _busy ? null : _submit,
                        child: _busy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('发送重置邮件'),
                      ),
                    const SizedBox(height: 8),
                    TextButton(
                      key: const Key('forgot_goto_reset'),
                      onPressed: _busy ? null : widget.onGoToReset,
                      child: const Text('我已收到邮件, 输入 reset token →'),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      key: const Key('forgot_goto_login'),
                      onPressed: _busy ? null : widget.onGoToLogin,
                      child: const Text('返回登录'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '⚠️ 阶段 2.3.7: 从邮件链接里复制 ?token= 后的字符串,\n'
                      '粘贴到 reset 页. 阶段 2.6 deep linking 后自动预填.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
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
