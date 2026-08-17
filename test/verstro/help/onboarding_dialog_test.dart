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
  bool disableAnimations = false,
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
      builder: textScaler == null && !disableAnimations
          ? null
          : (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: textScaler,
                disableAnimations: disableAnimations,
              ),
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

bool _hasPrimaryFocus(Finder control) {
  final controlElement = control.evaluate().single;
  final focusedContext = FocusManager.instance.primaryFocus?.context;
  if (focusedContext == null) return false;
  if (identical(focusedContext, controlElement)) return true;

  var isDescendant = false;
  focusedContext.visitAncestorElements((element) {
    if (identical(element, controlElement)) {
      isDescendant = true;
      return false;
    }
    return true;
  });
  return isDescendant;
}

Future<void> _focusControl(WidgetTester tester, Finder control) async {
  for (var attempt = 0; attempt < 20 && !_hasPrimaryFocus(control); attempt++) {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
  }
  expect(
    _hasPrimaryFocus(control),
    isTrue,
    reason: 'Tab 焦点应进入目标控件，而不是依赖固定的 Tab 次数',
  );
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

  testWidgets('系统减少动态效果开启时下一步和上一步立即跳页', (tester) async {
    await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
      disableAnimations: true,
    );
    final controller = tester
        .widget<PageView>(find.byType(PageView))
        .controller!;

    expect(controller.page, 0);
    await tester.tap(find.text('下一步'));
    await tester.pump();
    expect(controller.page, 1);

    await tester.tap(find.text('上一步'));
    await tester.pump();
    expect(controller.page, 0);
  });

  testWidgets('普通状态仍使用 180 毫秒分页动画', (tester) async {
    await _pumpDialog(tester, audience: VerstroHelpAudience.desktop);
    final controller = tester
        .widget<PageView>(find.byType(PageView))
        .controller!;

    await tester.tap(find.text('下一步'));
    await tester.pump();
    expect(controller.page, 0);
    await tester.pump(const Duration(milliseconds: 179));
    expect(controller.page, greaterThan(0));
    expect(controller.page, lessThan(1));
    await tester.pump(const Duration(milliseconds: 1));
    expect(controller.page, 1);
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

  testWidgets('Tab 聚焦跳过后 Enter 激活按钮而不是前进', (tester) async {
    final state = await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
    );

    await _focusControl(tester, find.widgetWithText(TextButton, '跳过'));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(state.settled, isTrue);
    expect(state.result, VerstroOnboardingResult.skipped);
  });

  testWidgets('Tab 聚焦跳过后 Space 激活按钮', (tester) async {
    final state = await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
    );

    await _focusControl(tester, find.widgetWithText(TextButton, '跳过'));
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(state.settled, isTrue);
    expect(state.result, VerstroOnboardingResult.skipped);
  });

  testWidgets('Tab 聚焦上一步后 Enter 返回上一页而不是前进', (tester) async {
    final state = await _pumpDialog(
      tester,
      audience: VerstroHelpAudience.desktop,
    );
    await _tapNext(tester);
    final backButton = find.widgetWithText(TextButton, '上一步');

    await _focusControl(tester, backButton);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text('连接'), findsOneWidget);
    expect(state.settled, isFalse);
    expect(state.result, isNull);
  });

  for (final scenario
      in <
        ({
          Type buttonType,
          String buttonLabel,
          VerstroOnboardingResult expectedResult,
        })
      >[
        (
          buttonType: TextButton,
          buttonLabel: '打开帮助中心',
          expectedResult: VerstroOnboardingResult.openHelp,
        ),
        (
          buttonType: FilledButton,
          buttonLabel: '完成',
          expectedResult: VerstroOnboardingResult.completed,
        ),
      ]) {
    testWidgets('Tab 聚焦${scenario.buttonLabel}后 Enter 激活对应按钮', (tester) async {
      final state = await _pumpDialog(
        tester,
        audience: VerstroHelpAudience.desktop,
      );
      await _tapNext(tester, 4);
      final button = find.widgetWithText(
        scenario.buttonType,
        scenario.buttonLabel,
      );

      await _focusControl(tester, button);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(state.settled, isTrue);
      expect(state.result, scenario.expectedResult);
    });
  }

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
