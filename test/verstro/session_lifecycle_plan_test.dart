import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/verstro/session_lifecycle_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('新安装 autoRun 默认关闭', () {
    expect(const AppSettingProps().autoRun, isFalse);
    expect(AppSettingProps.fromJson({}).autoRun, isFalse);
  });

  group('planAutoRunOffOnce', () {
    test('未迁移时强制关闭自动连接并需要写入标记', () {
      final off = planAutoRunOffOnce(
        alreadyMigrated: false,
        currentAutoRun: true,
      );
      expect(off.autoRun, isFalse);
      expect(off.writeMigrationMark, isTrue);

      final alreadyOff = planAutoRunOffOnce(
        alreadyMigrated: false,
        currentAutoRun: false,
      );
      expect(alreadyOff.autoRun, isFalse);
      expect(alreadyOff.writeMigrationMark, isTrue);
    });

    test('已迁移后保留用户当前值且不再覆盖', () {
      final keptOn = planAutoRunOffOnce(
        alreadyMigrated: true,
        currentAutoRun: true,
      );
      expect(keptOn.autoRun, isTrue);
      expect(keptOn.writeMigrationMark, isFalse);

      final keptOff = planAutoRunOffOnce(
        alreadyMigrated: true,
        currentAutoRun: false,
      );
      expect(keptOff.autoRun, isFalse);
      expect(keptOff.writeMigrationMark, isFalse);
    });
  });

  group('planLogoutSession', () {
    test('已连接时先停核心和系统代理，且绝不退出进程', () {
      final plan = planLogoutSession(isStarted: true);
      expect(plan.stopProxy, isTrue);
      expect(plan.stopCore, isTrue);
      expect(plan.exitApp, isFalse);
      expect(plan.showWindow, isTrue);
    });

    test('未连接也清系统代理，仍不退出进程', () {
      final plan = planLogoutSession(isStarted: false);
      expect(plan.stopProxy, isTrue);
      expect(plan.stopCore, isFalse);
      expect(plan.exitApp, isFalse);
      expect(plan.showWindow, isTrue);
    });
  });

  group('planStartupProxyHeal', () {
    test('启动时无论是否将自动连接都先清系统代理', () {
      expect(planStartupProxyHeal(autoRun: false).stopProxy, isTrue);
      expect(planStartupProxyHeal(autoRun: true).stopProxy, isTrue);
    });
  });
}
