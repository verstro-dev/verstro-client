const kVerstroAutoRunOffV1 = 'verstro_autorun_off_v1';

class AutoRunOffPlan {
  const AutoRunOffPlan({
    required this.autoRun,
    required this.writeMigrationMark,
  });

  final bool autoRun;
  final bool writeMigrationMark;
}

class LogoutSessionPlan {
  const LogoutSessionPlan({
    required this.stopProxy,
    required this.stopCore,
    required this.exitApp,
    required this.showWindow,
  });

  final bool stopProxy;
  final bool stopCore;
  final bool exitApp;
  final bool showWindow;
}

class StartupProxyHealPlan {
  const StartupProxyHealPlan({required this.stopProxy});

  final bool stopProxy;
}

/// 一次性关掉存量用户的启动自动连接；已写过标记后不再覆盖用户后来打开的开关。
AutoRunOffPlan planAutoRunOffOnce({
  required bool alreadyMigrated,
  required bool currentAutoRun,
}) {
  if (alreadyMigrated) {
    return AutoRunOffPlan(
      autoRun: currentAutoRun,
      writeMigrationMark: false,
    );
  }
  return const AutoRunOffPlan(autoRun: false, writeMigrationMark: true);
}

/// 退出登录先拆代理/隧道，再清登录态；进程必须留下并回到登录页。
LogoutSessionPlan planLogoutSession({required bool isStarted}) {
  return LogoutSessionPlan(
    stopProxy: true,
    stopCore: isStarted,
    exitApp: false,
    showWindow: true,
  );
}

/// 强杀后系统代理可能残留；下次启动无论 autoRun 如何都先清。
StartupProxyHealPlan planStartupProxyHeal({required bool autoRun}) {
  return const StartupProxyHealPlan(stopProxy: true);
}
