// 账户余额卡 (C1). 两处复用: PlanPickerPage(套餐列表上方, 促购, balance>0 才显示)
// + AccountPage(订阅卡后, alwaysShow 常驻 —— 0 也显示, 让"多付/少付自动入余额"机制可发现).

import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/credit_provider.dart';

class CreditBalanceCard extends ConsumerWidget {
  const CreditBalanceCard({super.key, this.alwaysShow = false});

  /// true 时余额为 0 也渲染 ($0.00); false 保持 >0 才显示的促购语义.
  final bool alwaysShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditAsync = ref.watch(creditProvider);
    return creditAsync.maybeWhen(
      data: (c) {
        if (!alwaysShow && c.balanceCents <= 0) return const SizedBox.shrink();
        final amount = '\$${(c.balanceCents / 100).toStringAsFixed(2)}';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocalizations.vAcctBalanceTitle(amount),
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(appLocalizations.vAcctBalanceSubtitle,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
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
