import 'dart:async';
import 'dart:convert';
import 'entitlement_conversion_lifecycle_test.dart' as lifecycle;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/api/api_exceptions.dart';
import 'package:fl_clash/verstro/api/account_entitlement_models.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';
import 'package:fl_clash/verstro/pages/plan_picker_page.dart';
import 'package:fl_clash/verstro/pages/entitlement_conversion_page.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:fl_clash/verstro/providers/orders_provider.dart';
import 'package:fl_clash/verstro/providers/promotions_provider.dart';
import 'package:fl_clash/verstro/providers/credit_provider.dart';
import 'package:fl_clash/verstro/providers/trial_provider.dart';
import 'package:fl_clash/verstro/providers/agent_provider.dart';
import 'support/test_auth.dart';
import 'account_entitlements_test.dart' as fixtures;

PlanDto plan({String? tier = 'premium', int days = 30}) => PlanDto.fromJson({
  'id': 'arbitrary-sku',
  'name': 'Routing target',
  'plan_version_id': 9,
  'duration_days': days,
  'price_usd': '6.00',
  'traffic_limit_bytes': 1024,
  'squad_tier': ?tier,
});

class RoutingAPI extends fixtures.EntitlementsAPI {
  RoutingAPI(super.token);
  int orders = 0, resources = 0;
  bool orderSucceeds = false, expireFirst = false;
  BackendException? orderFailure;
  final modes = <String>[];
  @override
  Future<EntitlementConversion> getEntitlementConversion(String id) async {
    resources++;
    return EntitlementConversion.fromJson(lifecycle.conversionResource());
  }

  String? seenCoupon;
  bool? seenCredit;
  @override
  Future<EntitlementConversionQuote> quoteEntitlementConversion({
    required String targetTier,
    String? couponCode,
    bool useCredit = true,
    int recoverFromOrderId = 0,
  }) async {
    seenCoupon = couponCode;
    seenCredit = useCredit;
    return super.quoteEntitlementConversion(
      targetTier: targetTier,
      couponCode: couponCode,
      useCredit: useCredit,
    );
  }

  @override
  Future<OrderDto> createOrder(
    String id, {
    String purchaseMode = 'automatic',
    String? couponCode,
    String? promotionQuoteToken,
    required int expectedPlanVersionId,
    required int expectedBasePriceCents,
  }) async {
    orders++;
    modes.add(purchaseMode);
    if (expireFirst && orders == 1) {
      throw const ConflictException('promotion_quote_expired', 'expired');
    }
    if (orderFailure != null) throw orderFailure!;
    if (orderSucceeds) {
      return OrderDto(
        id: 7,
        planId: id,
        basePrice: '6.00',
        finalAmount: '6.01',
        status: 'waiting',
        depositAddress: 'test-address',
        payCurrency: 'usdttrc20',
        txid: null,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
        paidAt: null,
      );
    }
    throw StateError('测试停止于普通订单提交');
  }
}

