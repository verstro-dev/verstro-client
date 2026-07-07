// UsdtInvoicePage — Verstro 核心商业页面
//
// 用户从 PlanPickerPage 选套餐后, backend 创建 order 跳到此页. 流程:
// 1. 显示 USDT 收款地址 (QR + 文字) + 精确金额 (含 cents 尾数, 高亮警告)
// 2. 用户用 imToken / TronLink 等钱包扫 QR 或复制地址, 转账精确金额
// 3. 自动 5s 轮询 GET /v1/orders/{id} 看 status
// 4. 用户可点 "我已付款" 提交 tx hash → backend 立即匹配 (避免等 30s)
// 5. status='finished' → 显示订阅成功屏 + 客户端自动 refresh subscription
// 6. status='expired' (24h) → 显示订单过期屏
//
// cents 尾数策略 (docs/decisions.md § why-self-hosted-tron-collection-alpha):
// final_amount = base + (order_id * 7) % 100 cents. 用户必须精确匹配.
// 多 0.01 / 少 0.01 都无法自动匹配, 走 Telegram 人工兜底.

import 'dart:async';

import 'package:fl_clash/common/common.dart' show appLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_exceptions.dart';
import '../api/api_models.dart';
import '../providers/credit_provider.dart';
import '../providers/orders_provider.dart';
import '../util/claim_display.dart';
import '../util/money.dart';

class VerstroUsdtInvoicePage extends ConsumerStatefulWidget {
  final OrderDto order;

  const VerstroUsdtInvoicePage({super.key, required this.order});

  @override
  ConsumerState<VerstroUsdtInvoicePage> createState() => _VerstroUsdtInvoicePageState();
}

