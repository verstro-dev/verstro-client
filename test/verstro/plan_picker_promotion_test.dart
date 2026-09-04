import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_exceptions.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/pages/plan_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async => AppLocalizations.load(const Locale('en')));

  testWidgets('权威报价卡显示原价、优惠和优惠后金额', (tester) async {
    final quote = PromotionQuoteDto(
      campaignId: 1,
      revisionId: 2,
      application: 'automatic',
      basePriceCents: 600,
      discountCents: 60,
      priceAfterDiscountCents: 540,
      quoteToken: 'signed-token',
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: PromotionQuoteBreakdownCard(quote: quote)),
      ),
    );
    expect(find.text(r'$6.00'), findsOneWidget);
    expect(find.text(r'−$0.60'), findsOneWidget);
    expect(find.text(r'$5.40'), findsOneWidget);
  });

  test('空优惠码的报价网络错误归入页面错误而不是优惠码字段', () {
    final presentation = classifyPromotionQuoteError(
      const NetworkException('Request cancelled'),
      couponCode: '',
    );

    expect(presentation.couponError, isNull);
    expect(presentation.pageError, 'Request cancelled');
  });

  test('真实无效优惠码错误归入优惠码字段', () {
    final presentation = classifyPromotionQuoteError(
      const BadRequestException('invalid_coupon', 'Invalid coupon'),
      couponCode: 'BAD-CODE',
    );

    expect(presentation.couponError, 'Invalid coupon');
    expect(presentation.pageError, isNull);
  });
}
