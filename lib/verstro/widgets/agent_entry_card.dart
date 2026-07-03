// 推广中心入口卡 (由 C2 ReferralCard 演化). 挂 plan_picker + account_page. code 空→shrink. 整卡可点→推广中心.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/agent_provider.dart';
import '../pages/agent_panel_page.dart';

class AgentEntryCard extends ConsumerWidget {
  const AgentEntryCard({super.key});
  static String _usd(int c) => '\$${(c / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentAsync = ref.watch(agentProvider);
    return agentAsync.maybeWhen(
      data: (a) {
        if (a.code.isEmpty) return const SizedBox.shrink();
        final scheme = Theme.of(context).colorScheme;
        final teaser = a.availableCents > 0
            ? '推广中心 · 可提现 ${_usd(a.availableCents)}'
            : '邀请好友赚 30% 佣金';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const VerstroAgentPanelPage())),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Icon(Icons.card_giftcard, color: scheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(teaser, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text('邀请码 ${a.code} · 已邀请 ${a.directCount} 人',
                          style: Theme.of(context).textTheme.bodySmall),
                    ]),
                  ),
                  if (a.tier != 'promoter')
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Chip(label: Text(a.tier == 'master' ? '总代' : '代理'),
                          visualDensity: VisualDensity.compact),
                    ),
                  const Icon(Icons.chevron_right),
                ]),
              ),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
