import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/providers/credit_provider.dart';
import 'support/test_auth.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/verstro/widgets/credit_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

CreditDto pending({DateTime? expires}) => CreditDto.fromJson({
  'balance_cents': 250,
  'credits': null,
  'pending_order_cents': 100,
  'pending_orders': [
    {
      'order_id': 501,
      'received_cents': 100,
      'remaining_cents': 401,
      'expires_at': (expires ?? DateTime.now().add(const Duration(hours: 1)))
          .toUtc()
          .toIso8601String(),
    },
  ],
});

void main() {
  setUpAll(() async => AppLocalizations.load(const Locale('zh', 'CN')));

  Future<ProviderContainer> pump(
    WidgetTester tester,
    Future<CreditDto> Function() fetch, {
    bool account = true,
  }) async {
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(TestAuth.new),
        creditProvider.overrideWith((ref) => fetch()),
      ],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: CreditBalanceCard(alwaysShow: account)),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    return container;
  }

  testWidgets('可用余额与全账户待补款独立显示，不合并金额', (tester) async {
    await pump(tester, () async => pending());
    expect(find.text('可用余额  \$2.50'), findsOneWidget);
    expect(find.text('待补款订单已收金额'), findsOneWidget);
    expect(find.text('1.00 USDT'), findsOneWidget);
    expect(find.textContaining('4.01 USDT'), findsOneWidget);
    expect(find.textContaining('#501'), findsOneWidget);
    expect(find.text('继续补付'), findsOneWidget);
    expect(find.textContaining('3.50'), findsNothing);
  });
  testWidgets('已过期 active 金额保留但禁止补付', (tester) async {
    await pump(
      tester,
      () async =>
          pending(expires: DateTime.now().subtract(const Duration(seconds: 1))),
    );
    expect(find.text('等待转余额'), findsOneWidget);
    expect(find.text('继续补付'), findsNothing);
    expect(find.text('1.00 USDT'), findsOneWidget);
  });
  testWidgets('页面停留跨过期时间后禁止补付', (tester) async {
    await pump(
      tester,
      () async => pending(
        expires: DateTime.now().add(const Duration(milliseconds: 20)),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('等待转余额'), findsOneWidget);
    expect(find.text('继续补付'), findsNothing);
  });
  testWidgets('刷新完成后移除 pending，不在客户端重复加余额', (tester) async {
    var value = pending();
    final container = await pump(tester, () async => value);
    expect(find.text('待补款订单已收金额'), findsOneWidget);
    value = const CreditDto(balanceCents: 250, credits: []);
    container.invalidate(creditProvider);
    await tester.pump();
    await tester.pump();
    expect(find.text('待补款订单已收金额'), findsNothing);
    expect(find.text('可用余额  \$2.50'), findsOneWidget);
  });
  testWidgets('错误显示重试，不伪装为零余额', (tester) async {
    await pump(tester, () async => throw StateError('offline'));
    expect(find.text('余额加载失败，请重试'), findsOneWidget);
    expect(find.textContaining('0.00'), findsNothing);
  });
  testWidgets('套餐促购只用可用余额，不显示 pending', (tester) async {
    await pump(
      tester,
      () async =>
          CreditDto(balanceCents: 0, credits: const [], pendingOrderCents: 100),
      account: false,
    );
    expect(find.byType(Card), findsNothing);
  });
  testWidgets('旧后端缺省 pending 为空', (tester) async {
    await pump(
      tester,
      () async => CreditDto.fromJson({'balance_cents': 0, 'credits': null}),
    );
    expect(find.text('可用余额  \$0.00'), findsOneWidget);
    expect(find.text('待补款订单已收金额'), findsNothing);
  });
  testWidgets('登出后隐藏整个余额卡，包括错误状态', (tester) async {
    final container = await pump(
      tester,
      () async => throw StateError('offline'),
    );
    expect(find.text('余额加载失败，请重试'), findsOneWidget);
    (container.read(authNotifierProvider.notifier) as TestAuth).logoutForTest();
    await tester.pump();
    await tester.pump();
    expect(find.text('余额加载失败，请重试'), findsNothing);
    expect(find.byType(Card), findsNothing);
  });
}
