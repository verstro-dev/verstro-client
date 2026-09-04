import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/theme.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/database.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('已连接时工具栏按钮等大且帮助入口位于最右侧', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coreStatusProvider.overrideWithValue(CoreStatus.connected),
          profilesProvider.overrideWithValue(const []),
          dashboardStateProvider.overrideWithValue(
            const DashboardState(dashboardWidgets: [], contentWidth: 1120),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.delegate.supportedLocales,
          home: Builder(
            builder: (context) {
              globalState.measure = Measure.of(context, 1);
              globalState.theme = CommonTheme.of(context, 1);
              return const DashboardView();
            },
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    final connection = find.byKey(const ValueKey('dashboard-connection'));
    final edit = find.byKey(const ValueKey(false));
    final help = find.byKey(const ValueKey('dashboard-help'));

    expect(connection, findsOneWidget);
    expect(edit, findsOneWidget);
    expect(help, findsOneWidget);

    const expectedButtonSize = Size.square(48);
    expect(tester.getSize(connection), expectedButtonSize);
    expect(tester.getSize(edit), expectedButtonSize);
    expect(tester.getSize(help), expectedButtonSize);

    expect(
      tester.getCenter(connection).dx,
      lessThan(tester.getCenter(edit).dx),
    );
    expect(tester.getCenter(edit).dx, lessThan(tester.getCenter(help).dx));

    for (final icon in [
      find.byIcon(Icons.check),
      find.byIcon(Icons.edit),
      find.byIcon(Icons.help_outline),
    ]) {
      expect(IconTheme.of(tester.element(icon)).size, 24);
    }
  });
}
