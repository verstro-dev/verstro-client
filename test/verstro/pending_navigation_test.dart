import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dio/dio.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';
import 'package:fl_clash/verstro/pages/usdt_invoice_page.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:fl_clash/verstro/providers/credit_provider.dart';
import 'package:fl_clash/verstro/providers/orders_provider.dart';
import 'package:fl_clash/verstro/widgets/credit_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'support/test_auth.dart';

OrderDto order(String status) => OrderDto.fromJson({
  'id': 93,
  'plan_id': 'monthly',
  'base_price': '5.00',
  'final_amount': '5.01',
  'status': status,
  'deposit_address': 'TExample',
  'created_at': DateTime.now().toUtc().toIso8601String(),
  'expires_at': DateTime.now()
      .add(const Duration(hours: 1))
      .toUtc()
      .toIso8601String(),
  'received_cents': status == 'finished' ? 501 : 100,
  'remaining_cents': status == 'finished' ? 0 : 401,
});
CreditDto funds() => CreditDto.fromJson({
  'balance_cents': 10,
  'credits': [],
  'pending_order_cents': 100,
  'pending_orders': [
    {
      'order_id': 93,
      'received_cents': 100,
      'remaining_cents': 401,
      'expires_at': order('partially_paid').expiresAt.toIso8601String(),
    },
  ],
});

class PendingApi extends BackendApi {
  PendingApi(TokenStorage token)
    : super(baseUrl: 'https://example.test', token: token, dio: Dio());
  int creditReads = 0;
  final fetchedIds = <int>[];
  bool failOrder = false;
  String status = 'partially_paid';
  CreditDto current = funds();
  @override
  Future<CreditDto> getCredit() async {
    creditReads++;
    return current;
  }

  @override
  Future<OrderDto> getOrder(int id) async {
    fetchedIds.add(id);
    if (failOrder) throw StateError('offline');
    return order(status);
  }
}

void main() {
  late PendingApi api;
  late ProviderContainer container;
  late StreamController<OrderDto> stream;
  setUpAll(() async => AppLocalizations.load(const Locale('zh', 'CN')));
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    api = PendingApi(TokenStorage(await SharedPreferences.getInstance()));
    stream = StreamController<OrderDto>.broadcast();
    container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(TestAuth.new),
        backendApiProvider.overrideWith((ref) async => api),
        orderDetailStreamProvider.overrideWith((ref, id) => stream.stream),
        ordersListProvider.overrideWith((ref) async => []),
        subscriptionProvider.overrideWith(
          (ref) async => SubscriptionDto.fromJson({'has_subscription': false}),
        ),
      ],
      retry: (_, _) => null,
    );
    await container.read(authNotifierProvider.future);
  });
  tearDown(() async {
    container.dispose();
    await stream.close();
  });
  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: CreditBalanceCard(alwaysShow: true)),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('按ID进入历史分页以外订单，返回账户同步最新余额', (tester) async {
    await pump(tester);
    expect(find.text('可用余额  \$0.10'), findsOneWidget);
    expect(find.textContaining('1.10'), findsNothing);
    await tester.tap(find.text('继续补付'));
    await tester.pumpAndSettle();
    expect(api.fetchedIds, [93]);
    expect(find.byType(VerstroUsdtInvoicePage), findsOneWidget);
    api.current = const CreditDto(balanceCents: 10, credits: []);
    final reads = api.creditReads;
    Navigator.of(tester.element(find.byType(VerstroUsdtInvoicePage))).pop();
    await tester.pumpAndSettle();
    expect(api.creditReads, greaterThan(reads));
    expect(find.text('待补款订单已收金额'), findsNothing);
    expect(find.text('可用余额  \$0.10'), findsOneWidget);
  });
  for (final status in ['finished', 'expired']) {
    testWidgets('轮询partial->$status刷新credit', (tester) async {
      await pump(tester);
      await tester.tap(find.text('继续补付'));
      await tester.pumpAndSettle();
      stream.add(order('partially_paid'));
      await tester.pump();
      await tester.pump();
      final reads = api.creditReads;
      api.current = const CreditDto(balanceCents: 10, credits: []);
      stream.add(order(status));
      await tester.pump();
      await tester.pump();
      // 被新路由遮挡的账户订阅在 Riverpod 3 中暂停；读取验证已失效而不是要求后台请求。
      final refreshed = await container.read(creditProvider.future);
      expect(refreshed.pendingOrders, isEmpty);
      expect(api.creditReads, greaterThan(reads));
    });
  }
  testWidgets('读取订单失败可重试而非进入伪造付款页', (tester) async {
    api.failOrder = true;
    await pump(tester);
    await tester.tap(find.text('继续补付'));
    await tester.pumpAndSettle();
    expect(find.byType(VerstroUsdtInvoicePage), findsNothing);
    expect(find.text('余额加载失败，请重试'), findsOneWidget);
    api.failOrder = false;
    await tester.tap(find.text('继续补付'));
    await tester.pumpAndSettle();
    expect(find.byType(VerstroUsdtInvoicePage), findsOneWidget);
  });
  testWidgets('读取发现订单已过期，不允许继续付款', (tester) async {
    api.status = 'expired';
    await pump(tester);
    final reads = api.creditReads;
    await tester.tap(find.text('继续补付'));
    await tester.pumpAndSettle();
    expect(find.byType(VerstroUsdtInvoicePage), findsNothing);
    expect(api.creditReads, greaterThan(reads));
  });
  testWidgets('本地倒计时到期立即隐藏付款入口，仍可申报且继续接收服务器终态', (tester) async {
    final initial = order('partially_paid');
    var now = initial.expiresAt.subtract(const Duration(seconds: 1));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: VerstroUsdtInvoicePage(order: initial, now: () => now),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(QrImageView), findsOneWidget);
    now = initial.expiresAt;
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(QrImageView), findsNothing);
    expect(find.text('付款时限已到'), findsWidgets);
    expect(find.textContaining('4.01'), findsNothing);
    expect(find.text('我已付款（提交交易号）'), findsOneWidget);
    // 本地到期没有篡改订单状态，也没有停止订阅服务端轮询。
    expect(initial.status, 'partially_paid');
    stream.add(order('finished'));
    await tester.pump();
    await tester.pump();
    expect(find.text('付款时限已到'), findsNothing);
    expect(find.byType(QrImageView), findsNothing);
  });
  testWidgets('不是从待补款卡进入时，订单页返回也刷新账户余额', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  const CreditBalanceCard(alwaysShow: true),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => VerstroUsdtInvoicePage(
                          order: order('partially_paid'),
                        ),
                      ),
                    ),
                    child: const Text('历史入口'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('历史入口'));
    await tester.pumpAndSettle();
    api.current = const CreditDto(balanceCents: 10, credits: []);
    final reads = api.creditReads;
    Navigator.of(tester.element(find.byType(VerstroUsdtInvoicePage))).pop();
    await tester.pumpAndSettle();
    expect(api.creditReads, greaterThan(reads));
    expect(find.text('待补款订单已收金额'), findsNothing);
  });
}
