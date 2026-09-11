import 'package:fl_clash/common/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_exceptions.dart';
import '../../api/api_models.dart';
import '../../api/membership_card_models.dart';
import '../../providers/backend_api_provider.dart';
import '../../providers/membership_card_provider.dart';
import '../../providers/orders_provider.dart';
import 'membership_card_order_page.dart';

class MembershipCardsPage extends ConsumerStatefulWidget {
  const MembershipCardsPage({super.key});

  @override
  ConsumerState<MembershipCardsPage> createState() =>
      _MembershipCardsPageState();
}

class _MembershipCardsPageState extends ConsumerState<MembershipCardsPage> {
  @override
  void dispose() {
    // autoDispose 之前再主动清一次，确保路由退出后完整码不留在内存。
    ref.read(membershipCardControllerProvider.notifier).clearSecrets();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.vCardTitle),
          bottom: TabBar(
            isScrollable: true,
            tabs: <Tab>[
              Tab(text: appLocalizations.vCardMarketTab),
              Tab(text: appLocalizations.vCardInventoryTab),
              Tab(text: appLocalizations.vCardRedeemTab),
              Tab(text: appLocalizations.vCardTimelineTab),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            _MembershipCardMarketTab(),
            _MembershipCardInventoryTab(),
            _MembershipCardRedeemTab(),
            _MembershipCardTimelineTab(),
          ],
        ),
      ),
    );
  }
}

class _MembershipCardMarketTab extends ConsumerStatefulWidget {
  const _MembershipCardMarketTab();

  @override
  ConsumerState<_MembershipCardMarketTab> createState() =>
      _MembershipCardMarketTabState();
}

