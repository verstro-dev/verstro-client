import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/app_localizations.dart';
import '../api/account_entitlement_models.dart';
import '../providers/account_entitlements_provider.dart';
import '../providers/account_refresh.dart';
import '../providers/auth_provider.dart';
import '../providers/backend_api_provider.dart';
import '../util/plan_display.dart';
import '../pages/entitlement_conversion_page.dart';
import '../pages/plan_picker_page.dart';

String entitlementStatusLabel(String status) => switch (status) {
  'legacy_unverified' => appLocalizations.vEntUnverified,
  'review_required' => appLocalizations.vEntReview,
  'active' => appLocalizations.vEntActive,
  'scheduled' || 'queued' => appLocalizations.vEntScheduled,
  'paused' => appLocalizations.vEntPaused,
  'converted' => appLocalizations.vConvConverted,
  'expired' => appLocalizations.vEntExpired,
  'exhausted' => appLocalizations.vEntExhausted,
  'revoked' || 'refunded' => appLocalizations.vEntRevoked,
  'none' || 'no_subscription' => appLocalizations.vEntNone,
  _ => appLocalizations.vEntProcessing,
};
String entitlementBytes(int n) {
  if (n < 1024) return '$n B';
  const units = ['KB', 'MB', 'GB', 'TB'];
  var value = n / 1024;
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(2)} ${units[unit]}';
}

String entitlementDate(DateTime? date) =>
    date?.toLocal().toString().split('.')[0] ?? '—';

