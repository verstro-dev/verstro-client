// 账号页套餐名本地化 widget 测试 (whole-branch-review 修复批次):
//
// 回归背景: 账号页曾直接渲染 GrantDto.planName (后端下发的中文名, 如「标准·月付」),
// 绕过了 plan_picker 已用的 localizedPlanName() 本地化查表, 导致 en/ja/ru 用户在
// 账号页看到中文套餐名。本测试用英文 locale 装配一个带 2 个 grant 的 fake 订阅
// (grant.planName 故意保留后端中文, 模拟真实后端行为), 断言页面上:
//   1) 不出现任何后端中文套餐名 (标准·月付 / 专业·年付)
//   2) 出现的是 localizedPlanName 查表后的英文名
// 这样能捕获"绕过 localizedPlanName 直接渲染 planName/currentPlanId"这一类回归。

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/pages/account_page.dart';
import 'package:fl_clash/verstro/pages/usdt_invoice_page.dart';
import 'package:fl_clash/verstro/providers/agent_provider.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/verstro/providers/credit_provider.dart';
import 'package:fl_clash/verstro/providers/devices_provider.dart';
import 'package:fl_clash/verstro/providers/orders_provider.dart';
import 'package:fl_clash/verstro/providers/promotions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// 绕过真实 /me 请求: 直接返回一个已登录用户, 不触碰 backendApiProvider/token 存储。
class _FakeAuthNotifier extends AuthNotifier {
  @override
  Future<AuthState> build() async => AuthState(
    user: UserDto(
      id: 1,
      email: 'user@example.com',
      emailVerifiedAt: DateTime.now(),
      createdAt: DateTime.now(),
    ),
  );
}

const _fakeAgent = AgentDto(
  code: '',
  directCount: 0,
  refereeRewardCents: 0,
  referrerRewardCents: 0,
  tier: 'promoter',
  pendingCents: 0,
  availableCents: 0,
  paidCents: 0,
  overrideAvailableCents: 0,
  subAgentCount: 0,
  canRecruit: false,
);

Future<void> pumpAccountPage(WidgetTester tester, SubscriptionDto sub, {Future<CreditDto> Function()? fetchCredit}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
        subscriptionProvider.overrideWith((ref) async => sub),
        ordersListProvider.overrideWith((ref) async => const <OrderDto>[]),
        devicesListProvider.overrideWith(
          (ref) async => const DevicesInfo(devices: [], maxDevices: 0),
        ),
        creditProvider.overrideWith(
          (ref) async => fetchCredit != null ? await fetchCredit() : const CreditDto(balanceCents: 0, credits: []),
        ),
        agentProvider.overrideWith((ref) async => _fakeAgent),
        myPromotionsProvider.overrideWith(
          (ref) async => const MyPromotionsState(supported: true),
        ),
      ],
      child: const MaterialApp(home: VerstroAccountPage()),
    ),
  );
  // 多个 FutureProvider + AsyncNotifierProvider 各自下一微任务出数据, 多 pump 几次让它们都落地。
  for (var i = 0; i < 5; i++) {
    await tester.pump();
  }
}

Future<void> pumpOrderHistory(
  WidgetTester tester,
  List<OrderDto> orders, {
  NavigatorObserver? navigatorObserver,
}) async {
  // 强制销毁前一个 ProviderContainer，确保同一测试内切换订单 fixture 时
  // 不复用上一组 FutureProvider 状态。
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ordersListProvider.overrideWith((ref) async => orders),
        orderDetailStreamProvider.overrideWith((ref, orderId) async* {
          yield orders.singleWhere((order) => order.id == orderId);
        }),
      ],
      child: MaterialApp(
        home: const VerstroOrderHistoryPage(),
        navigatorObservers: [?navigatorObserver],
      ),
    ),
  );
  for (var i = 0; i < 3; i++) {
    await tester.pump();
  }
}

