// 分享推广页测试:
// 1) buildShareText 纯函数 —— 3 风格 × 奖励分支(相等/不等/为零) × 试用开关 × 无码,
//    口径断言(试用句 gate / TUN 只进开发者向 / 统一域名)。
// 2) SharePoster 冒烟 —— 有码/无码两态关键元素渲染。
// 3) VerstroSharePage 冒烟 —— provider 覆盖后页面可用(保存按钮/文案区)。

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/pages/share_page.dart';
import 'package:fl_clash/verstro/providers/agent_provider.dart';
import 'package:fl_clash/verstro/providers/trial_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    // i18n 批次后组件文案走 appLocalizations, 测试断言中文需先加载 zh_CN
    await AppLocalizations.load(const Locale('zh', 'CN'));
  });

  group('fmtUsdShort', () {
    test('整额不带小数', () => expect(fmtUsdShort(200), '\$2'));
    test('非整额保留两位', () => expect(fmtUsdShort(250), '\$2.50'));
  });

  group('buildPartnerRegistrationUrl', () {
    test('邀请码生成可自动归因的注册链接', () {
      expect(
        buildPartnerRegistrationUrl(' p253mphe '),
        'https://verstro.com/account?ref=P253MPHE#register',
      );
    });
    test('无码时降级官网', () {
      expect(buildPartnerRegistrationUrl(''), 'https://verstro.com');
    });
  });

  group('buildShareText 通用', () {
    String build({
      String code = 'P253MPHE',
      int referee = 200,
      int referrer = 200,
      bool trial = true,
      int days = 3,
    }) => buildShareText(
      style: ShareCopyStyle.general,
      code: code,
      refereeRewardCents: referee,
      referrerRewardCents: referrer,
      trialEnabled: trial,
      trialDays: days,
    );

    test('全量: 品牌句 + 试用 + 双边奖励 + 统一域名', () {
      final t = build();
      expect(t, contains('我在用 Verstro'));
      expect(t, contains('新用户可免费试用 3 天。'));
      // 「首购后」不可省: 奖励在首笔付费履约时发放, 措辞须与真实时机一致
      expect(t, contains('注册时填我的邀请码 P253MPHE，首购后你我各得 \$2 抵扣。'));
      expect(
        t,
        endsWith('下载：https://verstro.com/account?ref=P253MPHE#register'),
      );
      // 口径: 大众向不出现技术词
      expect(t.contains('TUN'), isFalse);
    });

    test('试用关闭 → 无免费试用句(口径红线)', () {
      expect(build(trial: false).contains('免费试用'), isFalse);
    });

    test('试用开启但无天数 → 只说可试用不编造天数', () {
      final t = build(days: 0);
      expect(t, contains('新用户可免费试用。'));
    });

    test('奖励不等 → 只对受众陈述其可得额', () {
      final t = build(referee: 250, referrer: 100);
      expect(t, contains('首购后可得 \$2.50 抵扣'));
      expect(t.contains('你我各得'), isFalse);
    });

    test('零奖励 → 仅邀请码, 无抵扣承诺', () {
      final t = build(referee: 0, referrer: 0);
      expect(t, contains('注册时填我的邀请码 P253MPHE。'));
      expect(t.contains('抵扣'), isFalse);
    });

    test('无码 → 整个邀请句省略, 域名仍在', () {
      final t = build(code: '');
      expect(t.contains('邀请码'), isFalse);
      expect(t, contains('https://verstro.com'));
    });
  });

  group('buildShareText 其它风格', () {
    test('简洁: 短句 + 短邀请句式', () {
      final t = buildShareText(
        style: ShareCopyStyle.brief,
        code: 'P253MPHE',
        refereeRewardCents: 200,
        referrerRewardCents: 200,
        trialEnabled: true,
        trialDays: 3,
      );
      expect(t, startsWith('Verstro 隐私优先的跨平台网络工具'));
      // 「首购后」「抵扣」不可省: 到账时机与奖励形式都要措辞诚实
      expect(t, contains('注册填邀请码 P253MPHE，首购后你我各得 \$2 抵扣。'));
      expect(t, contains('可免费试用。'));
      expect(t, endsWith('https://verstro.com/account?ref=P253MPHE#register'));
    });

    test('开发者向: TUN/GPLv3 技术卖点只在此风格出现', () {
      final t = buildShareText(
        style: ShareCopyStyle.developer,
        code: 'P253MPHE',
        refereeRewardCents: 0,
        referrerRewardCents: 0,
        trialEnabled: false,
        trialDays: 0,
      );
      expect(t, contains('TUN'));
      expect(t, contains('GPLv3'));
      expect(t, contains('终端、Docker、Git'));
      expect(t, contains('实际覆盖受系统、应用、规则与网络环境影响'));
      expect(t, isNot(contains('全部流量')));
      expect(t, contains('注册填邀请码 P253MPHE。'));
    });
  });

  group('SharePoster', () {
    Widget host(SharePoster poster) => MaterialApp(
      home: Scaffold(body: Center(child: poster)),
    );

    testWidgets('有码: 邀请码/奖励/试用/主标题/域名齐全', (tester) async {
      await tester.pumpWidget(
        host(
          const SharePoster(
            code: 'P253MPHE',
            refereeRewardCents: 200,
            referrerRewardCents: 200,
            trialEnabled: true,
            trialDays: 3,
            trialTrafficGb: 10,
          ),
        ),
      );
      expect(find.text('跨应用网络连接'), findsOneWidget);
      expect(find.text('P253MPHE'), findsOneWidget);
      expect(find.text('填码注册 · 首购后你我各得 \$2'), findsOneWidget);
      expect(find.text('新用户免费试用 3 天 · 10GB'), findsOneWidget);
      // 「扫码下载 · verstro.com」是 Text.rich 混排(CJK 系统字体 + URL 等宽)
      expect(
        find.text('扫码下载 · verstro.com', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('客户端 GPLv3 开源 · 行为可审计'), findsOneWidget);
    });

    testWidgets('无码: 降级为下载引导, 试用关闭无 pill', (tester) async {
      await tester.pumpWidget(
        host(
          const SharePoster(
            code: '',
            refereeRewardCents: 0,
            referrerRewardCents: 0,
            trialEnabled: false,
            trialDays: 0,
            trialTrafficGb: 0,
          ),
        ),
      );
      expect(find.text('获取 Verstro'), findsOneWidget);
      expect(find.text('扫码访问官网，下载客户端'), findsOneWidget);
      expect(find.textContaining('免费试用'), findsNothing);
      expect(find.textContaining('邀请码'), findsNothing);
    });
  });

  group('VerstroSharePage', () {
    testWidgets('数据就绪后渲染海报 + 保存/复制操作区', (tester) async {
      const agent = AgentDto(
        code: 'P253MPHE',
        directCount: 0,
        refereeRewardCents: 200,
        referrerRewardCents: 200,
        tier: 'promoter',
        pendingCents: 0,
        availableCents: 0,
        paidCents: 0,
        overrideAvailableCents: 0,
        subAgentCount: 0,
        canRecruit: false,
      );
      const trial = TrialStatusDto(
        enabled: true,
        claimed: false,
        days: 3,
        trafficGb: 10,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            agentProvider.overrideWith((ref) async => agent),
            trialStatusProvider.overrideWith((ref) async => trial),
          ],
          child: const MaterialApp(home: VerstroSharePage()),
        ),
      );
      // FutureProvider 下一微任务出数据
      await tester.pump();
      await tester.pump();
      expect(find.text('保存图片'), findsOneWidget);
      expect(find.text('复制文案'), findsOneWidget);
      expect(find.text('P253MPHE'), findsOneWidget);
      // 默认通用风格文案已拼出邀请码
      expect(find.textContaining('注册时填我的邀请码 P253MPHE'), findsOneWidget);
    });
  });
}