class AccountEntitlementsCard extends ConsumerWidget {
  const AccountEntitlementsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(accountEntitlementsProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              appLocalizations.vEntTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            value.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Column(
                children: [
                  Text(appLocalizations.vEntError),
                  TextButton(
                    onPressed: () =>
                        ref.invalidate(accountEntitlementsProvider),
                    child: Text(appLocalizations.vAcctRetry),
                  ),
                ],
              ),
              data: (snapshot) {
                if (snapshot == null) return const SizedBox.shrink();
                final service = snapshot.currentService;
                final activeTier = service.status == 'active'
                    ? service.squadTier
                    : null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      appLocalizations.vEntService,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(entitlementStatusLabel(service.status)),
                    if (service.planId.isNotEmpty)
                      Text(localizedPlanName(service.planId, service.planId)),
                    if (service.status == 'active') ...[
                      Text(
                        '${appLocalizations.vEntRemaining}: ${entitlementBytes(service.remainingBytes)}',
                      ),
                      Text(
                        '${appLocalizations.vEntDevices}: ${service.maxDevices} · ${service.manualNodeSelection ? appLocalizations.vEntManual : appLocalizations.vEntAutomatic}',
                      ),
                      Text(
                        '${appLocalizations.expirationTime}: ${entitlementDate(service.activeUntil)}',
                      ),
                    ],
                    if (snapshot.current.isNotEmpty)
                      ExpansionTile(
                        key: const ValueKey('current-details'),
                        tilePadding: EdgeInsets.zero,
                        title: Text(appLocalizations.vEntDetails),
                        children: [
                          for (final item in snapshot.current)
                            _entry(context, item, null),
                        ],
                      ),
                    if (snapshot.pending.isNotEmpty)
                      ExpansionTile(
                        key: const ValueKey('pending-summary'),
                        tilePadding: EdgeInsets.zero,
                        title: Text(appLocalizations.vEntPending),
                        subtitle: Text(
                          '${snapshot.pending.length} · ${localizedPlanName(snapshot.pending.first.planId, snapshot.pending.first.planName)} · ${entitlementStatusLabel(snapshot.pending.first.status)}',
                        ),
                        children: [
                          Text(appLocalizations.vEntEstimate),
                          for (var i = 0; i < snapshot.pending.length; i++)
                            _entry(context, snapshot.pending[i], i + 1),
                        ],
                      ),
                    if (_hasStandardCandidate(snapshot))
                      OutlinedButton(
                        key: const ValueKey('conversion-preview'),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const EntitlementConversionPage(),
                            ),
                          );
                          if (context.mounted) {
                            invalidateAccount(ref.invalidate);
                          }
                        },
                        child: Text(
                          activeTier == 'premium'
                              ? appLocalizations.vEntConvertStandardToPremium
                              : appLocalizations.vEntUpgradePremium,
                        ),
                      ),
                    FilledButton(
                      key: ValueKey(
                        activeTier == 'premium'
                            ? 'renew-premium'
                            : 'renew-standard',
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const VerstroPlanPickerPage(),
                          ),
                        );
                        if (context.mounted) invalidateAccount(ref.invalidate);
                      },
                      child: Text(
                        activeTier == 'premium'
                            ? appLocalizations.vEntRenewPremium
                            : appLocalizations.vEntRenewStandard,
                      ),
                    ),
                  ],
                );
              },
            ),
            const _ConversionRecoveryEntry(),
            const _IndependentPurchaseEntry(),
          ],
        ),
      ),
    );
  }

  bool _hasStandardCandidate(AccountEntitlements snapshot) =>
      [...snapshot.current, ...snapshot.pending].any(
        (item) =>
            item.squadTier == 'standard' &&
            !const {
              'expired',
              'exhausted',
              'refunded',
              'converted',
              'revoked',
            }.contains(item.status) &&
            // 零值非终态仍然是必须呈现的候选，不在前端猜测价值。
            item.remainingBytes >= 0 &&
            item.remainingServiceSeconds >= 0,
      );

  Widget _entry(
    BuildContext context,
    AccountEntitlement item,
    int? sequence,
  ) => Padding(
    key: ValueKey('entitlement-${item.grantId}'),
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${sequence == null ? '' : '$sequence. '}${localizedPlanName(item.planId, item.planName)} · #${item.grantId}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          item.historyReason == 'refunded'
              ? appLocalizations.vEntRefunded
              : entitlementStatusLabel(item.status),
        ),
        if (item.historyReason == 'refunded')
          Text(appLocalizations.vEntRefundNote),
        Text(
          '${appLocalizations.vEntSource}: ${(item.sourceKind == 'membership_card' || item.sourceKind == 'card')
              ? appLocalizations.vEntCard
              : item.sourceKind == 'order'
              ? appLocalizations.vEntOrder
              : item.sourceKind == 'conversion'
              ? appLocalizations.vConvSource
              : item.sourceKind} ${item.sourceOrderId != null ? '#${item.sourceOrderId}' : item.sourceCardId ?? item.sourceConversionId ?? '—'}${item.sourceConversionPeriodId == null ? '' : ' · #${item.sourceConversionPeriodId}'}',
        ),
        Text(
          '${appLocalizations.vEntUsage}: ${entitlementBytes(item.consumedBytes)} / ${entitlementBytes(item.quotaBytes)}',
        ),
        Text(
          '${appLocalizations.vEntRemaining}: ${entitlementBytes(item.remainingBytes)}',
        ),
        Text(
          '${item.isEstimated ? '${appLocalizations.vEntEstimated} ' : ''}${appLocalizations.vEntPeriod}: ${entitlementDate(item.isEstimated ? item.estimatedStartsAt : item.startsAt)} — ${entitlementDate(item.isEstimated ? item.estimatedEndsAt : item.activeUntil)}',
        ),
        Text(
          '${appLocalizations.vEntServiceTime}: ${item.remainingServiceSeconds ~/ 86400} d ${(item.remainingServiceSeconds % 86400) ~/ 3600} h',
        ),
      ],
    ),
  );
}

