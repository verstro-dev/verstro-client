// 推广中心页 widget 测试 (payout 透明化改造):
// 1) 钱包卡四态 — 待成熟/处理中/已打款; "处理中"行仅 processingCents>0 显示
// 2) 提现门槛动态化 — 跟随 min_payout_cents; 旧后端 0 → $10 fallback
// 3) processing>0 前置守卫 — 提现按钮替换为"处理中"文案
// 4) 提现记录 — 三态徽章 / failed 退回说明 / dest 打码 / sent txid 行
// 5) 二次确认弹窗 — 人工打款新文案关键词, 旧"发起链上转账"句已删
//
// 风格参考 share_page_test.dart: ProviderScope override agentProvider 喂静态数据.

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/pages/agent_panel_page.dart';
import 'package:fl_clash/verstro/providers/agent_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

AgentDto agent({
  int pendingCents = 0,
  int availableCents = 0,
  int paidCents = 0,
  int processingCents = 0,
  int minPayoutCents = 0,
  List<AgentPayoutDto> payouts = const [],
}) =>
    AgentDto(
      code: 'P253MPHE',
      directCount: 3,
      refereeRewardCents: 200,
      referrerRewardCents: 200,
      tier: 'promoter',
      pendingCents: pendingCents,
      availableCents: availableCents,
      paidCents: paidCents,
      overrideAvailableCents: 0,
      subAgentCount: 0,
      canRecruit: false,
      processingCents: processingCents,
      minPayoutCents: minPayoutCents,
      payouts: payouts,
    );

