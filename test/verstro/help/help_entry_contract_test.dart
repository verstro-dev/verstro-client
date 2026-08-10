import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('仪表盘和设置页都打开同一个原生帮助中心', () {
    final dashboard = File(
      'lib/views/dashboard/dashboard.dart',
    ).readAsStringSync();
    final settings = File('lib/views/settings.dart').readAsStringSync();
    expect(dashboard, contains('openVerstroHelpCenter(context)'));
    expect(dashboard, contains('Icons.help_outline'));
    expect(settings, contains('openVerstroHelpCenter(context)'));
    expect(settings, contains('Icons.help_outline'));
  });

  test('Application 在托管订阅同步后才启动新手引导', () {
    final source = File('lib/application.dart').readAsStringSync();
    final integrate = source.indexOf('await _verstroAutoIntegrate();');
    final launch = source.indexOf(
      'await maybeLaunchVerstroOnboarding(updateCtx, ref);',
    );
    final update = source.indexOf(
      'unawaited(runUpdateCheck(updateCtx, isUser: false));',
    );
    expect(integrate, greaterThanOrEqualTo(0));
    expect(launch, greaterThan(integrate));
    expect(update, greaterThan(launch));
  });
}