class _ConversionRecoveryEntry extends ConsumerWidget {
  const _ConversionRecoveryEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authNotifierProvider).value?.user?.id;
    if (uid == null) return const SizedBox.shrink();
    return FutureBuilder<bool>(
      key: ValueKey('conversion-recovery-future-$uid'),
      future: ref
          .read(sharedPreferencesProvider.future)
          .then(
            (prefs) => prefs.containsKey('verstro_conversion_attempt_v1_$uid'),
          ),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return TextButton.icon(
          key: const ValueKey('conversion-recovery-entry'),
          icon: const Icon(Icons.restore),
          label: Text(appLocalizations.vEntResumeConversion),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const EntitlementConversionPage(),
              ),
            );
            if (context.mounted) invalidateAccount(ref.invalidate);
          },
        );
      },
    );
  }
}

class _IndependentPurchaseEntry extends ConsumerWidget {
  const _IndependentPurchaseEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const VerstroPlanPickerPage(independent: true),
          ),
        );
        if (context.mounted) invalidateAccount(ref.invalidate);
      },
      child: Text(appLocalizations.vEntIndependent),
    );
  }
}

/// 二级页的权益历史：保留服务端分页、冲突和失败重试语义。
class EntitlementHistoryList extends ConsumerWidget {
  const EntitlementHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(accountEntitlementsProvider);
    return value.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => TextButton(
        onPressed: () => ref.invalidate(accountEntitlementsProvider),
        child: Text(appLocalizations.vAcctRetry),
      ),
      data: (snapshot) {
        if (snapshot == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.history.isEmpty) Text(appLocalizations.vEntEmpty),
            for (final item in snapshot.history) _HistoryEntry(item: item),
            if (snapshot.historyError)
              Text(
                snapshot.historyChanged
                    ? appLocalizations.vEntHistoryChanged
                    : appLocalizations.vEntHistoryError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (snapshot.nextHistoryCursor != null && !snapshot.historyChanged)
              TextButton(
                key: const ValueKey('entitlements-more'),
                onPressed: snapshot.loadingMore
                    ? null
                    : () => ref
                          .read(accountEntitlementsProvider.notifier)
                          .loadMore(),
                child: Text(
                  snapshot.historyError
                      ? appLocalizations.vAcctRetry
                      : appLocalizations.vEntMore,
                ),
              ),
            if (snapshot.historyError)
              TextButton(
                onPressed: () => ref.invalidate(accountEntitlementsProvider),
                child: Text(appLocalizations.vEntRefresh),
              ),
          ],
        );
      },
    );
  }
}

class _HistoryEntry extends StatelessWidget {
  const _HistoryEntry({required this.item});
  final AccountEntitlement item;

  @override
  Widget build(BuildContext context) => Padding(
    key: ValueKey('entitlement-${item.grantId}'),
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${localizedPlanName(item.planId, item.planName)} · #${item.grantId}',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.historyReason == 'refunded'
                ? appLocalizations.vEntRefunded
                : entitlementStatusLabel(item.status),
          ),
          if (item.historyReason == 'refunded')
            Text(appLocalizations.vEntRefundNote),
          Text(
            '${appLocalizations.vEntRemaining}: ${entitlementBytes(item.remainingBytes)}',
          ),
          Text(
            '${appLocalizations.vEntSource}: ${(item.sourceKind == 'membership_card' || item.sourceKind == 'card')
                ? appLocalizations.vEntCard
                : item.sourceKind == 'order'
                ? appLocalizations.vEntOrder
                : item.sourceKind == 'conversion'
                ? appLocalizations.vConvSource
                : item.sourceKind} ${item.sourceOrderId != null ? '#${item.sourceOrderId}' : item.sourceCardId ?? item.sourceConversionId ?? '—'}${item.sourceConversionPeriodId == null ? '' : ' · #${item.sourceConversionPeriodId}'}',
          ),
          Text(
            '${appLocalizations.vEntUsage}: ${entitlementBytes(item.consumedBytes)} / ${entitlementBytes(item.quotaBytes)}',
          ),
          Text(
            '${appLocalizations.vEntPeriod}: ${entitlementDate(item.startsAt)} — ${entitlementDate(item.activeUntil)}',
          ),
        ],
      ),
    ),
  );
}
