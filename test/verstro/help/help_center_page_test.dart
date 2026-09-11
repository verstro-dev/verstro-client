import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/help/help_center_page.dart';
import 'package:fl_clash/verstro/help/help_content.dart';
import 'package:fl_clash/verstro/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

Future<void> reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pump();
}

Future<void> pumpAbout(WidgetTester tester) async {
  PackageInfo.setMockInitialValues(
    appName: 'Verstro',
    packageName: 'com.verstro.client',
    version: '1.4.15',
    buildNumber: '20200',
    buildSignature: '',
  );
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('zh', 'CN'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      home: const VerstroAboutPage(),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('桌面帮助渲染模式说明、八项 FAQ 和外部入口', (tester) async {
    await pumpHelp(tester, audience: VerstroHelpAudience.desktop);
    await tester.pumpAndSettle();

    expect(find.text('帮助中心'), findsOneWidget);
    expect(find.text('系统代理'), findsWidgets);
    expect(find.text('虚拟网卡（TUN）'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsAtLeastNWidgets(8));
    await reveal(tester, find.text('查看完整网页版帮助'));
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

    await reveal(tester, find.text('查看完整网页版帮助'));
    await tester.tap(find.text('查看完整网页版帮助'));
    await tester.pump();

    expect(find.text('无法打开: https://verstro.com/help'), findsOneWidget);
  });

  testWidgets('未注入回调时可直接手动重播引导', (tester) async {
    await pumpHelp(tester, audience: VerstroHelpAudience.desktop);
    await tester.pumpAndSettle();

    await reveal(tester, find.text('重播新手引导'));
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

    await reveal(tester, find.text('重播新手引导'));
    await tester.tap(find.text('重播新手引导'));
    await tester.pumpAndSettle();

    expect(replayCalls, 1);
    expect(find.text('连接'), findsNothing);
  });

  testWidgets('帮助中心区分公开群与私下邮箱边界并打开新群', (tester) async {
    final opened = <Uri>[];
    await pumpHelp(
      tester,
      audience: VerstroHelpAudience.desktop,
      externalLauncher: (uri) async {
        opened.add(uri);
        return true;
      },
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('公开群隐私提醒'), findsOneWidget);
    expect(find.textContaining('可私下发送至 feedback@verstro.com'), findsOneWidget);

    await reveal(tester, find.text('@verstro_chat'));
    await tester.tap(find.text('@verstro_chat'));
    await tester.pump();
    expect(opened, [Uri.parse('https://t.me/verstro_chat')]);

    await reveal(tester, find.text('feedback@verstro.com'));
    await tester.tap(find.text('feedback@verstro.com'));
    await tester.pump();
    expect(opened.last, Uri.parse('mailto:feedback@verstro.com'));
  });

  testWidgets('关于页联系区在群和邮箱入口附近实际渲染对应隐私警示', (tester) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    final launched = <String>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      final args = call.arguments as Map<Object?, Object?>;
      if (call.method == 'canLaunch') return true;
      if (call.method == 'launch') {
        launched.add(args['url']! as String);
        return true;
      }
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

    await pumpAbout(tester);

    await reveal(tester, find.text('联系与支持'));
    expect(find.textContaining('公开群隐私提醒'), findsOneWidget);
    await tester.tap(find.text('@verstro_chat'));
    await tester.pump();

    await reveal(
      tester,
      find.textContaining('敏感资料可私下发送至 feedback@verstro.com'),
    );
    expect(
      find.textContaining('敏感资料可私下发送至 feedback@verstro.com'),
      findsOneWidget,
    );
    await reveal(tester, find.text('feedback@verstro.com'));
    await tester.tap(find.text('feedback@verstro.com'));
    await tester.pump();

    expect(launched, [
      'https://t.me/verstro_chat',
      'mailto:feedback@verstro.com',
    ]);
  });
}
