import 'package:fl_clash/verstro/help/onboarding/onboarding_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePersistence implements VerstroOnboardingPersistence {
  _FakePersistence({
    this.completed = false,
    this.readError = false,
    this.writeError = false,
  });

  bool completed;
  final bool readError;
  final bool writeError;
  int markCalls = 0;

  @override
  Future<bool> isCompleted() async {
    if (readError) throw StateError('read failed');
    return completed;
  }

  @override
  Future<void> markCompleted() async {
    markCalls++;
    if (writeError) throw StateError('write failed');
    completed = true;
  }
}

void main() {
  test('使用固定的一次性完成键', () {
    expect(kVerstroOnboardingCompletedKey, 'verstro_onboarding_completed_v1');
  });

  test('已完成时不调用 presenter', () async {
    final persistence = _FakePersistence(completed: true);
    var calls = 0;

    final shown = await launchVerstroOnboardingIfNeeded(
      persistence: persistence,
      presenter: () async {
        calls++;
        return VerstroOnboardingResult.completed;
      },
    );

    expect(shown, isFalse);
    expect(calls, 0);
  });

  for (final result in VerstroOnboardingResult.values) {
    test('$result 会标记已完成', () async {
      final persistence = _FakePersistence();

      final shown = await launchVerstroOnboardingIfNeeded(
        persistence: persistence,
        presenter: () async => result,
      );

      expect(shown, isTrue);
      expect(persistence.markCalls, 1);
    });
  }

  test('presenter 返回 null 代表中途退出，不标记完成', () async {
    final persistence = _FakePersistence();

    final shown = await launchVerstroOnboardingIfNeeded(
      persistence: persistence,
      presenter: () async => null,
    );

    expect(shown, isTrue);
    expect(persistence.markCalls, 0);
  });

  test('读取失败 fail-open 且不调用 presenter', () async {
    final persistence = _FakePersistence(readError: true);
    var calls = 0;

    final shown = await launchVerstroOnboardingIfNeeded(
      persistence: persistence,
      presenter: () async {
        calls++;
        return VerstroOnboardingResult.completed;
      },
    );

    expect(shown, isFalse);
    expect(calls, 0);
  });

  test('写入失败不向上抛出，也不阻塞关闭', () async {
    final persistence = _FakePersistence(writeError: true);

    final shown = await launchVerstroOnboardingIfNeeded(
      persistence: persistence,
      presenter: () async => VerstroOnboardingResult.skipped,
    );

    expect(shown, isTrue);
    expect(persistence.markCalls, 1);
  });
}
