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

Future<void> pumpAccountPage(WidgetTester tester, SubscriptionDto sub) async {
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
          (ref) async => const CreditDto(balanceCents: 0, credits: []),
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
  List<OrderDto> orders,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [ordersListProvider.overrideWith((ref) async => orders)],
      child: const MaterialApp(home: VerstroOrderHistoryPage()),
    ),
  );
  for (var i = 0; i < 3; i++) {
    await tester.pump();
  }
}

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
}
