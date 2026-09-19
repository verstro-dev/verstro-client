// 推广中心入口卡 widget 测试 (入口命名优化批次):
// 1) title 固定「推广中心」— 无佣金时也可见, 解决"入口没有推广中心四个字"
// 2) 可提现金额右置 trailing, 仅 availableCents>0 显示
// 3) subtitle 利益点 + 已邀请人数 (邀请码移除, 面板内已有)
// 4) code 空 → 整卡不渲染; master + 有余额同排不溢出
//
// 风格参考 agent_panel_page_test.dart: ProviderScope override agentProvider 喂静态数据.

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/providers/agent_provider.dart';
import 'package:fl_clash/verstro/widgets/agent_entry_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

AgentDto agent({
  String code = 'P253MPHE',
  int directCount = 3,
  String tier = 'promoter',
  int availableCents = 0,
  PartnerAuthorizationDto? partnerAuthorization,
}) => AgentDto(
  code: code,
  directCount: directCount,
  refereeRewardCents: 200,
  referrerRewardCents: 200,
  tier: tier,
  pendingCents: 0,
  availableCents: availableCents,
  paidCents: 0,
  overrideAvailableCents: 0,
  subAgentCount: 0,
  canRecruit: false,
  partnerAuthorization: partnerAuthorization,
);

Future<void> pumpCard(WidgetTester tester, AgentDto a, {Size? surface}) async {
  if (surface != null) {
    await tester.binding.setSurfaceSize(surface);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: [agentProvider.overrideWith((ref) async => a)],
      child: const MaterialApp(home: Scaffold(body: AgentEntryCard())),
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

  testWidgets('code 空 → 整卡不渲染', (tester) async {
    await pumpCard(tester, agent(code: ''));
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('无佣金 promoter: title 固定推广中心, 无金额, 无 tier Chip', (tester) async {
    await pumpCard(tester, agent());
    expect(find.text('推广中心'), findsOneWidget);
    expect(find.text('邀请好友赚 30% 佣金 · 已邀请 3 人'), findsOneWidget);
    expect(find.textContaining('可提现'), findsNothing);
    expect(find.byType(Chip), findsNothing);
    // 邀请码已移出入口卡 (面板内有大字邀请码 + 复制)
    expect(find.textContaining('P253MPHE'), findsNothing);
  });

  testWidgets('有佣金: trailing 显示可提现金额, title 仍是推广中心', (tester) async {
    await pumpCard(tester, agent(availableCents: 1234));
    expect(find.text('推广中心'), findsOneWidget);
    expect(find.text('可提现 \$12.34'), findsOneWidget);
  });

  testWidgets('正式战略分销授权 + 有余额: 认证 Chip 与金额并存, 360dp 窄屏不溢出', (tester) async {
    await pumpCard(
      tester,
      agent(
        tier: 'master',
        availableCents: 123456,
        partnerAuthorization: const PartnerAuthorizationDto(
          authorizationCode: 'VPA-23456789',
          level: 'strategic_distributor',
          status: 'active',
          cooperationMode: 'non_exclusive',
          capabilities: ['verified_partner_badge', 'manage_resellers'],
        ),
      ),
      surface: const Size(360, 640),
    );
    expect(find.text('可提现 \$1234.56'), findsOneWidget);
    expect(find.text('战略分销伙伴'), findsOneWidget);
    expect(tester.takeException(), isNull); // 无 RenderFlex overflow
  });

  testWidgets('裸 master 技术档位没有正式授权时不显示认证 Chip', (tester) async {
    await pumpCard(tester, agent(tier: 'master'));
    expect(find.byType(Chip), findsNothing);
    expect(find.text('战略分销伙伴'), findsNothing);
  });
}
