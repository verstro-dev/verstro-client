import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/pages/my_promotions_page.dart';
import 'package:fl_clash/verstro/providers/promotions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async => AppLocalizations.load(const Locale('en')));

  testWidgets('我的优惠按服务端状态显示可用和已使用记录', (tester) async {
    final data = MyPromotionsDto(
      automatic: const [
        PromotionEligibilityDto(
          campaignId: 1,
          revisionId: 1,
          scenario: 'new_customer',
          availability: 'available',
          eligiblePlanIds: ['monthly'],
          titleI18n: {'en': 'Welcome offer'},
          descriptionI18n: {},
          termsI18n: {},
        ),
      ],
      grants: const [],
      redemptions: [
        PromotionRedemptionDto(
          campaignId: 2,
          revisionId: 3,
          application: 'code',
          discountCents: 100,
          status: 'settled',
          heldAt: DateTime.utc(2026, 8, 17),
          settledAt: DateTime.utc(2026, 8, 17),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myPromotionsProvider.overrideWith(
            (ref) async => MyPromotionsState(supported: true, data: data),
          ),
        ],
        child: const MaterialApp(home: VerstroMyPromotionsPage()),
      ),
    );
    await tester.pump();
    expect(find.text('Welcome offer'), findsOneWidget);
    expect(find.textContaining(r'$1.00'), findsOneWidget);
  });
}
