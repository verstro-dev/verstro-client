// 账户余额卡 widget 测试 (入口命名优化批次):
// 1) 改名「账户余额」+ 新副文案 (与官网控制台统一口径)
// 2) alwaysShow: 账号页常驻 — 余额 0 也渲染 $0.00, 让"多付/少付自动入余额"机制可发现
// 3) 默认 (套餐页): 保持 balance>0 才渲染的促购语义

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/providers/credit_provider.dart';
import 'package:fl_clash/verstro/widgets/credit_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpCard(WidgetTester tester, int balanceCents,
    {bool alwaysShow = false}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        creditProvider.overrideWith((ref) async =>
            CreditDto(balanceCents: balanceCents, credits: const [])),
      ],
      child: MaterialApp(
          home: Scaffold(body: CreditBalanceCard(alwaysShow: alwaysShow))),
    ),
  );
  // FutureProvider 下一微任务出数据
  await tester.pump();
  await tester.pump();
}

void main() {
  setUpAll(() async {
    // i18n 批次后组件文案走 appLocalizations, 测试断言中文需先加载 zh_CN
    await AppLocalizations.load(const Locale('zh', 'CN'));
  });

  testWidgets('默认 (套餐页): 余额 0 不渲染', (tester) async {
    await pumpCard(tester, 0);
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('alwaysShow (账号页): 余额 0 也渲染 \$0.00 + 新副文案', (tester) async {
    await pumpCard(tester, 0, alwaysShow: true);
    expect(find.text('账户余额  \$0.00'), findsOneWidget);
    expect(find.text('购买时自动抵扣 · 多付/少付自动存入余额'), findsOneWidget);
  });

  testWidgets('默认: 余额 >0 渲染新标题', (tester) async {
    await pumpCard(tester, 1250);
    expect(find.text('账户余额  \$12.50'), findsOneWidget);
  });
}
