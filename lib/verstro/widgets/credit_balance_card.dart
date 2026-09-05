// 套餐页只展示可用余额促购；账户页另外展示尚未入余额的订单资金。
import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_models.dart';
import '../pages/usdt_invoice_page.dart';
import '../providers/auth_provider.dart';
import '../providers/backend_api_provider.dart';
import '../providers/credit_provider.dart';
import '../util/money.dart';

class CreditBalanceCard extends ConsumerWidget {
  const CreditBalanceCard({super.key, this.alwaysShow = false});
  final bool alwaysShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    if (auth.isLoading || auth.hasError || auth.value?.isLoggedIn != true) {
      return const SizedBox.shrink();
    }
    final credit = ref.watch(creditProvider);
    // 刷新/切换账号期间不能继续展示上一份金额。
    return credit.when(
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
      loading: () => alwaysShow
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink(),
      error: (_, _) => alwaysShow
          ? TextButton.icon(
              onPressed: () => ref.invalidate(creditProvider),
              icon: const Icon(Icons.refresh),
              label: Text(appLocalizations.vAcctCreditError),
            )
          : const SizedBox.shrink(),
      data: (c) {
        if (!alwaysShow && c.balanceCents <= 0) return const SizedBox.shrink();
        final amount = '\$${centsToUsd(c.balanceCents)}';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(appLocalizations.vAcctBalanceTitle(amount)),
                  subtitle: Text(appLocalizations.vAcctBalanceSubtitle),
                ),
              ),
            ),
            if (alwaysShow &&
                (c.pendingOrderCents > 0 || c.pendingOrders.isNotEmpty))
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.vAcctPendingTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('${centsToUsd(c.pendingOrderCents)} USDT'),
                      Text(appLocalizations.vAcctPendingSubtitle),
                      for (final order in c.pendingOrders)
                        _PendingOrderRow(
                          key: ValueKey(order.orderId),
                          order: order,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PendingOrderRow extends ConsumerStatefulWidget {
  const _PendingOrderRow({super.key, required this.order});
  final PendingOrderDto order;
  @override
  ConsumerState<_PendingOrderRow> createState() => _PendingOrderRowState();
}

class _PendingOrderRowState extends ConsumerState<_PendingOrderRow> {
  Timer? _expiryTimer;
  bool _busy = false;
  bool _error = false;

  bool get _expired => !widget.order.expiresAt.isAfter(DateTime.now());

  void _scheduleExpiry() {
    _expiryTimer?.cancel();
    final delay = widget.order.expiresAt.difference(DateTime.now());
    if (delay > Duration.zero) {
      _expiryTimer = Timer(delay, () {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scheduleExpiry();
  }

  @override
  void didUpdateWidget(covariant _PendingOrderRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.expiresAt != widget.order.expiresAt) _scheduleExpiry();
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }

  Future<void> _resume() async {
    if (_busy || _expired) return;
    final userId = ref.read(authNotifierProvider).value?.user?.id;
    setState(() {
      _busy = true;
      _error = false;
    });
    try {
      // 不依赖最近 100 条订单历史，按全账户 pending 的 ID 读取最新订单。
      final api = await ref.read(backendApiProvider.future);
      final order = await api.getOrder(widget.order.orderId);
      if (!mounted) return;
      final auth = ref.read(authNotifierProvider);
      if (auth.isLoading || auth.hasError || auth.value?.user?.id != userId) {
        return;
      }
      if (_expired ||
          !order.expiresAt.isAfter(DateTime.now()) ||
          !(order.isWaiting || order.isPartiallyPaid)) {
        ref.invalidate(creditProvider);
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VerstroUsdtInvoicePage(order: order),
        ),
      );
      if (mounted) ref.invalidate(creditProvider);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#${order.orderId} · ${appLocalizations.vAcctPendingReceived} '
            '${centsToUsd(order.receivedCents)} USDT · '
            '${appLocalizations.vAcctPendingRemaining} '
            '${centsToUsd(order.remainingCents)} USDT',
          ),
          if (_expired)
            Text(appLocalizations.vAcctPendingTransfer)
          else
            TextButton(
              onPressed: _busy ? null : _resume,
              child: Text(appLocalizations.vAcctPendingContinue),
            ),
          if (_error) Text(appLocalizations.vAcctCreditError),
        ],
      ),
    );
  }
}
