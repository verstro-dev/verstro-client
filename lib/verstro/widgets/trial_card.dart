// 三态「免费试用」卡 (C4, surface M4 试用). 挂 plan_picker(无订阅).
//   !enabled || claimed → 不显(到期回流者不见失败 CTA)
//   未验证邮箱 → 「验证邮箱后可领」+ 重发验证邮件
//   可领取 → 「N 天·XGB + 立即领取」, 领取成功 invalidate 订阅触发门控重路由账号页

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../providers/auth_provider.dart';
import '../providers/backend_api_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/trial_provider.dart';

class TrialCard extends ConsumerStatefulWidget {
  const TrialCard({super.key});
  @override
  ConsumerState<TrialCard> createState() => _TrialCardState();
}

class _TrialCardState extends ConsumerState<TrialCard> {
  bool _busy = false;

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
    );
  }

  Future<void> _claim() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final api = await ref.read(backendApiProvider.future);
      await api.claimTrial();
      if (!mounted) return;
      ref.invalidate(subscriptionProvider); // 触发门控重路由到账号页(现已有试用订阅)
      ref.invalidate(trialStatusProvider);
      _toast('试用已开通！');
    } on BackendException catch (e) {
      ref.invalidate(trialStatusProvider); // 纠正状态(已领/未开放等)
      _toast(e.message);
    } catch (e) {
      _toast('领取失败，请重试');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    try {
      final api = await ref.read(backendApiProvider.future);
      await api.resendVerification();
      _toast('验证邮件已发送，请查收后点击链接验证');
    } on BackendException catch (e) {
      _toast(e.message);
    } catch (e) {
      _toast('发送失败，请重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tsAsync = ref.watch(trialStatusProvider);
    final emailVerified =
        ref.watch(authNotifierProvider).value?.user?.isEmailVerified ?? false;
    return tsAsync.maybeWhen(
      data: (ts) {
        if (!ts.enabled || ts.claimed) return const SizedBox.shrink();
        final scheme = Theme.of(context).colorScheme;
        final title = Row(children: [
          Icon(emailVerified ? Icons.card_giftcard : Icons.mark_email_unread_outlined,
              color: scheme.primary),
          const SizedBox(width: 8),
          Text('免费试用', style: Theme.of(context).textTheme.titleMedium),
        ]);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            color: scheme.primaryContainer.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: emailVerified
                    ? [
                        title,
                        const SizedBox(height: 4),
                        Text('${ts.days} 天 · ${ts.trafficGb}GB 流量',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _busy ? null : _claim,
                            child: _busy
                                ? const SizedBox(
                                    height: 18, width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('立即领取'),
                          ),
                        ),
                      ]
                    : [
                        title,
                        const SizedBox(height: 4),
                        Text('验证邮箱后可领取 ${ts.days} 天免费试用',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _resend,
                            child: const Text('重发验证邮件'),
                          ),
                        ),
                      ],
              ),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(), // loading / error / 未登录 → 不显示
    );
  }
}
