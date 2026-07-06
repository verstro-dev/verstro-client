// 邮箱验证码输入表单 (plan 1-2 阶段D). 复用于账号页 (_EmailVerifyCard) + 选套餐页试用卡 (TrialCard)。
//
// 为什么共享: 未验证用户**有订阅**时只看到账号页, **无订阅**时只看到 PlanPicker(试用卡)——
// 两处都得能输验证码, 否则无订阅的未验证用户无法在 App 内验证 (只能跑官网)。
//
// 输 6 位码 → verifyEmailWithCode → refreshUser 刷新登录态 (isEmailVerified 变 true 触发父级重渲染);
// onVerified 回调供父级额外刷新 (如试用卡领取按钮)。后端发送频率另有限流, 此处 60s 按钮冷却仅 UX。

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../providers/auth_provider.dart';
import '../providers/backend_api_provider.dart';

class VerstroEmailVerifyForm extends ConsumerStatefulWidget {
  final String email;
  final VoidCallback? onVerified;

  const VerstroEmailVerifyForm({super.key, required this.email, this.onVerified});

  @override
  ConsumerState<VerstroEmailVerifyForm> createState() => _VerstroEmailVerifyFormState();
}

class _VerstroEmailVerifyFormState extends ConsumerState<VerstroEmailVerifyForm> {
  final _codeCtrl = TextEditingController();
  bool _busy = false;
  String? _error;
  int _cooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

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

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => _error = '请输入验证码');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final api = await ref.read(backendApiProvider.future);
      await api.verifyEmailWithCode(widget.email, code).timeout(const Duration(seconds: 15));
      await ref.read(authNotifierProvider.notifier).refreshUser();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('邮箱已验证 ✓')),
      );
      widget.onVerified?.call();
    } on BackendException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = '验证失败, 请检查网络后重试');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final api = await ref.read(backendApiProvider.future);
      await api.resendVerification().timeout(const Duration(seconds: 15));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码已发送, 请查收邮箱')),
      );
      _startCooldown(60);
    } on BackendException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = '发送失败, 请稍后重试');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _codeCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                enabled: !_busy,
                decoration: const InputDecoration(
                  labelText: '验证码',
                  counterText: '',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _verify(),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _busy ? null : _verify,
              child: _busy
                  ? const SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('验证'),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 6),
          Text(_error!, style: TextStyle(color: scheme.error, fontSize: 12)),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: (_busy || _cooldown > 0) ? null : _resend,
            child: Text(_cooldown > 0 ? '重新发送（$_cooldown s）' : '重新发送验证码'),
          ),
        ),
      ],
    );
  }
}
