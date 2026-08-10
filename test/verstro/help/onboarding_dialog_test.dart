import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/help/help_content.dart';
import 'package:fl_clash/verstro/help/onboarding/onboarding_dialog.dart';
import 'package:fl_clash/verstro/help/onboarding/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _DialogHarness extends StatefulWidget {
  const _DialogHarness({required this.audience});

  final VerstroHelpAudience audience;

  @override
  State<_DialogHarness> createState() => _DialogHarnessState();
}

class _DialogHarnessState extends State<_DialogHarness> {
  VerstroOnboardingResult? result;
  bool settled = false;

  Future<void> _show() async {
    result = await showVerstroOnboarding(context, audience: widget.audience);
    settled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(onPressed: _show, child: const Text('show')),
      ),
    );
  }
}

Future<_DialogHarnessState> _pumpDialog(
  WidgetTester tester, {
  required VerstroHelpAudience audience,
  TextScaler? textScaler,
}) async {
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
      builder: textScaler == null
          ? null
          : (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            ),
      home: _DialogHarness(audience: audience),
    ),
  );
  final state = tester.state<_DialogHarnessState>(find.byType(_DialogHarness));
  await tester.tap(find.text('show'));
  await tester.pumpAndSettle();
  return state;
}

Future<void> _tapNext(WidgetTester tester, [int count = 1]) async {
  for (var index = 0; index < count; index++) {
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('桌面五步依次说明连接、出站、系统代理、虚拟网卡和帮助', (tester) async {
    await _pumpDialog(tester, audience: VerstroHelpAudience.desktop);

    expect(find.text('连接'), findsOneWidget);
    expect(find.textContaining('点击主界面连接按钮'), findsOneWidget);
    await _tapNext(tester);
    expect(find.text('出站模式'), findsOneWidget);
    await _tapNext(tester);
    expect(find.text('系统代理'), findsOneWidget);
    await _tapNext(tester);
    expect(find.text('虚拟网卡（TUN）'), findsOneWidget);
    await _tapNext(tester);
    expect(find.text('帮助'), findsOneWidget);
  });

  testWidgets('移动端第三步为系统 VPN，第四步为节点与线路', (tester) async {
    await _pumpDialog(tester, audience: VerstroHelpAudience.mobile);

    await _tapNext(tester, 2);
    expect(find.text('系统 VPN 通道'), findsOneWidget);
    expect(find.text('系统代理'), findsNothing);
    await _tapNext(tester);
    expect(find.text('节点与线路'), findsOneWidget);
  });

  testWidgets('到第五步后可以返回第四步', (tester) async {
    await _pumpDialog(tester, audience: VerstroHelpAudience.desktop);

    await _tapNext(tester, 4);
    expect(find.text('帮助'), findsOneWidget);
    await tester.tap(find.text('上一步'));
    await tester.pumpAndSettle();
    expect(find.text('虚拟网卡（TUN）'), findsOneWidget);
  });

  testWidgets('跳过返回 skipped', (tester) async {
    final state = await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
    );

    await tester.tap(find.text('跳过'));
    await tester.pumpAndSettle();
    expect(state.settled, isTrue);
    expect(state.result, VerstroOnboardingResult.skipped);
  });

  testWidgets('完成返回 completed', (tester) async {
    final state = await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
    );

    await _tapNext(tester, 4);
    await tester.tap(find.text('完成'));
    await tester.pumpAndSettle();
    expect(state.result, VerstroOnboardingResult.completed);
  });

  testWidgets('打开帮助中心返回 openHelp', (tester) async {
    final state = await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
    );

    await _tapNext(tester, 4);
    await tester.tap(find.text('打开帮助中心'));
    await tester.pumpAndSettle();
    expect(state.result, VerstroOnboardingResult.openHelp);
  });

  testWidgets('320 宽且文字放大 1.5 时无布局溢出', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
      textScaler: TextScaler.linear(1.5),
    );
    await _tapNext(tester, 4);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Semantics 公布当前标题和页数', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pumpDialog(tester, audience: VerstroHelpAudience.desktop);

    await _tapNext(tester);

    expect(find.bySemanticsLabel(RegExp(r'2 / 5.*出站模式')), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('方向键、Enter 和 Escape 可控制引导', (tester) async {
    final state = await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('出站模式'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('连接'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('出站模式'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(state.result, VerstroOnboardingResult.skipped);
  });

  testWidgets('系统返回等同跳过', (tester) async {
    final state = await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(state.result, VerstroOnboardingResult.skipped);
  });
}
