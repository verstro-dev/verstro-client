// 可抵扣余额卡 (C1). 仅在 balance>0 时渲染; 否则 SizedBox.shrink (非侵入).
// 两处复用: PlanPickerPage(套餐列表上方, 促购) + AccountPage(订阅卡后).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/credit_provider.dart';

class CreditBalanceCard extends ConsumerWidget {
  const CreditBalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditAsync = ref.watch(creditProvider);
    return creditAsync.maybeWhen(
      data: (c) {
        if (c.balanceCents <= 0) return const SizedBox.shrink();
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
                      Text('可抵扣余额  $amount',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text('购买时自动抵扣',
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
