// PlanPickerPage — Verstro 选套餐
//
// 3 档套餐卡片. 用户点 "选择" → 创建订单 → 跳 UsdtInvoicePage.
//
// 注意阶段 2.0 决策 (docs/decisions.md § why-self-hosted-tron-collection-alpha):
// NOWPayments min $19.20 已砍, 改自建 Tron 收款 + cents 尾数. 客户端流程不变,
// 但 UsdtInvoicePage 要警告用户金额必须精确 (含小数位).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../api/api_models.dart';
import '../providers/auth_provider.dart';
import '../providers/credit_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/credit_balance_card.dart';
import '../widgets/agent_entry_card.dart';
import '../widgets/trial_card.dart';
import 'usdt_invoice_page.dart';

class VerstroPlanPickerPage extends ConsumerStatefulWidget {
  /// 点 "选择" 创建订单成功后, 由父 widget 决定跳哪里 (默认 Navigator.push UsdtInvoicePage)
  final void Function(OrderDto order)? onOrderCreated;

  const VerstroPlanPickerPage({super.key, this.onOrderCreated});

  @override
  ConsumerState<VerstroPlanPickerPage> createState() => _VerstroPlanPickerPageState();
}

class _VerstroPlanPickerPageState extends ConsumerState<VerstroPlanPickerPage> {
  String? _busyPlanId; // 哪张卡片在创建订单 (按钮 loading 用)
  String? _error;
  String? _couponError; // 券专属错误, 内联展示在优惠码输入框下方 (invalid_coupon)
  String _couponCode = '';
  final GlobalKey _couponFieldKey = GlobalKey(); // 出错时把券输入框滚到可见

