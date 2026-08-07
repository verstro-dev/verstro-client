// 推广中心入口卡 (由 C2 ReferralCard 演化). 挂 plan_picker + account_page. code 空→shrink. 整卡可点→推广中心.
// title 固定「推广中心」保证导航清晰; 利益点放 subtitle; 可提现金额右置 (仅 >0 时显示).
import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_models.dart';
import '../providers/agent_provider.dart';
import '../pages/agent_panel_page.dart';

class AgentEntryCard extends ConsumerWidget {
  const AgentEntryCard({super.key});
  static String _usd(int c) => '\$${(c / 100).toStringAsFixed(2)}';

  static String? _partnerLabel(PartnerAuthorizationDto? authorization) {
    if (authorization == null || !authorization.isVerified) return null;
    switch (authorization.level) {
      case 'certified_affiliate':
        return appLocalizations.vPartnerCertifiedAffiliate;
      case 'certified_reseller':
        return appLocalizations.vPartnerCertifiedReseller;
      case 'strategic_distributor':
        return appLocalizations.vPartnerStrategicDistributor;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentAsync = ref.watch(agentProvider);
    return agentAsync.maybeWhen(
      data: (a) {
        if (a.code.isEmpty) return const SizedBox.shrink();
        final scheme = Theme.of(context).colorScheme;
        final partnerLabel = _partnerLabel(a.partnerAuthorization);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VerstroAgentPanelPage(),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard, color: scheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appLocalizations.vAcctAgentCenter,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appLocalizations.vAcctAgentEntrySubtitle(
                              a.directCount,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (partnerLabel != null) ...[
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Chip(
                                label: Text(partnerLabel),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (a.availableCents > 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          appLocalizations.vAcctAgentWithdrawable(
                            _usd(a.availableCents),
                          ),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
