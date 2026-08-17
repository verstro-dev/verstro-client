// PlanPickerPage — Verstro 选套餐
//
// 3 档套餐卡片. 用户点 "选择" → 创建订单 → 跳 UsdtInvoicePage.
//
// 注意阶段 2.0 决策 (docs/decisions.md § why-self-hosted-tron-collection-alpha):
// NOWPayments min $19.20 已砍, 改自建 Tron 收款 + cents 尾数. 客户端流程不变,
// 但 UsdtInvoicePage 要警告用户金额必须精确 (含小数位).

import 'dart:async';

import 'package:fl_clash/common/common.dart' show appLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../api/api_models.dart';
import '../providers/auth_provider.dart';
import '../providers/credit_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/promotions_provider.dart';
import '../util/plan_display.dart';
import '../widgets/credit_balance_card.dart';
import '../widgets/agent_entry_card.dart';
import '../widgets/trial_card.dart';
import 'usdt_invoice_page.dart';
import 'my_promotions_page.dart';

class VerstroPlanPickerPage extends ConsumerStatefulWidget {
  /// 点 "选择" 创建订单成功后, 由父 widget 决定跳哪里 (默认 Navigator.push UsdtInvoicePage)
  final void Function(OrderDto order)? onOrderCreated;

  const VerstroPlanPickerPage({super.key, this.onOrderCreated});

  @override
  ConsumerState<VerstroPlanPickerPage> createState() =>
      _VerstroPlanPickerPageState();
}

class _VerstroPlanPickerPageState extends ConsumerState<VerstroPlanPickerPage> {
  String? _busyPlanId; // 哪张卡片在创建订单 (按钮 loading 用)
  String? _error;
  String? _couponError; // 券专属错误, 内联展示在优惠码输入框下方 (invalid_coupon)
  String _couponCode = '';
  PlanDto? _selectedPlan;
  PromotionQuoteDto? _quote;
  PromotionQuoteRequest? _quoteRequest;
  bool _promotionSupported = true;
  bool _quoting = false;
  Timer? _quoteDebounce;
  int _quoteGeneration = 0;
  final GlobalKey _couponFieldKey = GlobalKey(); // 出错时把券输入框滚到可见

  @override
  void dispose() {
    _quoteDebounce?.cancel();
    super.dispose();
  }

  PromotionQuoteRequest _requestFor(PlanDto plan) => PromotionQuoteRequest(
    planId: plan.id,
    planVersionId: plan.planVersionId,
    basePriceCents: plan.expectedBasePriceCents,
    couponCode: _couponCode,
  );

  Future<PromotionQuoteDto?> _loadQuote(PlanDto plan) async {
    final request = _requestFor(plan);
    final generation = ++_quoteGeneration;
    setState(() {
      _selectedPlan = plan;
      _quoting = true;
      _couponError = null;
      _quote = null;
      _quoteRequest = null;
    });
    try {
      final state = await ref.read(promotionQuoteProvider(request).future);
      if (!mounted || generation != _quoteGeneration) return null;
      setState(() {
        _promotionSupported = state.supported;
        _quote = state.quote;
        _quoteRequest = state.quote == null ? null : request;
      });
      return state.quote;
    } on BackendException catch (e) {
      if (!mounted || generation != _quoteGeneration) return null;
      setState(() => _couponError = e.message);
      rethrow;
    } finally {
      if (mounted && generation == _quoteGeneration) {
        setState(() => _quoting = false);
      }
    }
  }