/// 页面较长 (邀请码卡 + 钱包卡 + 提现区 + 记录区), 加高 surface 避免
/// ListView 视口外的 widget 不构建导致 find 落空.
Future<void> pumpPanel(WidgetTester tester, AgentDto a) async {
  await tester.binding.setSurfaceSize(const Size(800, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        agentProvider.overrideWith((ref) async => a),
        agentPricesProvider.overrideWith(
            (ref) async => const AgentPricesDto(tier: 'promoter', prices: [])),
      ],
      child: const MaterialApp(home: VerstroAgentPanelPage()),
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

  group('钱包卡四态', () {
    testWidgets('processing>0: 四行齐全 + 提现按钮替换为处理中文案', (tester) async {
      await pumpPanel(
        tester,
        agent(
          pendingCents: 1234,
          availableCents: 2000,
          paidCents: 900,
          processingCents: 5678,
          minPayoutCents: 1000,
        ),
      );
      expect(find.text('可提现 \$20.00'), findsOneWidget);
      expect(find.text('待成熟 \$12.34（14 天成熟期）'), findsOneWidget);
      expect(find.text('处理中 \$56.78（人工打款中）'), findsOneWidget);
      expect(find.text('已打款 \$9.00'), findsOneWidget);
      // 前置守卫: 已有一笔在途, 即使余额够门槛也不能再次发起
      expect(find.text('提现到 TRC20'), findsNothing);
      expect(find.text('有一笔提现正在处理中，完成后可再次发起'), findsOneWidget);
    });

    testWidgets('processing=0: 处理中行不渲染, 提现按钮正常', (tester) async {
      await pumpPanel(
          tester, agent(availableCents: 2000, minPayoutCents: 1000));
      expect(find.textContaining('处理中'), findsNothing);
      expect(find.text('提现到 TRC20'), findsOneWidget);
    });
  });

  group('提现门槛动态化', () {
    testWidgets('min_payout_cents=2000 → 未满文案显示 \$20.00', (tester) async {
      await pumpPanel(
          tester, agent(availableCents: 1500, minPayoutCents: 2000));
      expect(find.text('提现到 TRC20'), findsNothing);
      expect(find.text('满 \$20.00 可提现 (当前 \$15.00)'), findsOneWidget);
    });

    testWidgets('旧后端 min_payout_cents=0 → fallback \$10.00', (tester) async {
      await pumpPanel(tester, agent(availableCents: 500));
      expect(find.text('满 \$10.00 可提现 (当前 \$5.00)'), findsOneWidget);
    });

    testWidgets('可提现恰好达 min → 显示提现按钮', (tester) async {
      await pumpPanel(
          tester, agent(availableCents: 2000, minPayoutCents: 2000));
      expect(find.text('提现到 TRC20'), findsOneWidget);
    });
  });

  group('提现记录', () {
    testWidgets('三态徽章 + failed 说明行 + dest 打码 + sent txid 行', (tester) async {
      const dest = 'TLyqzVGLV1srkB7dToTAEqgDSfPtXRJZYH';
      final payouts = [
        AgentPayoutDto(
          id: 1,
          amountCents: 1000,
          dest: dest,
          status: 'requested',
          createdAt: DateTime(2026, 7, 1),
        ),
        AgentPayoutDto(
          id: 2,
          amountCents: 2000,
          dest: dest,
          status: 'sent',
          txid:
              'aabbccddeeff00112233445566778899aabbccddeeff00112233445566778899',
          createdAt: DateTime(2026, 6, 20),
          settledAt: DateTime(2026, 6, 21),
        ),
        AgentPayoutDto(
          id: 3,
          amountCents: 1500,
          dest: dest,
          status: 'failed',
          createdAt: DateTime(2026, 6, 10),
        ),
      ];
      await pumpPanel(tester, agent(payouts: payouts));

      expect(find.text('提现记录'), findsOneWidget);
      // 三态徽章 (精确匹配: 钱包卡"已打款 $X.XX"是另一条完整字符串, 不会撞)
      expect(find.text('人工打款中'), findsOneWidget);
      expect(find.text('已打款'), findsOneWidget);
      expect(find.text('已退回'), findsOneWidget);
      // failed 退回说明
      expect(find.text('打款未成功，金额已退回可提现余额'), findsOneWidget);
      // dest 打码: 前 6 + … + 后 4, 三条都有
      expect(find.text('到账地址 TLyqzV…JZYH'), findsNWidgets(3));
      // sent 条目: txid 前 8…后 8 + TronScan 入口
      expect(find.textContaining('aabbccdd…66778899'), findsOneWidget);
      expect(find.text('在 TronScan 查看'), findsOneWidget);
      // 日期 yyyy-MM-dd
      expect(find.text('2026-07-01'), findsOneWidget);
      // requested/failed 条目不显示 txid 行
      expect(find.textContaining('tx: '), findsOneWidget);
    });

    testWidgets('payouts 为空 → 整个区块不渲染', (tester) async {
      await pumpPanel(tester, agent(availableCents: 500));
      expect(find.text('提现记录'), findsNothing);
    });
  });

  group('提现二次确认弹窗', () {
    testWidgets('人工打款新文案关键词齐全, 旧"发起链上转账"句已删', (tester) async {
      await pumpPanel(
          tester, agent(availableCents: 2000, minPayoutCents: 1000));

      await tester.tap(find.text('提现到 TRC20'));
      await tester.pumpAndSettle();
      // Step 1: 输入合法 TRC20 地址 (T 开头 + 33 位 Base58)
      await tester.enterText(find.byType(TextField), 'T${'A' * 33}');
      await tester.tap(find.text('下一步'));
      await tester.pumpAndSettle();

      // Step 2: 二次确认弹窗关键词
      expect(find.textContaining('提现金额：\$20.00'), findsOneWidget);
      expect(find.textContaining('提交后由人工打款'), findsOneWidget);
      expect(find.textContaining('通常 24 小时内到账'), findsOneWidget);
      expect(find.textContaining('最迟不超过 3 个工作日'), findsOneWidget);
      expect(find.textContaining('链上手续费由平台承担'), findsOneWidget);
      expect(find.textContaining('提交后不可修改'), findsOneWidget);
      expect(find.textContaining('确认后将发起链上转账'), findsNothing);

      // 收尾: 不真正发起提现
      await tester.tap(find.text('再想想'));
      await tester.pumpAndSettle();
    });
  });
}