class RecordingNavigatorObserver extends NavigatorObserver {
  final pushedRoutes = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

OrderDto historyOrder({
  required int id,
  required String status,
  required DateTime expiresAt,
  int receivedCents = 0,
  int remainingCents = 0,
  int paymentCount = 0,
}) => OrderDto(
  id: id,
  planId: 'monthly',
  basePrice: '6.00',
  finalAmount: '6.07',
  status: status,
  depositAddress: status == 'waiting' || status == 'partially_paid'
      ? 'TXxxxxxxxxxxxxxxxxxxxxxxxxxxxEygM'
      : null,
  payCurrency: 'usdttrc20',
  txid: status == 'finished' ? 'finished-order-hash' : null,
  createdAt: expiresAt.subtract(const Duration(hours: 1)),
  expiresAt: expiresAt,
  paidAt: status == 'finished' ? DateTime.now() : null,
  receivedCents: receivedCents,
  remainingCents: remainingCents,
  paymentCount: paymentCount,
);

void main() {
  setUpAll(() async {
    // 断言的关键就是 locale != zh_CN 时不应再看到后端中文名。
    await AppLocalizations.load(const Locale('en'));
  });

  testWidgets('订阅卡: grant.planName 走 localizedPlanName, 不泄漏后端中文名', (
    tester,
  ) async {
    final sub = SubscriptionDto(
      hasSubscription: true,
      subscriptionUrl: null,
      currentPlanId: 'monthly',
      periodStartedAt: DateTime.now(),
      periodExpiresAt: DateTime.now().add(const Duration(days: 30)),
      trafficLimitBytes: 2 * 1024 * 1024 * 1024,
      trafficUsedBytes: 0,
      totalRemainingBytes: 2 * 1024 * 1024 * 1024,
      isExpired: false,
      grants: [
        // 后端下发的 plan_name 仍是中文 (真实后端行为), 客户端必须按 planId 查表本地化。
        const GrantDto(
          planId: 'monthly',
          planName: '标准·月付',
          quotaBytes: 1024 * 1024 * 1024,
          consumedBytes: 0,
          remainingBytes: 1024 * 1024 * 1024,
          expiresAt: null,
          status: 'active',
        ),
        const GrantDto(
          planId: 'premium-yearly',
          planName: '专业·年付',
          quotaBytes: 1024 * 1024 * 1024,
          consumedBytes: 0,
          remainingBytes: 1024 * 1024 * 1024,
          expiresAt: null,
          status: 'active',
        ),
      ],
    );

    await pumpAccountPage(tester, sub);

    // 后端中文名不应该出现在任何地方 (badge / 套餐行 / 多套餐明细行)。
    expect(find.text('标准·月付'), findsNothing);
    expect(find.text('专业·年付'), findsNothing);

    // localizedPlanName 查表后的英文名应该出现 (多套餐明细逐条渲染, _GrantTile 里各占一行)。
    expect(find.text('Standard · Monthly'), findsOneWidget);
    expect(find.text('Pro · Yearly'), findsOneWidget);
  });

  testWidgets('订单历史展示订单自身 basePrice 而不是套餐硬编码价格', (tester) async {
    final now = DateTime.now();
    final orders = [
      OrderDto(
        id: 101,
        planId: 'monthly',
        basePrice: '6.00',
        finalAmount: '6.07',
        status: 'finished',
        depositAddress: null,
        payCurrency: 'usdttrc20',
        txid: 'new-price-order',
        createdAt: now,
        expiresAt: now.add(const Duration(days: 1)),
        paidAt: now,
      ),
      OrderDto(
        id: 100,
        planId: 'monthly',
        basePrice: '5.00',
        finalAmount: '5.14',
        status: 'finished',
        depositAddress: null,
        payCurrency: 'usdttrc20',
        txid: 'legacy-price-order',
        createdAt: now.subtract(const Duration(days: 30)),
        expiresAt: now.subtract(const Duration(days: 29)),
        paidAt: now.subtract(const Duration(days: 30)),
      ),
    ];

    await pumpOrderHistory(tester, orders);

    expect(find.text('Standard · Monthly \$6.00'), findsOneWidget);
    expect(find.text('Standard · Monthly \$5.00'), findsOneWidget);
  });

  testWidgets('部分付款订单显示本地化进度且未过期时可恢复发票页', (tester) async {
    final observer = RecordingNavigatorObserver();
    final partial = historyOrder(
      id: 201,
      status: 'partially_paid',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      receivedCents: 400,
      remainingCents: 207,
      paymentCount: 1,
    );

    await pumpOrderHistory(tester, [partial], navigatorObserver: observer);

    expect(find.text('partially_paid'), findsNothing);
    expect(find.textContaining(r'Received $4.00'), findsOneWidget);
    expect(find.textContaining(r'$2.07 remains'), findsOneWidget);
    expect(find.text('Tap to continue payment'), findsOneWidget);

    final pushesBeforeTap = observer.pushedRoutes.length;
    await tester.tap(find.text('#201'));

    expect(observer.pushedRoutes, hasLength(pushesBeforeTap + 1));
    final route = observer.pushedRoutes.last as MaterialPageRoute<dynamic>;
    expect(
      route.builder(tester.element(find.byType(VerstroOrderHistoryPage))),
      isA<VerstroUsdtInvoicePage>(),
    );
  });

  testWidgets('未过期 waiting 订单仍可恢复发票页', (tester) async {
    final observer = RecordingNavigatorObserver();
    final waiting = historyOrder(
      id: 202,
      status: 'waiting',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );

    await pumpOrderHistory(tester, [waiting], navigatorObserver: observer);
    expect(find.text('Awaiting payment'), findsOneWidget);

    final pushesBeforeTap = observer.pushedRoutes.length;
    await tester.tap(find.text('#202'));

    expect(observer.pushedRoutes, hasLength(pushesBeforeTap + 1));
    final route = observer.pushedRoutes.last as MaterialPageRoute<dynamic>;
    expect(
      route.builder(tester.element(find.byType(VerstroOrderHistoryPage))),
      isA<VerstroUsdtInvoicePage>(),
    );
  });

  testWidgets('finished 和 failed 终态不可恢复发票页', (tester) async {
    for (final status in ['finished', 'failed']) {
      final terminal = historyOrder(
        id: status == 'finished' ? 203 : 204,
        status: status,
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      await pumpOrderHistory(tester, [terminal]);

      expect(find.text('#${terminal.id}'), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
      final tile = tester.widget<InkWell>(find.byType(InkWell));
      expect(tile.onTap, isNull, reason: status);
      expect(find.byType(VerstroUsdtInvoicePage), findsNothing);
    }
  });

  testWidgets('expired 终态只保留重新下单，不恢复旧发票页', (tester) async {
    final observer = RecordingNavigatorObserver();
    final expired = historyOrder(
      id: 205,
      status: 'expired',
      expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
    );

    await pumpOrderHistory(tester, [expired], navigatorObserver: observer);
    expect(find.text('Tap to order again'), findsOneWidget);

    final pushesBeforeTap = observer.pushedRoutes.length;
    await tester.tap(find.text('#205'));

    expect(observer.pushedRoutes, hasLength(pushesBeforeTap + 1));
    final route = observer.pushedRoutes.last as MaterialPageRoute<dynamic>;
    expect(
      route.builder(tester.element(find.byType(VerstroOrderHistoryPage))),
      isNot(isA<VerstroUsdtInvoicePage>()),
    );
  });
  testWidgets('下拉刷新重新获取credit并等待完成', (tester) async {
    var reads = 0;
    await pumpAccountPage(tester, SubscriptionDto.fromJson({'has_subscription': false}), fetchCredit: () async {
      reads++;
      return CreditDto(balanceCents: reads == 1 ? 10 : 20, credits: const []);
    });
    final refresh = tester.widget<RefreshIndicator>(find.byType(RefreshIndicator));
    await refresh.onRefresh();
    await tester.pump(); await tester.pump();
    expect(reads, 2);
    final list = tester.widget<ListView>(find.byType(ListView).first);
    expect(list.physics, isA<AlwaysScrollableScrollPhysics>());
  });
  testWidgets('下拉刷新请求失败保留provider错误，不抛出未处理异常', (tester) async {
    var reads = 0;
    await pumpAccountPage(tester, SubscriptionDto.fromJson({'has_subscription': false}), fetchCredit: () async {
      if (++reads > 1) throw StateError('offline');
      return const CreditDto(balanceCents: 10, credits: []);
    });
    final refresh = tester.widget<RefreshIndicator>(find.byType(RefreshIndicator));
    await expectLater(refresh.onRefresh(), completes);
    await tester.pump(); await tester.pump();
    final container = ProviderScope.containerOf(tester.element(find.byType(VerstroAccountPage)));
    expect(container.read(creditProvider).hasError, isTrue);
    expect(tester.takeException(), isNull);
  });

}