class _MembershipCardMarketTabState
    extends ConsumerState<_MembershipCardMarketTab> {
  final Map<String, int> _quantities = <String, int>{};
  bool _useCashBackedCredit = false;

  List<MembershipCardCartItem> _items() => _quantities.entries
      .where((entry) => entry.value > 0)
      .map(
        (entry) =>
            MembershipCardCartItem(planId: entry.key, quantity: entry.value),
      )
      .toList(growable: false);

  Future<void> _quote() async {
    final items = _items();
    if (items.isEmpty) {
      _snack(appLocalizations.vCardNeedQuantity);
      return;
    }
    await ref
        .read(membershipCardControllerProvider.notifier)
        .quote(items, useCashBackedCredit: _useCashBackedCredit);
  }

  Future<void> _create(MembershipCardQuote quote) async {
    if (quote.purchaseWarningKeys.isNotEmpty) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(appLocalizations.vCardWholesaleConfirmTitle),
          content: Text(appLocalizations.vCardWarningWholesaleSelf),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(appLocalizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(appLocalizations.vCardCreateOrder),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    final order = await ref
        .read(membershipCardControllerProvider.notifier)
        .createOrder(_items(), useCashBackedCredit: _useCashBackedCredit);
    if (!mounted || order == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MembershipCardOrderPage(order: order),
      ),
    );
    ref.invalidate(membershipCardOrdersProvider);
    ref.invalidate(membershipCardInventoryProvider);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(plansProvider);
    final state = ref.watch(membershipCardControllerProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(plansProvider);
        await ref.read(plansProvider.future);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            appLocalizations.vCardMarketDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          plans.when(
            data: (plans) => Column(
              children: plans
                  .map(
                    (plan) => _PlanQuantityCard(
                      plan: plan,
                      quantity: _quantities[plan.id] ?? 0,
                      onChanged: (value) => setState(
                        () => _quantities[plan.id] = value.clamp(0, 1000),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _ErrorText(error: error),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _useCashBackedCredit,
            title: Text(appLocalizations.vCardUseCashBacked),
            onChanged: state.busy
                ? null
                : (value) => setState(() => _useCashBackedCredit = value),
          ),
          FilledButton.icon(
            onPressed: state.busy ? null : _quote,
            icon: const Icon(Icons.request_quote_outlined),
            label: Text(
              state.busy
                  ? appLocalizations.vCardQuoting
                  : appLocalizations.vCardGetQuote,
            ),
          ),
          if (state.error != null) ...<Widget>[
            const SizedBox(height: 12),
            _ErrorText(error: state.error!),
          ],
          if (state.quote != null) ...<Widget>[
            const SizedBox(height: 16),
            _QuoteCard(
              quote: state.quote!,
              busy: state.busy,
              onCreate: () => _create(state.quote!),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _PlanQuantityCard extends StatelessWidget {
  const _PlanQuantityCard({
    required this.plan,
    required this.quantity,
    required this.onChanged,
  });

  final PlanDto plan;
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(plan.name),
        subtitle: Text(
          appLocalizations.vCardPlanMeta(
            plan.durationDays,
            _formatBytes(plan.trafficLimitBytes),
          ),
        ),
        trailing: SizedBox(
          width: 116,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                tooltip: appLocalizations.vCardDecrease,
                onPressed: quantity > 0 ? () => onChanged(quantity - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Semantics(
                label: appLocalizations.vCardQuantity,
                child: Text('$quantity'),
              ),
              IconButton(
                tooltip: appLocalizations.vCardIncrease,
                onPressed: () => onChanged(quantity + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.quote,
    required this.busy,
    required this.onCreate,
  });

  final MembershipCardQuote quote;
  final bool busy;
  final VoidCallback onCreate;

  String _pricingCopy() => switch (quote.pricingCopyKey) {
    'vCardPriceMaster' => appLocalizations.vCardPriceMaster(quote.costBps),
    'vCardPriceReseller' => appLocalizations.vCardPriceReseller(quote.costBps),
    'vCardPricePromoter' => appLocalizations.vCardPricePromoter(quote.costBps),
    'vCardPriceBulkRetail' => appLocalizations.vCardPriceBulkRetail(
      quote.cardCount,
    ),
    _ => appLocalizations.vCardPriceRetail(quote.cardCount),
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              appLocalizations.vCardServerQuote,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(_pricingCopy()),
            const Divider(height: 24),
            ...quote.items.map(
              (item) => _MoneyRow(
                label: '${item.planName} × ${item.quantity}',
                cents: item.lineTotalCents,
              ),
            ),
            const Divider(),
            _MoneyRow(
              label: appLocalizations.vCardListTotal,
              cents: quote.listTotalCents,
            ),
            _MoneyRow(
              label: appLocalizations.vCardGoodsTotal,
              cents: quote.goodsTotalCents,
            ),
            if (quote.cashBackedCreditAppliedCents > 0)
              _MoneyRow(
                label: appLocalizations.vCardCashBackedApplied,
                cents: -quote.cashBackedCreditAppliedCents,
              ),
            _MoneyRow(
              label: appLocalizations.vCardCashDue,
              cents: quote.cashDueCents,
              emphasized: true,
            ),
            if (quote.purchaseWarningKeys.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                appLocalizations.vCardWarningWholesaleSelf,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: busy ? null : onCreate,
              child: Text(appLocalizations.vCardCreateOrder),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.cents,
    this.emphasized = false,
  });

  final String label;
  final int cents;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized ? Theme.of(context).textTheme.titleMedium : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: style)),
          Text(_money(cents), style: style),
        ],
      ),
    );
  }
}

class _MembershipCardInventoryTab extends ConsumerWidget {
  const _MembershipCardInventoryTab();

  Future<String?> _verifyReveal(BuildContext context, WidgetRef ref) async {
    final api = await ref.read(backendApiProvider.future);
    await api.issueMembershipCardRevealChallenge('reveal');
    if (!context.mounted) return null;
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(appLocalizations.vCardRevealVerifyTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            labelText: appLocalizations.vCardEmailCode,
            helperText: appLocalizations.vCardRevealVerifyHint,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(appLocalizations.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(appLocalizations.vCardVerify),
          ),
        ],
      ),
    );
    controller.dispose();
    if (code == null || code.isEmpty) return null;
    final grant = await api.verifyMembershipCardRevealChallenge(
      purpose: 'reveal',
      code: code,
    );
    return grant.token;
  }

  Future<void> _reveal(
    BuildContext context,
    WidgetRef ref,
    MembershipCardInventoryItem item,
  ) async {
    if (item.revealRequiresRefundWarning) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(appLocalizations.vCardRevealTitle),
          content: Text(appLocalizations.vCardRevealIrreversible),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(appLocalizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(appLocalizations.vCardRevealContinue),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
    }
    try {
      final grant = await _verifyReveal(context, ref);
      if (grant == null || !context.mounted) return;
      await ref
          .read(membershipCardControllerProvider.notifier)
          .revealCard(cardId: item.id, grantToken: grant);
    } catch (error) {
      if (context.mounted) _showError(context, error);
    }
  }

  Future<void> _shareExplicit(
    BuildContext context,
    WidgetRef ref,
    String cardId,
  ) async {
    // vCardShareExplicit：只有用户点击此按钮才将完整码写入剪贴板。
    final code = ref
        .read(membershipCardControllerProvider.notifier)
        .revealedCode(cardId);
    if (code == null || code.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: code));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.vCardShareExplicitDone)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(membershipCardInventoryProvider);
    ref.watch(
      membershipCardControllerProvider.select((state) => state.secretRevision),
    );
    final controller = ref.read(membershipCardControllerProvider.notifier);
    return RefreshIndicator(
      onRefresh: () async {
        controller.clearSecrets();
        ref.invalidate(membershipCardInventoryProvider);
        await ref.read(membershipCardInventoryProvider.future);
      },
      child: inventory.when(
        data: (items) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(appLocalizations.vCardInventoryDescription),
            const SizedBox(height: 12),
            if (items.isEmpty)
              _EmptyCard(message: appLocalizations.vCardInventoryEmpty)
            else
              ...items.map((item) {
                final secret = controller.revealedCode(item.id);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.planName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Chip(label: Text(_statusLabel(item.state))),
                          ],
                        ),
                        SelectableText(secret ?? item.maskedCode),
                        if (item.isAvailable) ...<Widget>[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              if (secret == null)
                                OutlinedButton.icon(
                                  onPressed: () => _reveal(context, ref, item),
                                  icon: const Icon(Icons.visibility_outlined),
                                  label: Text(
                                    appLocalizations.vCardRevealAction,
                                  ),
                                ),
                              if (secret != null)
                                FilledButton.tonalIcon(
                                  onPressed: () =>
                                      _shareExplicit(context, ref, item.id),
                                  icon: const Icon(Icons.ios_share_outlined),
                                  label: Text(
                                    appLocalizations.vCardShareExplicit,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: <Widget>[_ErrorText(error: error)],
        ),
      ),
    );
  }
}

class _MembershipCardRedeemTab extends ConsumerStatefulWidget {
  const _MembershipCardRedeemTab();

  @override
  ConsumerState<_MembershipCardRedeemTab> createState() =>
      _MembershipCardRedeemTabState();
}

class _MembershipCardRedeemTabState
    extends ConsumerState<_MembershipCardRedeemTab> {
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.clear();
    _code.dispose();
    super.dispose();
  }

  Future<void> _preview() async {
    final code = _code.text.trim().toUpperCase();
    if (code.isEmpty) return;
    _code.clear();
    await ref
        .read(membershipCardControllerProvider.notifier)
        .previewRedemption(code);
  }

  Future<void> _confirm() async {
    final result = await ref
        .read(membershipCardControllerProvider.notifier)
        .confirmRedemption();
    if (!mounted || result == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(appLocalizations.vCardRedeemSuccess)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(membershipCardControllerProvider);
    final preview = state.redemptionPreview;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(appLocalizations.vCardRedeemDescription),
        const SizedBox(height: 16),
        TextField(
          controller: _code,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: appLocalizations.vCardActivationCode,
            hintText: 'VC1-XXXX-XXXX-XXXX',
            border: const OutlineInputBorder(),
          ),
          onSubmitted: state.busy ? null : (_) => _preview(),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: state.busy ? null : _preview,
          child: Text(appLocalizations.vCardPreviewRedeem),
        ),
        if (state.error != null) ...<Widget>[
          const SizedBox(height: 12),
          _ErrorText(error: state.error!),
        ],
        if (preview != null) ...<Widget>[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    preview.entitlement.planName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    preview.activationMode == 'scheduled'
                        ? appLocalizations.vCardRedeemScheduled(
                            _formatDate(context, preview.scheduledFor),
                          )
                        : appLocalizations.vCardRedeemImmediate,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: state.busy ? null : _confirm,
                    child: Text(appLocalizations.vCardConfirmRedeem),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MembershipCardTimelineTab extends ConsumerWidget {
  const _MembershipCardTimelineTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(membershipEntitlementTimelineProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(membershipEntitlementTimelineProvider);
        await ref.read(membershipEntitlementTimelineProvider.future);
      },
      child: timeline.when(
        data: (timeline) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _TimelineSection(
              title: appLocalizations.vCardTimelineCurrent,
              items: timeline.current,
            ),
            const SizedBox(height: 16),
            _TimelineSection(
              title: appLocalizations.vCardTimelinePending,
              items: timeline.pending,
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: <Widget>[_ErrorText(error: error)],
        ),
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.title, required this.items});

  final String title;
  final List<MembershipEntitlementTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (items.isEmpty)
          _EmptyCard(message: appLocalizations.vCardTimelineEmpty)
        else
          ...items.map(
            (item) => Card(
              child: ListTile(
                leading: Icon(
                  item.status == 'active'
                      ? Icons.play_circle_outline
                      : item.status == 'paused'
                      ? Icons.pause_circle_outline
                      : Icons.schedule_outlined,
                ),
                title: Text(item.planName),
                subtitle: Text(
                  appLocalizations.vCardTimelinePeriod(
                    _formatDate(context, item.startsAt),
                    _formatDate(context, item.activeUntil),
                  ),
                ),
                trailing: Chip(label: Text(_statusLabel(item.status))),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(16), child: Text(message)),
  );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) => Text(
    error is BackendException
        ? (error as BackendException).message
        : appLocalizations.vCardGenericError,
    style: TextStyle(color: Theme.of(context).colorScheme.error),
  );
}

void _showError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error is BackendException
            ? error.message
            : appLocalizations.vCardGenericError,
      ),
    ),
  );
}

