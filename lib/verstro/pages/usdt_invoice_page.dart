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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_exceptions.dart';
import '../api/api_models.dart';
import '../providers/orders_provider.dart';
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
    if (_remaining.inSeconds <= 0) return '已过期';
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
      const SnackBar(content: Text('收款地址已复制'), duration: Duration(seconds: 2)),
    );
  }

  Future<void> _copyAmount(String amount) async {
    await Clipboard.setData(ClipboardData(text: amount));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('金额已复制 (注意保留小数位)'), duration: Duration(seconds: 2)),
    );
  }

  Future<void> _showClaimDialog(int orderId) async {
    final ctrl = TextEditingController();
    bool busy = false;
    String? error;
    String? successMsg;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => AlertDialog(
          title: const Text('我已付款'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '从 imToken / TronLink 等钱包复制刚才转账的 tx hash 粘贴到下方:',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ctrl,
                  decoration: const InputDecoration(
                    labelText: 'Transaction hash',
                    hintText: '64 字符 hex, 形如 abc1234...',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 80,
                  enabled: !busy,
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
                const SizedBox(height: 8),
                Text(
                  '⚠️ 提交后 backend 会立即查链上验证. 若金额跟订单不符,\n'
                  '走 Telegram @verstro_support 人工兜底.',
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: busy ? null : () => Navigator.of(ctx).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: busy
                  ? null
                  : () async {
                      final hash = ctrl.text.trim();
                      if (hash.length < 32) {
                        setLocalState(() => error = 'tx hash 长度异常 (应 64 字符)');
                        return;
                      }
                      setLocalState(() {
                        busy = true;
                        error = null;
                        successMsg = null;
                      });
                      try {
                        final res = await claimTx(ref, orderId, hash);
                        setLocalState(() {
                          busy = false;
                          if (res.matched) {
                            successMsg = res.message;
                          } else {
                            error = res.message;
                          }
                        });
                        if (res.matched) {
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
                          error = '提交失败: $e';
                        });
                      }
                    },
              child: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('提交验证'),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
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
      return _ExpiredScreen(order: currentOrder);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${_planLabel(currentOrder.planId)} 订单 #${currentOrder.id}'),
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
                    label: const Text('我已付款 (输入 tx hash 立即验证)'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse('https://t.me/verstro_support');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Telegram 未安装. 客服: @verstro_support'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text('联系客服 (金额错配 / 转错地址)'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '订单 24h 内未付款自动作废. 24h 内付款后, backend 30s 内自动'
                    '匹配; 点 "我已付款" 可立即触发匹配.',
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
      label = '查询订单状态...';
      icon = Icons.hourglass_top;
      color = scheme.onSurfaceVariant;
    } else if (streamAsync.hasError) {
      label = '查询失败, 继续轮询';
      icon = Icons.wifi_off;
      color = scheme.error;
    } else {
      label = '⏳ 等待付款 ... (5 秒自动刷新)';
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
        return '月付';
      case 'quarterly':
        return '季付';
      case 'yearly':
        return '年付';
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
            _AmountBreakdownRow(label: '原价', value: '\$$basePrice'),
            if (couponDiscount != null)
              _AmountBreakdownRow(label: '优惠码', value: '−\$$couponDiscount', discount: true),
            if (creditApplied != null)
              _AmountBreakdownRow(label: 'credit 抵扣', value: '−\$$creditApplied', discount: true),
            if (suffixCents > 0)
              _AmountBreakdownRow(label: '防冲突尾数', value: '+\$${centsToUsd(suffixCents)}'),
            const Divider(height: 16),
          ],
          Row(
            children: [
              Icon(Icons.warning_amber, color: scheme.error),
              const SizedBox(width: 8),
              Text(
                '请精确转账以下金额',
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
                tooltip: '复制金额',
                icon: const Icon(Icons.copy),
                onPressed: onCopy,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              hasDiscount
                  ? '多 0.01 或少 0.01 都无法自动匹配, 请检查钱包"金额"字段是否一致到小数点后 2 位.'
                  : '套餐基价 \$$basePrice + 防冲突尾数. 多 0.01 或少 0.01 都无法自动匹配,\n'
                      '请检查钱包"金额"字段是否一致到小数点后 2 位.',
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
              Text('Tron USDT 地址', style: Theme.of(context).textTheme.titleSmall),
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
                tooltip: '复制地址',
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
      appBar: AppBar(title: const Text('订阅已开通')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 96, color: Colors.green.shade400),
              const SizedBox(height: 16),
              Text(
                '付款已确认',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '订单 #${order.id}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'tx: ${order.txid ?? ""}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('回到主页'),
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

  const _ExpiredScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('订单已过期')),
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
                '订单已过期',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '订单 #${order.id} 在 24 小时内未收到付款, 已自动作废.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '如果你已经转账但金额跟订单尾数不符, 联系 Telegram\n'
                '@verstro_support 提交 tx hash 人工处理.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('返回重新下单'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
