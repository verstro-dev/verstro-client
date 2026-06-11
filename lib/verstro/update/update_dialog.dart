// 升级对话框. 按升级类型决定可关闭性与按钮:
//   force        → 不可关闭, [退出应用][立即更新/前往下载]
//   recommended  → [稍后][立即更新/前往下载]
//   optional/silent → [忽略此版本][稍后][立即更新/前往下载]
//
// Android(supportsInAppInstall): "立即更新" = 应用内下载(进度条)+ sha256 + 调系统安装器.
// 桌面/iOS: "前往下载" = url_launcher 打开下载页(应用内无法自动安装).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'apk_installer.dart';
import 'update_manifest.dart';
import 'update_prefs.dart';
import 'update_service.dart';

/// 弹出升级对话框. force 时屏蔽返回键与点击遮罩关闭.
Future<void> showUpdateDialog(BuildContext context, UpdateDecision decision) {
  return showDialog<void>(
    context: context,
    barrierDismissible: !decision.isForce,
    builder: (_) => PopScope(
      canPop: !decision.isForce,
      child: _UpdateDialog(decision: decision),
    ),
  );
}

class _UpdateDialog extends StatefulWidget {
  final UpdateDecision decision;
  const _UpdateDialog({required this.decision});

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  bool _downloading = false;
  double _progress = 0;
  String? _error;

  UpdateDecision get d => widget.decision;
  UpdateRelease get release => d.manifest!.latest;

  Future<void> _onPrimary() async {
    if (UpdateService.supportsInAppInstall) {
      await _androidInstall();
    } else {
      await _openDownloadPage();
    }
  }

  /// 桌面/iOS: 打开下载页(应用内不安装).
  Future<void> _openDownloadPage() async {
    final url = release.downloadPage ?? 'https://verstro.com';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    // 非强制: 跳转后关弹窗; 强制: 保持(用户须自行下载安装新版)
    if (!d.isForce && mounted) Navigator.of(context).pop();
  }

  /// Android: 应用内下载 + 校验 + 调安装器.
  Future<void> _androidInstall() async {
    setState(() {
      _downloading = true;
      _error = null;
      _progress = 0;
    });
    try {
      final installer = ApkInstaller();
      final artifact = await installer.resolveArtifact(release);
      if (artifact == null) {
        throw ApkInstallException('未找到适配当前设备的安装包');
      }
      await installer.downloadAndInstall(
        artifact,
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      // 系统安装器已拉起(用户在系统 UI 完成确认); 复位下载态, 不主动关弹窗
      // (用户可能在系统侧取消安装, 保留弹窗便于重试).
      if (mounted) setState(() => _downloading = false);
    } on ApkInstallException catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _error = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _error = '更新失败: $e';
        });
      }
    }
  }

  Future<void> _onIgnore() async {
    final v = d.latestVersion;
    if (v != null) await UpdatePrefs.setIgnoredVersion(v);
    if (mounted) Navigator.of(context).pop();
  }

  void _onLater() => Navigator.of(context).pop();

  void _onExit() => exit(0);

  List<Widget> _buildActions() {
    if (_downloading) {
      return [
        TextButton(onPressed: null, child: Text('下载中 ${(_progress * 100).toInt()}%')),
      ];
    }
    final primaryLabel =
        UpdateService.supportsInAppInstall ? '立即更新' : '前往下载';
    final primary = FilledButton(onPressed: _onPrimary, child: Text(primaryLabel));

    switch (d.type) {
      case UpgradeType.force:
        return [
          TextButton(onPressed: _onExit, child: const Text('退出应用')),
          primary,
        ];
      case UpgradeType.recommended:
        return [
          TextButton(onPressed: _onLater, child: const Text('稍后')),
          primary,
        ];
      case UpgradeType.optional:
      case UpgradeType.silent:
        return [
          TextButton(onPressed: _onIgnore, child: const Text('忽略此版本')),
          TextButton(onPressed: _onLater, child: const Text('稍后')),
          primary,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final notes = release.notes;
    return AlertDialog(
      title: Text(d.isForce ? '需要更新到 v${release.version}' : '发现新版本 v${release.version}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (d.isForce)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '当前版本已不再受支持, 请更新后继续使用.',
                style: TextStyle(color: scheme.error),
              ),
            ),
          if (notes != null && notes.trim().isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(notes, style: const TextStyle(height: 1.5)),
              ),
            ),
          if (_downloading) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progress > 0 ? _progress : null),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: scheme.error, fontSize: 13)),
          ],
        ],
      ),
      actions: _buildActions(),
    );
  }
}
