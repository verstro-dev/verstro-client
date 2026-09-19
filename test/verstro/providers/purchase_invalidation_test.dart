import 'package:flutter/material.dart';
import 'package:fl_clash/verstro/api/account_entitlement_models.dart';
import 'package:fl_clash/verstro/providers/account_entitlements_provider.dart';
import 'package:fl_clash/verstro/providers/devices_provider.dart';
import 'package:dio/dio.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/membership_card_models.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:fl_clash/verstro/providers/credit_provider.dart';
import 'package:fl_clash/verstro/providers/membership_card_provider.dart';
import 'package:fl_clash/verstro/providers/orders_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardAPI extends BackendApi {
  CardAPI(TokenStorage token)
    : super(token: token, baseUrl: 'https://example.test', dio: Dio());
  bool orderOffline = true;
  @override
  Future<OrderDto> getOrder(int orderId) async {
    if (orderOffline) throw StateError('offline');
    return OrderDto.fromJson({
      'id': orderId,
      'plan_id': 'monthly',
      'base_price': '6.00',
      'final_amount': '6.07',
      'status': 'expired',
      'pay_currency': 'usdttrc20',
      'created_at': '2026-09-05T00:00:00Z',
      'expires_at': '2026-09-06T00:00:00Z',
    });
  }

  @override
  Future<MembershipCardQuote> quoteMembershipCards(
    List<MembershipCardCartItem> items, {
    required bool useCashBackedCredit,
  }) async => MembershipCardQuote.fromJson({
    'card_class': 'retail_gift',
    'quote_hash': 'synthetic',
    'items': [],
  });
  @override
  Future<MembershipCardOrderResult> createMembershipCardOrder(
    List<MembershipCardCartItem> items, {
    required bool useCashBackedCredit,
    required String expectedQuoteHash,
    required String idempotencyKey,
  }) async => MembershipCardOrderResult.fromJson({
    'order': {
      'id': 1,
      'card_class': 'retail_gift',
      'created_at': '2026-09-05T00:00:00Z',
      'expires_at': '2026-09-06T00:00:00Z',
      'items': [],
    },
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final action in ['redemption', 'ordinary']) {
    testWidgets('$action 后权益、订阅、订单、资金、设备全部失效刷新', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final api = _RedemptionAPI(
        TokenStorage(await SharedPreferences.getInstance()),
      );
      final calls = <String, int>{};
      void count(String key) => calls[key] = (calls[key] ?? 0) + 1;
      final container = ProviderContainer(
        overrides: [
          backendApiProvider.overrideWith((ref) async => api),
          accountEntitlementsProvider.overrideWith(
            () => _CountingEntitlements(() => count('entitlements')),
          ),
          subscriptionProvider.overrideWith((ref) async {
            count('subscription');
            return SubscriptionDto.fromJson({'has_subscription': false});
          }),
          ordersListProvider.overrideWith((ref) async {
            count('orders');
            return [];
          }),
          creditProvider.overrideWith((ref) async {
            count('credit');
            return const CreditDto(balanceCents: 0, credits: []);
          }),
          devicesListProvider.overrideWith((ref) async {
            count('devices');
            return const DevicesInfo(devices: [], maxDevices: 0);
          }),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                ref.watch(accountEntitlementsProvider);
                ref.watch(subscriptionProvider);
                ref.watch(ordersListProvider);
                ref.watch(creditProvider);
                ref.watch(devicesListProvider);
                ref.watch(membershipCardControllerProvider);
                return TextButton(
                  onPressed: () async {
                    if (action == 'ordinary') {
                      await createOrder(
                        ref,
                        'monthly',
                        expectedPlanVersionId: 1,
                        expectedBasePriceCents: 600,
                      );
                    } else {
                      final controller = ref.read(
                        membershipCardControllerProvider.notifier,
                      );
                      await controller.previewRedemption('synthetic');
                      await controller.confirmRedemption();
                    }
                  },
                  child: const Text('perform'),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(calls.values, everyElement(1));
      await tester.tap(find.text('perform'));
      await tester.pumpAndSettle();
      expect(calls, {
        'entitlements': 2,
        'subscription': 2,
        'orders': 2,
        'credit': 2,
        'devices': 2,
      });
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  testWidgets('真实订单轮询上报错误并在下一轮恢复终态', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final api = CardAPI(TokenStorage(await SharedPreferences.getInstance()));
    final container = ProviderContainer(
      overrides: [backendApiProvider.overrideWith((ref) async => api)],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      orderDetailStreamProvider(93),
      (_, _) {},
    );
    addTearDown(subscription.close);
    await tester.pump();
    expect(container.read(orderDetailStreamProvider(93)).hasError, isTrue);
    api.orderOffline = false;
    await tester.pump(const Duration(seconds: 5));
    await tester.pump();
    expect(
      container.read(orderDetailStreamProvider(93)).requireValue.isExpired,
      isTrue,
    );
  });
  test('会员卡购买成功刷新资金、普通订单列表和打开的普通订单状态', () async {
    SharedPreferences.setMockInitialValues({});
    final api = CardAPI(TokenStorage(await SharedPreferences.getInstance()));
    var funds = 0, orders = 0, details = 0;
    final container = ProviderContainer(
      overrides: [
        backendApiProvider.overrideWith((ref) async => api),
        creditProvider.overrideWith((ref) async {
          funds++;
          return const CreditDto(balanceCents: 0, credits: []);
        }),
        ordersListProvider.overrideWith((ref) async {
          orders++;
          return [];
        }),
        orderDetailStreamProvider.overrideWith((ref, id) async* {
          details++;
          yield* const Stream<OrderDto>.empty();
        }),
      ],
    );
    addTearDown(container.dispose);
    final subscriptions = [
      container.listen(creditProvider, (_, _) {}),
      container.listen(ordersListProvider, (_, _) {}),
      container.listen(orderDetailStreamProvider(93), (_, _) {}),
      container.listen(membershipCardControllerProvider, (_, _) {}),
    ];
    addTearDown(() {
      for (final s in subscriptions) {
        s.close();
      }
    });
    await container.read(creditProvider.future);
    await container.read(ordersListProvider.future);
    await Future<void>.delayed(Duration.zero);
    final controller = container.read(
      membershipCardControllerProvider.notifier,
    );
    await controller.quote([], useCashBackedCredit: true);
    expect(
      await controller.createOrder([], useCashBackedCredit: true),
      isNotNull,
    );
    await Future<void>.delayed(Duration.zero);
    expect(funds, 2);
    expect(orders, 2);
    expect(details, 2);
  });
}

class _CountingEntitlements extends AccountEntitlementsNotifier {
  _CountingEntitlements(this.onRead);
  final void Function() onRead;
  @override
  Future<AccountEntitlements?> build() async {
    onRead();
    return null;
  }
}

class _RedemptionAPI extends CardAPI {
  _RedemptionAPI(super.token);
  @override
  Future<MembershipCardRedemptionPreview> previewMembershipCardRedemption(
    String code,
  ) async => MembershipCardRedemptionPreview.fromJson({
    'preview_token': 'synthetic',
    'masked_code': '***',
    'entitlement': {},
    'activation_mode': 'scheduled',
    'expires_at': '2099-01-01T00:00:00Z',
  });
  @override
  Future<MembershipCardRedemptionResult> confirmMembershipCardRedemption(
    String previewToken, {
    required String idempotencyKey,
  }) async => MembershipCardRedemptionResult.fromJson({
    'id': 'synthetic',
    'card_id': 'synthetic',
    'state': 'scheduled',
    'activation_mode': 'scheduled',
    'attribution_result': 'none',
    'entitlement': {},
    'accepted_at': '2026-09-09T00:00:00Z',
  });
  @override
  Future<OrderDto> createOrder(
    String planId, {
    String purchaseMode = 'automatic',
    String? couponCode,
    String? promotionQuoteToken,
    required int expectedPlanVersionId,
    required int expectedBasePriceCents,
  }) async => OrderDto.fromJson({
    'id': 1,
    'plan_id': planId,
    'base_price': '6.00',
    'final_amount': '0.00',
    'status': 'finished',
    'pay_currency': 'usdttrc20',
    'created_at': '2026-09-09T00:00:00Z',
    'expires_at': '2026-09-10T00:00:00Z',
  });
}