  Future<OrderDto> _createOrderWithPromotion(
    PlanDto plan,
    PromotionQuoteDto? quote, {
    int retryCount = 0,
  }) async {
    try {
      return await createOrder(
        ref,
        plan.id,
        couponCode: _couponCode,
        promotionQuoteToken: _promotionSupported ? quote?.quoteToken : null,
        expectedPlanVersionId: plan.planVersionId,
        expectedBasePriceCents: plan.expectedBasePriceCents,
      ).timeout(const Duration(seconds: 15));
    } on BackendException catch (e) {
      if (_promotionSupported &&
          retryCount == 0 &&
          (e.code == 'promotion_quote_expired' ||
              e.code == 'promotion_quote_changed')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(appLocalizations.vPromotionQuoteExpired)),
          );
        }
        final fresh = await _loadQuote(plan);
        return _createOrderWithPromotion(plan, fresh, retryCount: 1);
      }
      rethrow;
    }
  }

  Future<void> _pickPlan(PlanDto plan) async {
    if (_busyPlanId != null) return;
    if (!plan.purchaseAvailable) {
      setState(() => _error = appLocalizations.vPlanPartnerSalesPaused);
      return;
    }
    if (plan.planVersionId <= 0) {
      ref.invalidate(plansProvider);
      setState(() => _error = appLocalizations.vPlanPriceChanged);
      return;
    }
    setState(() {
      _busyPlanId = plan.id;
      _error = null;
      _couponError = null;
    });
    try {
      final request = _requestFor(plan);
      final reusable =
          _quote != null && !_quote!.isExpired && _quoteRequest == request;
      var quote = !_promotionSupported
          ? null
          : (reusable ? _quote : await _loadQuote(plan));
      if (_promotionSupported && quote == null) {
        quote = await _loadQuote(plan);
      }
      if (_promotionSupported && quote == null) {
        throw StateError(appLocalizations.vPromotionQuoteFailed('stale'));
      }
      final order = await _createOrderWithPromotion(plan, quote);
      if (!mounted) return;
      ref.invalidate(creditProvider); // credit 被 hold, 刷新余额
      if (widget.onOrderCreated != null) {
        widget.onOrderCreated!(order);
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VerstroUsdtInvoicePage(order: order),
          ),
        );
      }
    } on BackendException catch (e) {
      if (!mounted) return;
      if (e.code == 'invalid_coupon') {
        // 券错误内联在输入框下方 + 滚到可见 (页面底部 _error 会被套餐卡片遮住)
        setState(() => _couponError = e.message);
        final ctx = _couponFieldKey.currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 300),
            alignment: 0.1,
          );
        }
      } else if (e.code == 'price_changed' ||
          e.code == 'plan_version_changed' ||
          e.code == 'plan_confirmation_required' ||
          e.code == 'plan_version_unavailable') {
        ref.invalidate(plansProvider);
        setState(() => _error = appLocalizations.vPlanPriceChanged);
      } else {
        setState(() => _error = e.message);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = appLocalizations.vPlanCreateOrderFailed('$e'));
    } finally {
      if (mounted) setState(() => _busyPlanId = null);
    }
  }

  Future<void> _applyCoupon(List<PlanDto> plans) async {
    PlanDto? plan = _selectedPlan;
    if (plan == null) {
      for (final item in plans) {
        if (item.purchaseAvailable) {
          plan = item;
          break;
        }
      }
    }
    if (plan == null) return;
    try {
      await _loadQuote(plan);
    } on BackendException {
      // _loadQuote 已把稳定业务错误写入输入框下方。
    }
  }

  String _localizedPromotionTitle(Map<String, String> values) {
    final locale = Localizations.localeOf(context);
    final tag = locale.countryCode == null
        ? locale.languageCode
        : '${locale.languageCode}-${locale.countryCode}';
    return values[tag] ??
        values[locale.languageCode] ??
        values['en'] ??
        values['zh-CN'] ??
        appLocalizations.vPromotionTitle;
  }

  void _couponChanged(String value) {
    _quoteGeneration++;
    _couponCode = value.trim();
    _quoteDebounce?.cancel();
    setState(() {
      _quote = null;
      _quoteRequest = null;
      _couponError = null;
    });
    final plan = _selectedPlan;
    if (plan != null && _promotionSupported) {
      _quoteDebounce = Timer(
        const Duration(milliseconds: 300),
        () => _loadQuote(plan).catchError((_) => null),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(plansProvider);
    final authAsync = ref.watch(authNotifierProvider);
    final email = authAsync.value?.user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.vPlanPickTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: appLocalizations.vPlanLogout,
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorRetry(
          message: appLocalizations.vPlanLoadFailed('$e'),
          onRetry: () => ref.invalidate(plansProvider),
        ),
        data: (plans) => _buildPlans(context, plans, email),
      ),
    );
  }

  Widget _buildPlans(BuildContext context, List<PlanDto> plans, String email) {
    final promotionCatalog = ref.watch(activePromotionsProvider).value;
    final myPromotionState = ref.watch(myPromotionsProvider).value;
    final activePromotions = promotionCatalog?.promotions ?? const [];
    final promotionPlanIds = activePromotions
        .expand((promotion) => promotion.planIds)
        .toSet();
    // 标准/专业分组展示 (plan 1-2): 旧后端无专业档则不分组, 直接铺.
    final standard = plans.where((p) => !p.isPremium).toList();
    final premium = plans.where((p) => p.isPremium).toList();
    final List<Widget> planSections = premium.isEmpty
        ? [_planGrid(plans, promotionPlanIds)]
        : [
            _tierHeader(
              context,
              appLocalizations.vPlanTierStandard,
              appLocalizations.vPlanTierStandardDesc,
            ),
            _planGrid(standard, promotionPlanIds),
            const SizedBox(height: 20),
            _tierHeader(
              context,
              appLocalizations.vPlanTierPremium,
              appLocalizations.vPlanTierPremiumDesc,
            ),
            _planGrid(premium, promotionPlanIds),
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
                  appLocalizations.vPlanAccountEmail(email),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const TrialCard(),
            const CreditBalanceCard(),
            const AgentEntryCard(),
            if (activePromotions.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.vPromotionPublicTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(appLocalizations.vPromotionAutomaticBest),
                      const SizedBox(height: 8),
                      ...activePromotions.map(
                        (promotion) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '• ${_localizedPromotionTitle(promotion.titleI18n)}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (myPromotionState?.supported != false)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.local_offer_outlined),
                  title: Text(appLocalizations.vPromotionMyEntryTitle),
                  subtitle: Text(appLocalizations.vPromotionMyEntrySubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const VerstroMyPromotionsPage(),
                    ),
                  ),
                ),
              ),
            Padding(
              key: _couponFieldKey,
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('promotion_code_field'),
                      decoration: InputDecoration(
                        labelText: appLocalizations.vPromotionCodeHint,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.local_offer_outlined),
                        errorText: _couponError,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      autocorrect: false,
                      enableSuggestions: false,
                      enabled: _busyPlanId == null,
                      onChanged: _couponChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    key: const Key('promotion_apply_button'),
                    onPressed: _quoting ? null : () => _applyCoupon(plans),
                    child: _quoting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(appLocalizations.vPromotionApply),
                  ),
                ],
              ),
            ),
            if (!_promotionSupported)
              Text(
                appLocalizations.vPromotionUnsupported,
                textAlign: TextAlign.center,
              )
            else if (_quote != null) ...[
              PromotionQuoteBreakdownCard(quote: _quote!),
              const SizedBox(height: 16),
            ],
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
              appLocalizations.vPlanPaymentMethodNote,
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
  Widget _planGrid(List<PlanDto> plans, Set<String> promotionPlanIds) {
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
                  .expand(
                    (e) => [
                      Expanded(
                        child: _PlanCard(
                          plan: e.value,
                          onPick: _pickPlan,
                          busy: _busyPlanId,
                          promotionAvailable: promotionPlanIds.contains(
                            e.value.id,
                          ),
                        ),
                      ),
                      if (e.key < plans.length - 1) const SizedBox(width: 12),
                    ],
                  )
                  .toList(),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: plans
              .asMap()
              .entries
              .expand(
                (e) => [
                  _PlanCard(
                    plan: e.value,
                    onPick: _pickPlan,
                    busy: _busyPlanId,
                    promotionAvailable: promotionPlanIds.contains(e.value.id),
                  ),
                  if (e.key < plans.length - 1) const SizedBox(height: 12),
                ],
              )
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
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class PromotionQuoteBreakdownCard extends StatelessWidget {
  final PromotionQuoteDto quote;

  const PromotionQuoteBreakdownCard({super.key, required this.quote});

  String _usd(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: appLocalizations.vPromotionTitle,
      child: Card(
        key: const Key('promotion_quote_breakdown'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _PromotionAmountRow(
                label: appLocalizations.vPromotionQuoteBase,
                value: _usd(quote.basePriceCents),
              ),
              _PromotionAmountRow(
                label: appLocalizations.vPromotionQuoteDiscount,
                value: '−${_usd(quote.discountCents)}',
              ),
              const Divider(),
              _PromotionAmountRow(
                label: appLocalizations.vPromotionQuoteAfter,
                value: _usd(quote.priceAfterDiscountCents),
                emphasized: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromotionAmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;

  const _PromotionAmountRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: emphasized ? FontWeight.bold : null,
          ),
        ),
      ],
    ),
  );
}