Future<ProviderContainer> mount(
  WidgetTester tester,
  RoutingAPI api, {
  PlanDto? target,
  Widget? home,
  bool marketing = false,
}) async {
  tester.view.resetPhysicalSize();
  tester.view.physicalSize = const Size(1200, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final container = ProviderContainer(
    overrides: [
      authNotifierProvider.overrideWith(TestAuth.new),
      backendApiProvider.overrideWith((ref) async => api),
      plansProvider.overrideWith((ref) async => [target ?? plan()]),
      activePromotionsProvider.overrideWith(
        (ref) async =>
            const PromotionCatalogState(supported: false, promotions: []),
      ),
      myPromotionsProvider.overrideWith(
        (ref) async => const MyPromotionsState(supported: false),
      ),
      promotionQuoteProvider.overrideWith(
        (ref, arg) async => marketing
            ? PromotionQuoteState(
                supported: true,
                quote: PromotionQuoteDto(
                  campaignId: 1,
                  revisionId: 1,
                  application: 'automatic',
                  basePriceCents: 600,
                  discountCents: 0,
                  priceAfterDiscountCents: 600,
                  quoteToken: 'signed-test',
                  expiresAt: DateTime.now().add(const Duration(minutes: 5)),
                ),
              )
            : const PromotionQuoteState(supported: false),
      ),
      creditProvider.overrideWith(
        (ref) async => const CreditDto(balanceCents: 0, credits: []),
      ),
      trialStatusProvider.overrideWith(
        (ref) async => const TrialStatusDto(
          enabled: false,
          claimed: false,
          days: 0,
          trafficGb: 0,
        ),
      ),
      agentProvider.overrideWith((ref) => Completer<AgentDto>().future),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: home ?? const VerstroPlanPickerPage()),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

Future<void> pick(WidgetTester tester) async {
  await tester.tap(find.text('Routing target').first);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppLocalizations.load(const Locale('en'));
  });
  testWidgets('真实套餐点击先最新权益读取，标准到专业只打开升级预览不下普通单', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()));
    await mount(tester, api);
    await pick(tester);
    expect(api.cursors, [null]);
    expect(api.orders, 0);
    expect(find.byType(EntitlementConversionPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  for (final service in ['legacy_unverified', 'review_required']) {
    testWidgets('$service 不应落入普通下单', (tester) async {
      final api = RoutingAPI(
        TokenStorage(await SharedPreferences.getInstance()),
      );
      api.fetch = (_) async => AccountEntitlements.fromJson({
        ...fixtures.snapshot(),
        'current_service': {'status': service},
        'current': [],
        'pending': [],
      });
      await mount(tester, api);
      await pick(tester);
      expect(api.cursors, [null]);
      expect(api.orders, 0);
      expect(find.byType(EntitlementConversionPage), findsNothing);
    });
  }
  testWidgets('新购买意图只自动报价且携带优惠与余额，不自动创建', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()));
    await mount(
      tester,
      api,
      home: const EntitlementConversionPage(
        initialTargetTier: 'premium',
        initialCouponCode: 'ROUTE',
        initialUseCredit: false,
        intentOwnerId: 1,
      ),
    );
    expect(api.quoteCalls, 1);
    expect(api.seenCoupon, 'ROUTE');
    expect(api.seenCredit, false);
    expect(api.orders, 0);
    await tester.pumpWidget(const SizedBox());
  });
  test('PlanDto 仅读取服务端squad_tier，不从ID猜测', () {
    expect(plan().squadTier, 'premium');
    expect(plan(tier: null).squadTier, '');
    expect(plan(tier: 'unknown').squadTier, 'unknown');
  });
  for (final scenario in [
    'same-month',
    'same-year',
    'lower',
    'premium-paused-standard',
    'none',
    'trial',
    'exhausted',
  ]) {
    testWidgets('$scenario 保持普通购买且每次最新读取', (tester) async {
      final api = RoutingAPI(
        TokenStorage(await SharedPreferences.getInstance()),
      );
      final standard = fixtures.grant(1, 'active');
      final premium = {...fixtures.grant(2, 'active'), 'squad_tier': 'premium'};
      final raw = {
        ...fixtures.snapshot(),
        'current_service': {'status': 'none'},
        'current': <Map<String, dynamic>>[],
        'pending': <Map<String, dynamic>>[],
      };
      if (scenario.startsWith('same')) {
        raw['pending'] = [
          {...standard, 'status': 'scheduled'},
        ];
      }
      if (scenario == 'lower') raw['current'] = [premium];
      if (scenario == 'premium-paused-standard') {
        raw['current'] = [premium];
        raw['pending'] = [
          {...standard, 'status': 'paused'},
        ];
      }
      if (scenario == 'trial') {
        raw['current'] = [
          {...standard, 'source_kind': 'trial', 'squad_tier': 'trial'},
        ];
      }
      if (scenario == 'exhausted') {
        raw['current'] = [
          {...standard, 'remaining_bytes': 0},
        ];
      }
      api.fetch = (_) async => AccountEntitlements.fromJson(raw);
      await mount(
        tester,
        api,
        target: plan(
          days: scenario == 'same-year' ? 365 : 30,
          tier: scenario.startsWith('same') || scenario == 'lower'
              ? 'standard'
              : 'premium',
        ),
      );
      await pick(tester);
      expect(api.cursors, [null, null]);
      expect(api.orders, 1);
      expect(find.byType(EntitlementConversionPage), findsNothing);
      await pick(tester);
      expect(api.cursors, [null, null, null, null]);
      expect(api.orders, 2);
    });
  }
  for (final tier in [null, 'future-tier']) {
    testWidgets('未知目标档$tier不能静默普通购买但可显式独立', (tester) async {
      final api = RoutingAPI(
        TokenStorage(await SharedPreferences.getInstance()),
      );
      await mount(tester, api, target: plan(tier: tier));
      await pick(tester);
      expect(api.orders, 0);
      expect(find.byType(EntitlementConversionPage), findsNothing);
      await tester.tap(find.byKey(const ValueKey('purchase-independent')));
      await tester.pumpAndSettle();
      await pick(tester);
      expect(api.orders, 1);
      expect(api.cursors, [null]);
    });
  }
  for (final failure in ['404', 'bad-snapshot', 'unknown-grant']) {
    testWidgets('$failure不全价fallback', (tester) async {
      final api = RoutingAPI(
        TokenStorage(await SharedPreferences.getInstance()),
      );
      api.fetch = (_) async {
        if (failure == '404') {
          throw const NotFoundException('Entitlements unavailable');
        }
        if (failure == 'bad-snapshot') return AccountEntitlements.fromJson({});
        return AccountEntitlements.fromJson({
          ...fixtures.snapshot(),
          'current': [
            {...fixtures.grant(1, 'active'), 'squad_tier': 'unknown'},
          ],
        });
      };
      await mount(tester, api);
      await pick(tester);
      expect(api.orders, 0);
      expect(find.byType(EntitlementConversionPage), findsNothing);
    });
  }
  testWidgets('等待权益期间切换账号再切回仍不得继续旧点击', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()));
    final pending = Completer<AccountEntitlements>();
    api.fetch = (_) => pending.future;
    final container = await mount(tester, api);
    await tester.tap(find.text('Routing target').first);
    await tester.pump();
    final auth = container.read(authNotifierProvider.notifier) as TestAuth;
    auth.switchUser(2);
    await tester.pump();
    auth.switchUser(1);
    await tester.pump();
    pending.complete(AccountEntitlements.fromJson(fixtures.snapshot()));
    await tester.pumpAndSettle();
    expect(api.orders, 0);
    expect(find.byType(EntitlementConversionPage), findsNothing);
  });
  testWidgets('账户显式独立模式可见且不自动下单', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()));
    await mount(
      tester,
      api,
      home: const VerstroPlanPickerPage(independent: true),
    );
    expect(
      tester
          .widget<SwitchListTile>(
            find.byKey(const ValueKey('purchase-independent')),
          )
          .value,
      true,
    );
    expect(api.orders, 0);
    await pick(tester);
    expect(api.orders, 1);
    expect(api.cursors, isEmpty);
  });
  for (final named in [false, true]) {
    testWidgets('新意图不覆盖旧${named ? '具名资源' : '未知create'}请求证据', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      final request = {
        'target_tier': 'premium',
        'coupon_code': 'OLD',
        'use_credit': true,
      };
      final saved = jsonEncode(
        named
            ? {
                'id': lifecycle.conversionResource()['id'],
                'request': request,
                'dirty': true,
              }
            : {
                'key': 'original-key',
                'request': request,
                'quote': fixtures.quote(),
              },
      );
      await prefs.setString('verstro_conversion_attempt_v1_1', saved);
      final api = RoutingAPI(TokenStorage(prefs));
      await mount(
        tester,
        api,
        home: const EntitlementConversionPage(
          initialTargetTier: 'premium',
          initialCouponCode: 'NEW',
          initialUseCredit: false,
          intentOwnerId: 1,
        ),
      );
      expect(api.quoteCalls, 0);
      expect(api.resources, named ? 1 : 0);
      expect(api.orders, 0);
      expect(prefs.getString('verstro_conversion_attempt_v1_1'), saved);
      expect(find.widgetWithText(TextField, 'OLD'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('新意图不能传入另一账户', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()));
    await mount(
      tester,
      api,
      home: const EntitlementConversionPage(
        initialTargetTier: 'premium',
        initialCouponCode: 'PRIVATE',
        intentOwnerId: 2,
      ),
    );
    expect(api.quoteCalls, 0);
    expect(find.widgetWithText(TextField, 'PRIVATE'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('同档普通下单成功沿用订单返回与付款导航回调', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()))
      ..orderSucceeds = true;
    OrderDto? received;
    await mount(
      tester,
      api,
      target: plan(tier: 'standard'),
      home: VerstroPlanPickerPage(onOrderCreated: (order) => received = order),
    );
    await pick(tester);
    expect(api.orders, 1);
    expect(received?.id, 7);
    expect(received?.purpose, 'ordinary');
  });
  testWidgets('已应用服务缺少逐笔证据不能猜成首购', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()));
    api.fetch = (_) async => AccountEntitlements.fromJson({
      ...fixtures.snapshot(),
      'current': [],
      'pending': [],
    });
    await mount(tester, api);
    await pick(tester);
    expect(api.orders, 0);
  });
  testWidgets('普通营销处理后路线改变应停单而不是沿用首轮快照', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()));
    var count = 0;
    api.fetch = (_) async => AccountEntitlements.fromJson({
      ...fixtures.snapshot(),
      'current': [
        {
          ...fixtures.grant(1, 'active'),
          'squad_tier': ++count == 1 ? 'premium' : 'standard',
        },
      ],
      'pending': [],
    });
    await mount(tester, api);
    await pick(tester);
    expect(api.orders, 0);
    expect(api.cursors, [null, null]);
  });
  testWidgets('未知来源不能默认普通下单，显式独立购买仍可选', (tester) async {
    final api = RoutingAPI(TokenStorage(await SharedPreferences.getInstance()));
    api.fetch = (_) async => AccountEntitlements.fromJson({
      ...fixtures.snapshot(),
      'current': [
        {...fixtures.grant(1, 'active'), 'source_kind': 'unknownsource'},
      ],
      'pending': [],
    });
    await mount(tester, api, target: plan(tier: 'standard'));
    await pick(tester);
    expect(api.orders, 0);
    expect(find.byType(EntitlementConversionPage), findsNothing);
    await tester.tap(find.byKey(const ValueKey('purchase-independent')));
    await tester.pumpAndSettle();
    await pick(tester);
    expect(api.orders, 1);
  });
  for (final independent in [false, true]) {
    testWidgets('套餐页显式模式$independent营销重试保持原购买意图', (tester) async {
      final api = RoutingAPI(
        TokenStorage(await SharedPreferences.getInstance()),
      )..expireFirst = true;
      await mount(
        tester,
        api,
        target: plan(tier: 'standard'),
        marketing: true,
        home: VerstroPlanPickerPage(independent: independent),
      );
      await pick(tester);
      final mode = independent ? 'independent' : 'automatic';
      expect(api.modes, [mode, mode]);
      expect(api.orders, 2);
    });
  }
  for (final code in [
    'entitlement_upgrade_required',
    'purchase_entitlements_unverified',
    'invalid_json',
  ]) {
    testWidgets('服务器$code显示错误不自动普通重试或换模式', (tester) async {
      final api = RoutingAPI(
        TokenStorage(await SharedPreferences.getInstance()),
      );
      api.orderFailure = code == 'invalid_json'
          ? const BadRequestException(
              'invalid_json',
              'Unsupported purchase_mode',
            )
          : ConflictException(code, 'Opaque English server message');
      await mount(tester, api, target: plan(tier: 'standard'));
      await pick(tester);
      expect(api.modes, ['automatic']);
      expect(api.orders, 1);
      expect(api.quoteCalls, 0);
      expect(find.byType(EntitlementConversionPage), findsNothing);
      if (code != 'invalid_json') {
        expect(
          find.textContaining('Refresh and select the plan again'),
          findsOneWidget,
        );
        expect(find.text('Opaque English server message'), findsNothing);
      }
      expect(
        tester
            .widget<SwitchListTile>(
              find.byKey(const ValueKey('purchase-independent')),
            )
            .value,
        false,
      );
    });
  }
  for (final service in ['expired', 'exhausted']) {
    for (final scheduledPremium in [false, true]) {
      testWidgets('真实服务态$service在pending专业=$scheduledPremium时可正常普通购买', (
        tester,
      ) async {
        final api = RoutingAPI(
          TokenStorage(await SharedPreferences.getInstance()),
        );
        api.fetch = (_) async => AccountEntitlements.fromJson({
          ...fixtures.snapshot(),
          'current_service': {
            'status': service,
            'plan_id': 'monthly',
            'squad_tier': 'standard',
            'remaining_bytes': 0,
            'active_until': service == 'expired'
                ? '2026-09-08T00:00:00Z'
                : '2026-10-09T00:00:00Z',
          },
          'current': [],
          'pending': scheduledPremium
              ? [
                  {...fixtures.grant(2, 'scheduled'), 'squad_tier': 'standard'},
                  {...fixtures.grant(3, 'scheduled'), 'squad_tier': 'premium'},
                ]
              : [],
        });
        await mount(tester, api, target: plan(tier: 'premium'));
        await pick(tester);
        expect(api.orders, 1);
        expect(api.modes, ['automatic']);
        expect(find.byType(EntitlementConversionPage), findsNothing);
      });
    }
  }
}
