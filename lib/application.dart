import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/manager/hotkey_manager.dart';
import 'package:fl_clash/manager/manager.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/providers/database.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/verstro/profile_sync.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:fl_clash/verstro/providers/orders_provider.dart';
import 'package:fl_clash/verstro/update/update_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller.dart';
import 'pages/pages.dart';

class Application extends ConsumerStatefulWidget {
  const Application({super.key});

  @override
  ConsumerState<Application> createState() => ApplicationState();
}

class ApplicationState extends ConsumerState<Application> {
  Timer? _autoUpdateProfilesTaskTimer;
  bool _preHasVpn = false;

  final _pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: commonSharedXPageTransitions,
      TargetPlatform.windows: commonSharedXPageTransitions,
      TargetPlatform.linux: commonSharedXPageTransitions,
      TargetPlatform.macOS: commonSharedXPageTransitions,
    },
  );

  ColorScheme _getAppColorScheme({
    required Brightness brightness,
    int? primaryColor,
  }) {
    return ref.read(genColorSchemeProvider(brightness));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final currentContext = globalState.navigatorKey.currentContext;
      if (currentContext != null) {
        await appController.attach(currentContext, ref);
      } else {
        exit(0);
      }
      _autoUpdateProfilesTask();
      appController.initLink();
      app?.initShortcuts();
      // Verstro 集成: 此 widget 只在 VerstroGate 判定有效订阅时 mount,
      // 这里自动 import 订阅 URL 到 FlClash profile 系统.
      await _verstroAutoIntegrate();
      // Verstro 升级检查: 后台、非阻塞、fail-open. 拉 R2 manifest 比对版本, 有更新
      // 按类型弹窗(已忽略的 optional/silent 版本不打扰). 见 lib/verstro/update/.
      final updateCtx = globalState.navigatorKey.currentContext;
      if (updateCtx != null && updateCtx.mounted) {
        unawaited(runUpdateCheck(updateCtx, isUser: false));
      }
    });
  }

  /// 把 Verstro backend 给的订阅 URL 自动 import 到 FlClash profile 系统.
  /// 阶段 2.3.6. 失败不阻塞 (用户手动 import 仍可走).
  ///
  /// 阶段 2.4 默认配置硬化 (TUN 默认开 + mode=global) 已**暂时下线**, 原因:
  /// - 开 TUN 触发 controller._requestAdmin → system.authorizeCore (osascript
  ///   提权 chmod +s core 二进制), macOS 创建 utun 接口必须 root.
  /// - 当前 release build 是 ad-hoc 签名, 无持久 helper (SMJobBless/Developer
  ///   ID); 且每次 flutter build 重生成 core 二进制会冲掉 setuid 位 → 反复弹
  ///   osascript 密码框, 严重打断开发迭代.
  /// - 提权时机也不对: 应在用户主动点"连接"时, 而非 app 启动时.
  /// 阶段 2.6 真签名 + Network Extension / 持久 root helper 落地后再恢复
  /// TUN 默认开 (届时提权一次永久生效). 见 docs/roadmap.md 阶段 2.6.
  // verstro 托管订阅 profile 的 id (存 SharedPreferences). 订阅 URL 变化(原生↔v2 / token 轮换)
  // 时据此替换该 profile 而非新增, 并清理重复. 见 docs/security/client-credential-security.md (T3.2).
  static const _kVerstroProfileIdKey = 'verstro_managed_profile_id';

  Future<void> _verstroAutoIntegrate() async {
    try {
      final sub = await ref.read(subscriptionProvider.future);
      if (!sub.hasSubscription ||
          sub.isExpired ||
          sub.subscriptionUrl == null ||
          sub.subscriptionUrl!.isEmpty) {
        return;
      }
      final url = sub.subscriptionUrl!;
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final managedId = prefs.getInt(_kVerstroProfileIdKey);
      final profiles = ref.read(profilesProvider);

      // 纯决策: import / replace(同 id 换 url 重拉) / skip, 以及要删的多余 profile
      final plan = planVerstroProfile(
        managedId,
        [for (final p in profiles) (id: p.id, url: p.url)],
        url,
      );

      // 清理重复的多余 profile (修开 flag 时 URL 变导致的重复导入)
      for (final id in plan.deleteIds) {
        await appController.deleteProfile(id);
      }

      if (plan.action == VerstroProfileAction.import) {
        await appController.addProfileFormURL(url);
        final after = ref.read(profilesProvider);
        final idx = after.indexWhere((p) => p.url == url);
        if (idx != -1) {
          await prefs.setInt(_kVerstroProfileIdKey, after[idx].id);
        }
      } else if (plan.action == VerstroProfileAction.replace) {
        final ki = profiles.indexWhere((p) => p.id == plan.keepId);
        if (ki != -1) {
          // copyWith 换 url + updateProfile 内部 .update() 重拉内容 + 按 id 替换 (不新增)
          await appController.updateProfile(profiles[ki].copyWith(url: url));
          await prefs.setInt(_kVerstroProfileIdKey, profiles[ki].id);
        }
      } else {
        // skip: url 未变, 仅记牢 id (兼容旧版没存 id)
        if (plan.keepId != null) {
          await prefs.setInt(_kVerstroProfileIdKey, plan.keepId!);
        }
      }
    } catch (e) {
      // 失败不阻塞 FlClash 主流程
      debugPrint('verstroAutoIntegrate failed: $e');
    }
  }

  void _autoUpdateProfilesTask() {
    _autoUpdateProfilesTaskTimer = Timer(const Duration(minutes: 20), () async {
      await appController.autoUpdateProfiles();
      _autoUpdateProfilesTask();
    });
  }

  Widget _buildPlatformState({required Widget child}) {
    if (system.isDesktop) {
      return WindowManager(
        child: TrayManager(
          child: HotKeyManager(child: ProxyManager(child: child)),
        ),
      );
    }
    return AndroidManager(child: TileManager(child: child));
  }

  Widget _buildState({required Widget child}) {
    return AppStateManager(
      child: CoreManager(
        child: ConnectivityManager(
          onConnectivityChanged: (results) async {
            commonPrint.log('connectivityChanged ${results.toString()}');
            appController.updateLocalIp();
            final hasVpn = results.contains(ConnectivityResult.vpn);
            if (_preHasVpn == hasVpn) {
              appController.addCheckIp();
            }
            _preHasVpn = hasVpn;
          },
          child: child,
        ),
      ),
    );
  }

  Widget _buildPlatformApp({required Widget child}) {
    if (system.isDesktop) {
      return WindowHeaderContainer(child: child);
    }
    return VpnManager(child: child);
  }

  Widget _buildApp({required Widget child}) {
    return StatusManager(child: ThemeManager(child: child));
  }

  @override
  Widget build(context) {
    return Consumer(
      builder: (_, ref, child) {
        final locale = ref.watch(
          appSettingProvider.select((state) => state.locale),
        );
        final themeProps = ref.watch(themeSettingProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: globalState.navigatorKey,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          builder: (_, child) {
            return AppEnvManager(
              child: _buildApp(
                child: _buildPlatformState(
                  child: _buildState(child: _buildPlatformApp(child: child!)),
                ),
              ),
            );
          },
          scrollBehavior: BaseScrollBehavior(),
          title: appDisplayName,
          locale: utils.getLocaleForString(locale),
          supportedLocales: AppLocalizations.delegate.supportedLocales,
          themeMode: themeProps.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            pageTransitionsTheme: _pageTransitionsTheme,
            colorScheme: _getAppColorScheme(
              brightness: Brightness.light,
              primaryColor: themeProps.primaryColor,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            pageTransitionsTheme: _pageTransitionsTheme,
            colorScheme: _getAppColorScheme(
              brightness: Brightness.dark,
              primaryColor: themeProps.primaryColor,
            ).toPureBlack(themeProps.pureBlack),
          ),
          home: child!,
        );
      },
      child: const HomePage(),
    );
  }

  @override
  Future<void> dispose() async {
    linkManager.destroy();
    _autoUpdateProfilesTaskTimer?.cancel();
    await coreController.destroy();
    await appController.handleExit();
    super.dispose();
  }
}