class _PlanCard extends StatelessWidget {
  final PlanDto plan;
  final Future<void> Function(PlanDto) onPick;
  final String? busy;
  final bool promotionAvailable;

  const _PlanCard({
    required this.plan,
    required this.onPick,
    required this.busy,
    this.promotionAvailable = false,
  });

  bool get _isBusy => busy == plan.id;
  bool get _disabled =>
      !plan.purchaseAvailable || (busy != null && busy != plan.id);

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
    return appLocalizations.vPlanPerMonthHint(per.toStringAsFixed(2));
  }

  /// yearly 标 "最划算"; quarterly 标 "推荐"
  String? _badge() {
    if (plan.durationDays >= 300) return appLocalizations.vPlanBadgeBestValue;
    if (plan.durationDays >= 60) return appLocalizations.vPlanBadgeRecommended;
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
                      localizedPlanName(plan.id, plan.name),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
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
              if (plan.partnerPrice) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      appLocalizations.vPlanPartnerPriceLabel,
                      style: TextStyle(
                        color: scheme.onSecondaryContainer,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (promotionAvailable) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: const Icon(Icons.local_offer_outlined, size: 16),
                    label: Text(appLocalizations.vPromotionBadge),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (!plan.purchaseAvailable) ...[
                Text(
                  appLocalizations.vPlanPartnerSalesPaused,
                  style: TextStyle(
                    color: scheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
              ],
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
                  if (plan.partnerPrice && plan.listPriceUsd.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      '\$${plan.listPriceUsd}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
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
              _Feature(
                icon: Icons.calendar_today,
                text: appLocalizations.vPlanDurationDays(plan.durationDays),
              ),
              const SizedBox(height: 6),
              _Feature(
                icon: Icons.data_usage,
                text: appLocalizations.vPlanTraffic(
                  _formatBytes(plan.trafficLimitBytes),
                ),
              ),
              const SizedBox(height: 6),
              _Feature(
                icon: Icons.devices,
                text: plan.maxDevices > 0
                    ? appLocalizations.vPlanMaxDevices(plan.maxDevices)
                    : appLocalizations.vPlanMultiDevices,
              ),
              const SizedBox(height: 6),
              _Feature(
                icon: plan.isPremium ? Icons.tune : Icons.bolt,
                text: plan.isPremium
                    ? appLocalizations.vPlanFeaturePremiumNodes
                    : appLocalizations.vPlanFeatureAutoNode,
              ),
              const SizedBox(height: 6),
              _Feature(
                icon: Icons.support_agent,
                text: appLocalizations.vPlanTelegramSupport,
              ),
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
                            valueColor: AlwaysStoppedAnimation(
                              scheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          plan.purchaseAvailable
                              ? appLocalizations.vPlanPickThis
                              : appLocalizations.vPlanUnavailable,
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
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(appLocalizations.vPlanRetry),
            ),
          ],
        ),
      ),
    );
  }
}