String _money(int cents) {
  final sign = cents < 0 ? '−' : '';
  return '$sign\$${(cents.abs() / 100).toStringAsFixed(2)}';
}

String _formatBytes(int value) {
  if (value <= 0) return '0 B';
  const units = <String>['B', 'KB', 'MB', 'GB', 'TB'];
  var number = value.toDouble();
  var unit = 0;
  while (number >= 1024 && unit < units.length - 1) {
    number /= 1024;
    unit++;
  }
  return '${number.toStringAsFixed(number >= 10 ? 0 : 1)} ${units[unit]}';
}

String _formatDate(BuildContext context, DateTime? value) => value == null
    ? '—'
    : MaterialLocalizations.of(context).formatMediumDate(value.toLocal());

String _statusLabel(String status) => switch (status) {
  'available' => appLocalizations.vCardStatusAvailable,
  'redeemed' => appLocalizations.vCardStatusRedeemed,
  'revoked' => appLocalizations.vCardStatusRevoked,
  'active' => appLocalizations.vCardStatusActive,
  'scheduled' => appLocalizations.vCardStatusScheduled,
  'paused' => appLocalizations.vCardStatusPaused,
  'activation_pending' => appLocalizations.vCardStatusActivationPending,
  'waiting' => appLocalizations.vCardStatusWaiting,
  'paid' => appLocalizations.vCardStatusPaid,
  'expired' => appLocalizations.vCardStatusExpired,
  'not_started' => appLocalizations.vCardStatusNotStarted,
  'processing' => appLocalizations.vCardStatusProcessing,
  'succeeded' => appLocalizations.vCardStatusSucceeded,
  _ => status,
};
