// 升级检查协调入口. 关于页(手动)与启动钩子(自动)都调它.
//
// 风格对齐 lib/verstro/providers/orders_provider.dart 的"裸 helper 函数"(不引 Riverpod
// Notifier): 升级检查是一次性事件, 无需常驻 state, 下载进度由 update_dialog 内部管理.

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'update_dialog.dart';
import 'update_prefs.dart';
import 'update_service.dart';

/// 检查更新, 有则弹窗.
///
/// - isUser=true(用户在关于页主动点): 无更新也提示"已是最新", 且无视"忽略此版本".
/// - isUser=false(启动自动检查): 静默(无更新不打扰), 且尊重用户"忽略此版本".
///
/// 全程不抛: 启动调用即便出错也绝不影响 app 使用(fail-open).
Future<void> runUpdateCheck(
  BuildContext context, {
  required bool isUser,
}) async {
  try {
    final info = await PackageInfo.fromPlatform();
    final decision = await UpdateService().check(currentVersion: info.version);

    if (!decision.hasUpdate) {
      if (isUser && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已是最新版本')),
        );
      }
      return;
    }

    // 启动自动检查时: 若该版本可忽略(optional/silent)且用户已忽略 → 跳过.
    // recommended/force 不可忽略, 照常弹.
    if (!isUser && decision.allowIgnore) {
      final ignored = await UpdatePrefs.getIgnoredVersion();
      if (ignored == decision.latestVersion) return;
    }

    if (!context.mounted) return;
    await showUpdateDialog(context, decision);
  } catch (_) {
    // fail-open: 检查更新永不阻断使用. isUser 时静默失败(用户可重试).
  }
}
