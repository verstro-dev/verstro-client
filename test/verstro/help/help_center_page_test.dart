import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/help/help_center_page.dart';
import 'package:fl_clash/verstro/help/help_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpHelp(
  WidgetTester tester, {
  required VerstroHelpAudience audience,
  VerstroExternalLauncher? externalLauncher,
  VerstroOnboardingReplay? onReplayOnboarding,
}) {
  return tester.pumpWidget(
    MaterialApp(
      locale: const Locale('zh', 'CN'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      home: VerstroHelpCenterPage(
        audienceOverride: audience,
        externalLauncher: externalLauncher,
        onReplayOnboarding: onReplayOnboarding,
      ),
    ),
  );
}

void main() {
  testWidgets('桌面帮助渲染模式说明、八项 FAQ 和外部入口', (tester) async {
    await pumpHelp(tester, audience: VerstroHelpAudience.desktop);
    await tester.pumpAndSettle();

    expect(find.text('帮助中心'), findsOneWidget);
    expect(find.text('系统代理'), findsWidgets);
    expect(find.text('虚拟网卡（TUN）'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsAtLeastNWidgets(8));
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(find.text('查看完整网页版帮助'), findsOneWidget);
  });

  testWidgets('移动帮助不显示桌面组合并显示系统 VPN', (tester) async {
    await pumpHelp(tester, audience: VerstroHelpAudience.mobile);
    await tester.pumpAndSettle();

    expect(find.text('系统 VPN 通道'), findsOneWidget);
    expect(find.text('流量接管范围'), findsNothing);
  });

  testWidgets('外链启动失败时显示错误提示', (tester) async {
    await pumpHelp(
      tester,
      audience: VerstroHelpAudience.desktop,
      externalLauncher: (_) async => false,
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('查看完整网页版帮助'));
    await tester.pump();

    expect(find.text('无法打开: https://verstro.com/help'), findsOneWidget);
  });

  testWidgets('未注入回调时可直接手动重播引导', (tester) async {
    await pumpHelp(tester, audience: VerstroHelpAudience.desktop);
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('重播新手引导'));
    await tester.pumpAndSettle();

    expect(find.text('连接'), findsOneWidget);
    expect(find.text('1 / 5'), findsOneWidget);
  });

  testWidgets('注入重播回调时仍优先调用外部实现', (tester) async {
    var replayCalls = 0;
    await pumpHelp(
      tester,
      audience: VerstroHelpAudience.desktop,
      onReplayOnboarding: (_) async => replayCalls++,
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('重播新手引导'));
    await tester.pumpAndSettle();

    expect(replayCalls, 1);
    expect(find.text('连接'), findsNothing);
  });
}