  Future<void> _pickPlan(PlanDto plan) async {
    if (_busyPlanId != null) return;
    setState(() {
      _busyPlanId = plan.id;
      _error = null;
      _couponError = null;
    });
    try {
      // 15s 总超时, 防止 dio 在 macOS release 上偶发 silent hang
      final order = await createOrder(ref, plan.id, couponCode: _couponCode)
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      ref.invalidate(creditProvider); // credit 被 hold, 刷新余额
      if (widget.onOrderCreated != null) {
        widget.onOrderCreated!(order);
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => VerstroUsdtInvoicePage(order: order)),
        );
      }
    } on BackendException catch (e) {
      if (!mounted) return;
      if (e.code == 'invalid_coupon') {
        // 券错误内联在输入框下方 + 滚到可见 (页面底部 _error 会被套餐卡片遮住)
        setState(() => _couponError = e.message);
        final ctx = _couponFieldKey.currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(ctx,
              duration: const Duration(milliseconds: 300), alignment: 0.1);
        }
      } else {
        setState(() => _error = e.message);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '创建订单失败: $e');
    } finally {
      if (mounted) setState(() => _busyPlanId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(plansProvider);
    final authAsync = ref.watch(authNotifierProvider);
    final email = authAsync.value?.user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('选择套餐'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '登出',
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorRetry(
          message: '加载套餐失败: $e',
          onRetry: () => ref.invalidate(plansProvider),
        ),
        data: (plans) => _buildPlans(context, plans, email),
      ),
    );
  }

  Widget _buildPlans(BuildContext context, List<PlanDto> plans, String email) {
    // 标准/专业分组展示 (plan 1-2): 旧后端无专业档则不分组, 直接铺.
    final standard = plans.where((p) => !p.isPremium).toList();
    final premium = plans.where((p) => p.isPremium).toList();
    final List<Widget> planSections = premium.isEmpty
        ? [_planGrid(plans)]
        : [
            _tierHeader(context, '标准套餐', '自动选最快节点 · 够用够快'),
            _planGrid(standard),
            const SizedBox(height: 20),
            _tierHeader(context, '专业套餐', '可手动选国家 / 节点 · 含低延迟加速节点 · 更多设备'),
            _planGrid(premium),
          ];
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (email.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '账号: $email',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          const TrialCard(),
          const CreditBalanceCard(),
          const AgentEntryCard(),
          Padding(
            key: _couponFieldKey,
            padding: const EdgeInsets.only(bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                labelText: '优惠码（可选）',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.local_offer_outlined),
                errorText: _couponError,
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (v) {
                _couponCode = v.trim();
                if (_couponError != null) setState(() => _couponError = null);
              },
            ),
          ),
          ...planSections,
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          Text(
            '支付方式: USDT-TRC20\n收款由 Verstro 自建链上接收, 不经过第三方托管',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    );
  }

  // 一组套餐的自适应布局: 宽屏 (>700) 水平铺; 窄屏垂直叠.
  Widget _planGrid(List<PlanDto> plans) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 700;
        if (wide) {
          // IntrinsicHeight 必须包 Row(stretch), 否则 Row 拿到 unbounded vertical 报错.
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: plans
                  .asMap()
                  .entries
                  .expand((e) => [
                        Expanded(child: _PlanCard(plan: e.value, onPick: _pickPlan, busy: _busyPlanId)),
                        if (e.key < plans.length - 1) const SizedBox(width: 12),
                      ])
                  .toList(),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: plans
              .asMap()
              .entries
              .expand((e) => [
                    _PlanCard(plan: e.value, onPick: _pickPlan, busy: _busyPlanId),
                    if (e.key < plans.length - 1) const SizedBox(height: 12),
                  ])
              .toList(),
        );
      },
    );
  }

  Widget _tierHeader(BuildContext context, String title, String subtitle) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PlanDto plan;
  final Future<void> Function(PlanDto) onPick;
  final String? busy;

  const _PlanCard({required this.plan, required this.onPick, required this.busy});

  bool get _isBusy => busy == plan.id;
  bool get _disabled => busy != null && busy != plan.id;

  String _formatBytes(int bytes) {
    final gb = bytes / (1024 * 1024 * 1024);
    if (gb >= 1000) return '${(gb / 1024).toStringAsFixed(1)} TB';
    return '${gb.toStringAsFixed(0)} GB';
  }

  /// 跟 monthly 比的等价"每月价" — 让 quarterly / yearly 显划算
  String? _perMonthHint() {
    final price = double.tryParse(plan.priceUsd);
    if (price == null) return null;
    final months = plan.durationDays / 30.0;
    if (months <= 1.5) return null; // monthly 自己不需要 hint
    final per = price / months;
    return '约 \$${per.toStringAsFixed(2)} / 月';
  }

  /// yearly 标 "最划算"; quarterly 标 "推荐"
  String? _badge() {
    if (plan.durationDays >= 300) return '最划算';
    if (plan.durationDays >= 60) return '推荐';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isPopular = plan.durationDays >= 60;
    final badge = _badge();
    final perMonth = _perMonthHint();

    // Material 标准 clickable card pattern: Card + InkWell.
    // 整张卡片都是 click target, ripple 在 Card 圆角内.
    // (尝试过 GestureDetector+opaque, 但破坏 layout 导致 size MISSING hit test 全 reject.)
    return Card(
      elevation: isPopular ? 4 : 1,
      color: isPopular ? scheme.primaryContainer.withValues(alpha: 0.35) : null,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPopular
            ? BorderSide(color: scheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        key: Key('plan_pick_${plan.id}'),
        onTap: _disabled || _isBusy ? null : () => onPick(plan),
        child: Padding(
          padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$${plan.priceUsd}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 6),
                Text(
                  'USD',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            if (perMonth != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  perMonth,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            _Feature(icon: Icons.calendar_today, text: '${plan.durationDays} 天有效'),
            const SizedBox(height: 6),
            _Feature(icon: Icons.data_usage, text: '${_formatBytes(plan.trafficLimitBytes)} 流量'),
            const SizedBox(height: 6),
            _Feature(
              icon: Icons.devices,
              text: plan.maxDevices > 0 ? '${plan.maxDevices} 台设备同时在线' : '多设备同时使用',
            ),
            const SizedBox(height: 6),
            _Feature(
              icon: plan.isPremium ? Icons.tune : Icons.bolt,
              text: plan.isPremium ? '可手动选国家 / 节点 · 含加速节点' : '自动选最快节点',
            ),
            const SizedBox(height: 6),
            const _Feature(icon: Icons.support_agent, text: 'Telegram 社群支持'),
            const SizedBox(height: 20),
            // Button 仅作 visual indicator. 外层 Card.InkWell 处理整张 click.
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: _disabled
                    ? scheme.primary.withValues(alpha: 0.5)
                    : scheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: _isBusy
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
                        ),
                      )
                    : Text(
                        '选择此套餐',
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Feature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}