class _VerstroUsdtInvoicePageState extends ConsumerState<VerstroUsdtInvoicePage> {
  Timer? _countdownTimer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _updateRemaining();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final remaining = widget.order.expiresAt.difference(DateTime.now());
    if (mounted) {
      setState(() => _remaining = remaining.isNegative ? Duration.zero : remaining);
    }
  }

  String _formatRemaining() {
    if (_remaining.inSeconds <= 0) return appLocalizations.vPayCountdownExpired;
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  Future<void> _copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(appLocalizations.vPayAddressCopied),
          duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _copyAmount(String amount) async {
    await Clipboard.setData(ClipboardData(text: amount));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(appLocalizations.vPayAmountCopied),
          duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _showClaimDialog(int orderId) async {
    final ctrl = TextEditingController();
    bool busy = false;
    String? error;
    String? successMsg;
    // credited_underpay / credited_expired 终态: 到账金额已入余额,
    // 弹窗转"重新下单 (余额自动抵扣)"引导, 主按钮 pop(true) 由调用方收尾.
    String? creditedMsg;

    final reorder = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => AlertDialog(
          title: Text(appLocalizations.vPayIHavePaid),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizations.vPayClaimInstruction,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    labelText: 'Transaction hash',
                    hintText: appLocalizations.vPayTxHashHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 80,
                  enabled: !busy && creditedMsg == null,
                  autofocus: true,
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(error!,
                        style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                  ),
                if (successMsg != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(successMsg!,
                        style: const TextStyle(color: Colors.green)),
                  ),
                // 到账已入余额 (少付/过期到账): 信息样式展示后端 message
                if (creditedMsg != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline,
                              size: 18,
                              color: Theme.of(ctx).colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(creditedMsg!)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  appLocalizations.vPayClaimNote,
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: creditedMsg != null
              ? [
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(appLocalizations.vPayReorderWithCredit),
                  ),
                ]
              : [
                  TextButton(
                    onPressed: busy ? null : () => Navigator.of(ctx).pop(),
                    child: Text(appLocalizations.cancel),
                  ),
                  FilledButton(
                    onPressed: busy
                        ? null
                        : () async {
                            final hash = ctrl.text.trim();
                            if (hash.length < 32) {
                              setLocalState(() =>
                                  error = appLocalizations.vPayTxHashLengthError);
                              return;
                            }
                            setLocalState(() {
                              busy = true;
                              error = null;
                              successMsg = null;
                            });
                            try {
                              final res = await claimTx(ref, orderId, hash);
                              // resolution → 本地化文案 (见 claim_display.dart); 不再消费后端 message
                              final d = localizedClaim(res);
                              final success = d.kind == ClaimKind.success;
                              setLocalState(() {
                                busy = false;
                                if (d.kind == ClaimKind.credited) {
                                  creditedMsg = d.text;
                                } else if (success) {
                                  successMsg = d.text;
                                } else {
                                  // matched_other_order / already_processed /
                                  // rejected_manual / verify_failed: 红字常驻本地化文案
                                  error = d.text;
                                }
                              });
                              if (success) {
                                await Future.delayed(const Duration(seconds: 2));
                                // 用 ctx.mounted 判断 dialog 自身是否还在
                                if (ctx.mounted) Navigator.of(ctx).pop();
                                // 主页 stream 5s 内会探到 finished, 自动跳成功屏
                              }
                            } on BackendException catch (e) {
                              setLocalState(() {
                                busy = false;
                                error = e.message;
                              });
                            } catch (e) {
                              setLocalState(() {
                                busy = false;
                                error = appLocalizations.vPaySubmitFailed('$e');
                              });
                            }
                          },
                    child: busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(appLocalizations.vPaySubmitVerify),
                  ),
                ],
        ),
      ),
    );
    ctrl.dispose();
    // 到账已入余额: 刷新 credit 余额 + 订单列表, 关本页回选套餐页 (重新下单自动抵扣)
    if (reorder == true && mounted) {
      ref.invalidate(creditProvider);
      ref.invalidate(ordersListProvider);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听订单状态变化 (5s 轮询)
    final streamAsync = ref.watch(orderDetailStreamProvider(widget.order.id));
    final currentOrder = streamAsync.value ?? widget.order;

    // 如果已 finished 或 expired, 显示终态屏
    if (currentOrder.isFinished) {
      return _SuccessScreen(order: currentOrder);
    }
    if (currentOrder.isExpired) {
      // expired 订单现在也可以 claim (少付/过期到账自动入余额), 弹同一个 claim 弹窗
      return _ExpiredScreen(
        order: currentOrder,
        onClaim: () => _showClaimDialog(currentOrder.id),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.vPayOrderTitle(
            _planLabel(currentOrder.planId), currentOrder.id)),
        actions: [
          // 倒计时显示在 AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                _formatRemaining(),
                style: TextStyle(
                  color: _remaining.inMinutes < 10
                      ? Theme.of(context).colorScheme.error
                      : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 金额高亮卡片
                  _AmountCard(
                    amount: currentOrder.finalAmount,
                    basePrice: currentOrder.basePrice,
                    couponDiscount: currentOrder.couponDiscount,
                    creditApplied: currentOrder.creditApplied,
                    onCopy: () => _copyAmount(currentOrder.finalAmount),
                  ),
                  const SizedBox(height: 20),
                  // QR 码 + 地址
                  if (currentOrder.depositAddress != null)
                    _AddressCard(
                      address: currentOrder.depositAddress!,
                      onCopy: () => _copyAddress(currentOrder.depositAddress!),
                    ),
                  const SizedBox(height: 20),
                  _statusRow(streamAsync),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => _showClaimDialog(currentOrder.id),
                    icon: const Icon(Icons.check_circle),
                    label: Text(appLocalizations.vPayIHavePaidWithHash),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse('https://t.me/VerstroSupportBot?start=payment');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(appLocalizations.vPayTelegramNotInstalled),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.support_agent),
                    label: Text(appLocalizations.vPayContactSupport),
                  ),
                  const SizedBox(height: 16),
                  // 交易所提币手续费警告: 到账少于应付是最高频的匹配失败原因
                  const _FeeWarningCard(),
                  const SizedBox(height: 12),
                  Text(
                    appLocalizations.vPayOrderFooterNote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusRow(AsyncValue<OrderDto> streamAsync) {
    final scheme = Theme.of(context).colorScheme;
    String label;
    IconData icon;
    Color color;
    if (streamAsync.isLoading) {
      label = appLocalizations.vPayStatusChecking;
      icon = Icons.hourglass_top;
      color = scheme.onSurfaceVariant;
    } else if (streamAsync.hasError) {
      label = appLocalizations.vPayStatusQueryFailed;
      icon = Icons.wifi_off;
      color = scheme.error;
    } else {
      label = appLocalizations.vPayStatusWaiting;
      icon = Icons.access_time;
      color = scheme.primary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }

  String _planLabel(String planId) {
    switch (planId) {
      case 'monthly':
        return appLocalizations.vPayPlanMonthly;
      case 'quarterly':
        return appLocalizations.vPayPlanQuarterly;
      case 'yearly':
        return appLocalizations.vPayPlanYearly;
      default:
        return planId;
    }
  }
}

// ============================================================
// 子组件
// ============================================================

class _AmountCard extends StatelessWidget {
  final String amount;
  final String basePrice;
  final String? couponDiscount;
  final String? creditApplied;
  final VoidCallback onCopy;

  const _AmountCard({
    required this.amount,
    required this.basePrice,
    this.couponDiscount,
    this.creditApplied,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bool hasDiscount = couponDiscount != null || creditApplied != null;
    final int suffixCents = hasDiscount
        ? couponSuffixCents(amount, basePrice, couponDiscount, creditApplied)
        : 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.error, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDiscount) ...[
            _AmountBreakdownRow(
                label: appLocalizations.vPayBasePriceLabel, value: '\$$basePrice'),
            if (couponDiscount != null)
              _AmountBreakdownRow(
                  label: appLocalizations.vPayCouponDiscountLabel,
                  value: '−\$$couponDiscount',
                  discount: true),
            if (creditApplied != null)
              _AmountBreakdownRow(
                  label: appLocalizations.vPayCreditAppliedLabel,
                  value: '−\$$creditApplied',
                  discount: true),
            if (suffixCents > 0)
              _AmountBreakdownRow(
                  label: appLocalizations.vPayAntiCollisionSuffixLabel,
                  value: '+\$${centsToUsd(suffixCents)}'),
            const Divider(height: 16),
          ],
          Row(
            children: [
              Icon(Icons.warning_amber, color: scheme.error),
              const SizedBox(width: 8),
              Text(
                appLocalizations.vPayExactAmountWarning,
                style: TextStyle(
                  color: scheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: SelectableText(
                  amount,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                ),
              ),
              const Text('USDT-TRC20', style: TextStyle(fontWeight: FontWeight.w500)),
              IconButton(
                tooltip: appLocalizations.vPayCopyAmount,
                icon: const Icon(Icons.copy),
                onPressed: onCopy,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              hasDiscount
                  ? appLocalizations.vPayAmountMismatchNote
                  : appLocalizations.vPayAmountMismatchNoteWithBase(basePrice),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// invoice 折扣明细行 (C3). label 左, value 右; discount=true 用次要色.
class _AmountBreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool discount;

  const _AmountBreakdownRow({required this.label, required this.value, this.discount = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  color: discount ? scheme.primary : null,
                  fontWeight: discount ? FontWeight.w600 : null,
                ),
          ),
        ],
      ),
    );
  }
}

/// 交易所提币手续费警告卡 — 放付款说明区上方.
///
/// 交易所提币扣网络手续费导致"到账数量 < 应付金额"是自动匹配失败的最高频原因;
/// 新契约下多付/少付都会入余额自救, 但最好一开始就把量填对.
class _FeeWarningCard extends StatelessWidget {
  const _FeeWarningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, size: 18, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  appLocalizations.vPayFeeWarningTitle,
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            appLocalizations.vPayFeeWarningBody,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String address;
  final VoidCallback onCopy;

  const _AddressCard({required this.address, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // QR 码 (白底, 暗色模式下也可扫)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: QrImageView(
              data: address,
              version: QrVersions.auto,
              size: 220,
              gapless: false,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, size: 18),
              const SizedBox(width: 6),
              Text(appLocalizations.vPayTronAddressTitle,
                  style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  address,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
              IconButton(
                tooltip: appLocalizations.vPayCopyAddress,
                icon: const Icon(Icons.copy),
                onPressed: onCopy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuccessScreen extends ConsumerWidget {
  final OrderDto order;

  const _SuccessScreen({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 订阅刷新一下 (subscriptionProvider 自动 react), 让父 widget tree 看到新状态
    Future.microtask(() => ref.invalidate(subscriptionProvider));

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vPaySubscriptionActivated)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 96, color: Colors.green.shade400),
              const SizedBox(height: 16),
              Text(
                appLocalizations.vPayPaymentConfirmed,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                appLocalizations.vPayOrderNumber(order.id),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'tx: ${order.txid ?? ""}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: Text(appLocalizations.vPayBackToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpiredScreen extends StatelessWidget {
  final OrderDto order;
  // expired 订单现在也可以 claim (新契约 credited_expired: 到账自动入余额)
  final VoidCallback onClaim;

  const _ExpiredScreen({required this.order, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vPayOrderExpiredTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time_filled,
                  size: 96, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(
                appLocalizations.vPayOrderExpiredTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                appLocalizations.vPayOrderExpiredDesc(order.id),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                appLocalizations.vPayExpiredClaimHint,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: onClaim,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(appLocalizations.vPayIHavePaidSubmitTx),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(appLocalizations.vPayBackToReorder),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
