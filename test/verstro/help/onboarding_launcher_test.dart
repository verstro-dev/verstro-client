import 'dart:async';

import 'package:fl_clash/verstro/help/onboarding/onboarding_launcher.dart';
import 'package:fl_clash/verstro/help/onboarding/onboarding_state.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakePersistence implements VerstroOnboardingPersistence {
  _FakePersistence({this.completed = false, this.readError = false});

  bool completed;
  final bool readError;

  @override
  Future<bool> isCompleted() async {
    if (readError) throw StateError('read failed');
    return completed;
  }

  @override
  Future<void> markCompleted() async {
    completed = true;
  }
}

class _LaunchProbe {
  Future<bool>? future;
}

class _LauncherHarness extends ConsumerWidget {
  const _LauncherHarness({required this.onLaunch});

  final void Function(BuildContext context, WidgetRef ref) onLaunch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            key: const Key('launch'),
            onPressed: () => onLaunch(context, ref),
            child: const Text('launch'),
          ),
        ),
      ),
    );
  }
}

Future<SharedPreferences> _emptyPreferences() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

Future<_LaunchProbe> _pumpLauncher(
  WidgetTester tester, {
  required Future<SharedPreferences> Function() loadPreferences,
  required Future<bool> Function(BuildContext context, WidgetRef ref) launch,
}) async {
  final probe = _LaunchProbe();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => loadPreferences()),
      ],
      child: _LauncherHarness(
        onLaunch: (context, ref) {
          probe.future = launch(context, ref);
        },
      ),
    ),
  );
  await tester.tap(find.byKey(const Key('launch')));
  await tester.pump();
  return probe;
}

void main() {
  testWidgets('已完成时不展示也不导航', (tester) async {
    final prefs = await _emptyPreferences();
    final persistence = _FakePersistence(completed: true);
    var presenterCalls = 0;
    var helpCalls = 0;

    final probe = await _pumpLauncher(
      tester,
      loadPreferences: () async => prefs,
      launch: (context, ref) => maybeLaunchVerstroOnboarding(
        context,
        ref,
        persistenceFactory: (_) => persistence,
        presenter: () async {
          presenterCalls++;
          return VerstroOnboardingResult.completed;
        },
        helpOpener: (_) async => helpCalls++,
      ),
    );

    expect(await probe.future!, isFalse);
    expect(presenterCalls, 0);
    expect(helpCalls, 0);
  });

  for (final result in [
    VerstroOnboardingResult.skipped,
    VerstroOnboardingResult.completed,
  ]) {
    testWidgets('$result 不导航到帮助中心', (tester) async {
      final prefs = await _emptyPreferences();
      final persistence = _FakePersistence();
      var helpCalls = 0;

      final probe = await _pumpLauncher(
        tester,
        loadPreferences: () async => prefs,
        launch: (context, ref) => maybeLaunchVerstroOnboarding(
          context,
          ref,
          persistenceFactory: (_) => persistence,
          presenter: () async => result,
          helpOpener: (_) async => helpCalls++,
        ),
      );

      expect(await probe.future!, isTrue);
      expect(helpCalls, 0);
    });
  }

  testWidgets('openHelp 在 presenter 返回后才导航', (tester) async {
    final prefs = await _emptyPreferences();
    final persistence = _FakePersistence();
    final presenterResult = Completer<VerstroOnboardingResult?>();
    final events = <String>[];

    final probe = await _pumpLauncher(
      tester,
      loadPreferences: () async => prefs,
      launch: (context, ref) => maybeLaunchVerstroOnboarding(
        context,
        ref,
        persistenceFactory: (_) => persistence,
        presenter: () async {
          events.add('presenter-start');
          final result = await presenterResult.future;
          events.add('presenter-return');
          return result;
        },
        helpOpener: (_) async => events.add('help'),
      ),
    );

    expect(events, ['presenter-start']);
    presenterResult.complete(VerstroOnboardingResult.openHelp);
    expect(await probe.future!, isTrue);
    expect(events, ['presenter-start', 'presenter-return', 'help']);
  });

  testWidgets('provider 异常 fail-open', (tester) async {
    var presenterCalls = 0;
    final probe = await _pumpLauncher(
      tester,
      loadPreferences: () =>
          Future<SharedPreferences>.error(StateError('provider failed')),
      launch: (context, ref) => maybeLaunchVerstroOnboarding(
        context,
        ref,
        presenter: () async {
          presenterCalls++;
          return VerstroOnboardingResult.completed;
        },
      ),
    );

    expect(await probe.future!, isFalse);
    expect(presenterCalls, 0);
  });

  testWidgets('persistence 异常 fail-open', (tester) async {
    final prefs = await _emptyPreferences();
    var presenterCalls = 0;
    final probe = await _pumpLauncher(
      tester,
      loadPreferences: () async => prefs,
      launch: (context, ref) => maybeLaunchVerstroOnboarding(
        context,
        ref,
        persistenceFactory: (_) => _FakePersistence(readError: true),
        presenter: () async {
          presenterCalls++;
          return VerstroOnboardingResult.completed;
        },
      ),
    );

    expect(await probe.future!, isFalse);
    expect(presenterCalls, 0);
  });

  testWidgets('presenter 异常 fail-open', (tester) async {
    final prefs = await _emptyPreferences();
    final probe = await _pumpLauncher(
      tester,
      loadPreferences: () async => prefs,
      launch: (context, ref) => maybeLaunchVerstroOnboarding(
        context,
        ref,
        persistenceFactory: (_) => _FakePersistence(),
        presenter: () async => throw StateError('presenter failed'),
      ),
    );

    expect(await probe.future!, isFalse);
  });

  testWidgets('help opener 异常 fail-open', (tester) async {
    final prefs = await _emptyPreferences();
    final probe = await _pumpLauncher(
      tester,
      loadPreferences: () async => prefs,
      launch: (context, ref) => maybeLaunchVerstroOnboarding(
        context,
        ref,
        persistenceFactory: (_) => _FakePersistence(),
        presenter: () async => VerstroOnboardingResult.openHelp,
        helpOpener: (_) async => throw StateError('help failed'),
      ),
    );

    expect(await probe.future!, isFalse);
  });

  testWidgets('presenter 返回前 context 卸载则不导航', (tester) async {
    final prefs = await _emptyPreferences();
    final presenterStarted = Completer<void>();
    final presenterResult = Completer<VerstroOnboardingResult?>();
    var helpCalls = 0;
    final probe = await _pumpLauncher(
      tester,
      loadPreferences: () async => prefs,
      launch: (context, ref) => maybeLaunchVerstroOnboarding(
        context,
        ref,
        persistenceFactory: (_) => _FakePersistence(),
        presenter: () async {
          presenterStarted.complete();
          return presenterResult.future;
        },
        helpOpener: (_) async => helpCalls++,
      ),
    );

    await presenterStarted.future;
    await tester.pumpWidget(const SizedBox.shrink());
    presenterResult.complete(VerstroOnboardingResult.openHelp);

    expect(await probe.future!, isTrue);
    expect(helpCalls, 0);
  });
}
