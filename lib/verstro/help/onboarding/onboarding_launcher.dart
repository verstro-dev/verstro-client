import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/verstro/help/help_center_page.dart';
import 'package:fl_clash/verstro/help/help_content.dart';
import 'package:fl_clash/verstro/help/onboarding/onboarding_dialog.dart';
import 'package:fl_clash/verstro/help/onboarding/onboarding_state.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef VerstroOnboardingPersistenceFactory =
    VerstroOnboardingPersistence Function(SharedPreferences preferences);
typedef VerstroHelpOpener = Future<void> Function(BuildContext context);

Future<bool> maybeLaunchVerstroOnboarding(
  BuildContext context,
  WidgetRef ref, {
  VerstroOnboardingPersistenceFactory? persistenceFactory,
  VerstroOnboardingPresenter? presenter,
  VerstroHelpOpener? helpOpener,
}) async {
  try {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    if (!context.mounted) return false;

    final persistence =
        persistenceFactory?.call(prefs) ??
        SharedPreferencesVerstroOnboardingPersistence(prefs);
    VerstroOnboardingResult? result;
    final launched = await launchVerstroOnboardingIfNeeded(
      persistence: persistence,
      presenter: () async {
        result =
            await (presenter?.call() ??
                showVerstroOnboarding(
                  context,
                  audience: system.isDesktop
                      ? VerstroHelpAudience.desktop
                      : VerstroHelpAudience.mobile,
                ));
        return result;
      },
    );

    if (result == VerstroOnboardingResult.openHelp && context.mounted) {
      await (helpOpener ?? openVerstroHelpCenter)(context);
    }
    return launched;
  } catch (_) {
    // 引导及帮助中心都不能阻塞应用启动。
    return false;
  }
}
