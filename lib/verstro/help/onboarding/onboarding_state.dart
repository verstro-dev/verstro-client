import 'package:shared_preferences/shared_preferences.dart';

const kVerstroOnboardingCompletedKey = 'verstro_onboarding_completed_v1';

enum VerstroOnboardingResult { skipped, completed, openHelp }

abstract interface class VerstroOnboardingPersistence {
  Future<bool> isCompleted();

  Future<void> markCompleted();
}

typedef VerstroOnboardingPresenter =
    Future<VerstroOnboardingResult?> Function();

Future<bool> launchVerstroOnboardingIfNeeded({
  required VerstroOnboardingPersistence persistence,
  required VerstroOnboardingPresenter presenter,
}) async {
  try {
    if (await persistence.isCompleted()) return false;
  } catch (_) {
    return false;
  }

  final result = await presenter();
  if (result == null) return true;

  try {
    await persistence.markCompleted();
  } catch (_) {
    // 完成状态写入失败不应阻塞用户关闭引导或继续使用应用。
  }
  return true;
}

class SharedPreferencesVerstroOnboardingPersistence
    implements VerstroOnboardingPersistence {
  SharedPreferencesVerstroOnboardingPersistence([this._preferences]);

  final SharedPreferences? _preferences;

  Future<SharedPreferences> _getPreferences() async =>
      _preferences ?? await SharedPreferences.getInstance();

  @override
  Future<bool> isCompleted() async =>
      (await _getPreferences()).getBool(kVerstroOnboardingCompletedKey) ??
      false;

  @override
  Future<void> markCompleted() async {
    await (await _getPreferences()).setBool(
      kVerstroOnboardingCompletedKey,
      true,
    );
  }
}
