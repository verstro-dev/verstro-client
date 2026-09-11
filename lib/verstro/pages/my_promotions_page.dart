import 'package:fl_clash/common/common.dart' show appLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/promotions_provider.dart';

class VerstroMyPromotionsPage extends ConsumerWidget {
  const VerstroMyPromotionsPage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(myPromotionsProvider);
    await ref.read(myPromotionsProvider.future);
  }

  String _title(BuildContext context, Map<String, String> values) {
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

  String _date(BuildContext context, DateTime? value) {
    if (value == null) return '';
    final local = value.toLocal();
    return MaterialLocalizations.of(context).formatCompactDate(local);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPromotionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vPromotionMyEntryTitle)),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              appLocalizations.vPromotionQuoteFailed('$error'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (state) {
          if (!state.supported) {
            return Center(child: Text(appLocalizations.vPromotionUnsupported));
          }
          final data = state.data;
          final automatic = data?.automatic ?? const [];
          final grants = data?.grants ?? const [];
          final redemptions = data?.redemptions ?? const [];
          return RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                if (automatic.isEmpty && grants.isEmpty && redemptions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Text(
                      appLocalizations.vPromotionEmpty,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ...automatic.map(
                  (item) => _PromotionTile(
                    icon: Icons.auto_awesome,
                    title: _title(context, item.titleI18n),
                    status: item.availability == 'available'
                        ? appLocalizations.vPromotionAvailable
                        : appLocalizations.vPromotionUnavailable,
                    available: item.availability == 'available',
                    subtitle: _date(context, item.endsAt),
                  ),
                ),
                ...grants.map(
                  (item) => _PromotionTile(
                    icon: Icons.card_giftcard,
                    title: _title(context, item.titleI18n),
                    status: item.redeemable
                        ? appLocalizations.vPromotionAvailable
                        : appLocalizations.vPromotionUnavailable,
                    available: item.redeemable,
                    subtitle: _date(context, item.expiresAt),
                  ),
                ),
                ...redemptions.map(
                  (item) => _PromotionTile(
                    icon: Icons.receipt_long,
                    title: appLocalizations.vPromotionDiscountRecord(
                      '\$${(item.discountCents / 100).toStringAsFixed(2)}',
                    ),
                    status: switch (item.status) {
                      'settled' => appLocalizations.vPromotionUsed,
                      'released' => appLocalizations.vPromotionReleased,
                      _ => appLocalizations.vPromotionHeld,
                    },
                    available: false,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PromotionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final bool available;
  final String subtitle;

  const _PromotionTile({
    required this.icon,
    required this.title,
    required this.status,
    required this.available,
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: available
                ? scheme.primaryContainer
                : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(status),
        ),
      ),
    );
  }
}
