import 'package:fl_clash/verstro/application_lifecycle_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('planApplicationFirstFrame', () {
    test('已有 navigator 才 attach', () {
      expect(
        planApplicationFirstFrame(hasNavigator: true),
        ApplicationFirstFrameAction.attach,
      );
    });

    test('首帧没有 navigator 时等待，不要 exit', () {
      expect(
        planApplicationFirstFrame(hasNavigator: false),
        ApplicationFirstFrameAction.wait,
      );
    });
  });

  group('planApplicationDispose', () {
    test('门禁卸载只清理自身与 core，不得走 handleExit', () {
      expect(
        planApplicationDispose(),
        ApplicationDisposeCleanup.selfAndCore,
      );
      expect(
        planApplicationDispose(),
        isNot(ApplicationDisposeCleanup.selfCoreAndExit),
      );
    });
  });
}
