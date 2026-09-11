import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/common/app_localizations.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/pages/usdt_invoice_page.dart';
import 'package:fl_clash/verstro/providers/orders_provider.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import '../support/test_auth.dart';

void main() {
  testWidgets(
    'known conversion rejects first fetch and poll identity downgrade and account switch',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await AppLocalizations.load(const Locale('zh', 'CN'));
      const cid = '00000000-0000-0000-0000-000000000011';
      final raw = <String, dynamic>{
        'id': 77,
        'purpose': 'conversion_funding',
        'conversion_id': cid,
        'plan_id': 'monthly',
        'base_price': '6.00',
        'final_amount': '6.07',
        'status': 'waiting',
        'remaining_cents': 607,
        'deposit_address': 'TTest',
        'created_at': DateTime.now().toIso8601String(),
        'expires_at': DateTime.now()
            .add(const Duration(hours: 1))
            .toIso8601String(),
      };
      final known = OrderDto.fromJson(raw);
      final stream = StreamController<OrderDto>.broadcast();
      addTearDown(stream.close);
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(TestAuth.new),
          orderDetailStreamProvider.overrideWith((ref, id) => stream.stream),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: VerstroUsdtInvoicePage(order: known, conversionPayment: true),
          ),
        ),
      );
      await tester.pump();
      final bad = Map<String, dynamic>.from(raw)
        ..remove('purpose')
        ..remove('conversion_id')
        ..['status'] = 'finished';
      stream.add(OrderDto.fromJson(bad));
      await tester.pumpAndSettle();
      expect(find.text(appLocalizations.vConvUnknown), findsOneWidget);
      expect(find.byType(QrImageView), findsNothing);
      stream.add(known);
      await tester.pumpAndSettle();
      expect(find.byType(QrImageView), findsOneWidget);
      for (final change in [
        {'id': 78},
        {'conversion_id': '00000000-0000-0000-0000-000000000022'},
        {'purpose': 'ordinary', 'conversion_id': null},
      ]) {
        stream.add(OrderDto.fromJson({...raw, ...change}));
        await tester.pumpAndSettle();
        expect(find.text(appLocalizations.vConvUnknown), findsOneWidget);
      }
      (container.read(authNotifierProvider.notifier) as TestAuth).switchUser(2);
      stream.add(known);
      await tester.pumpAndSettle();
      expect(find.byType(QrImageView), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
