import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/app_localizations.dart';
import '../api/account_entitlement_models.dart';
import '../providers/account_entitlements_provider.dart';
import '../providers/account_refresh.dart';
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
                    const Divider(),
                    Text(appLocalizations.vEntEstimate),
                    _section(
                      context,
                      appLocalizations.vEntCurrent,
                      snapshot.current,
                    ),
                    _section(
                      context,
                      appLocalizations.vEntPending,
                      snapshot.pending,
                      ordered: true,
                    ),
                    _section(
                      context,
                      appLocalizations.vEntHistory,
                      snapshot.history,
                    ),
                    if (snapshot.historyError)
                      Text(
                        snapshot.historyChanged
                            ? appLocalizations.vEntHistoryChanged
                            : appLocalizations.vEntHistoryError,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    if (snapshot.nextHistoryCursor != null &&
                        !snapshot.historyChanged)
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
                        onPressed: () =>
                            ref.invalidate(accountEntitlementsProvider),
                        child: Text(appLocalizations.vEntRefresh),
                      ),
                    if (snapshot.conversionCapability.quoteSupported)
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
                        child: Text(appLocalizations.vEntUpgrade),
                      ),
                  ],
                );
              },
            ),
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const VerstroPlanPickerPage(independent: true),
                  ),
                );
                if (context.mounted) invalidateAccount(ref.invalidate);
              },
              child: Text(appLocalizations.vEntIndependent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    List<AccountEntitlement> entries, {
    bool ordered = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 16),
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      if (entries.isEmpty) Text(appLocalizations.vEntEmpty),
      for (var i = 0; i < entries.length; i++)
        _entry(context, entries[i], ordered ? i + 1 : null),
    ],
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
