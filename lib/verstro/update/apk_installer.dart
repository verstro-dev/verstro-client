// Android 应用内升级: 选 ABI 产物 → 下载 → sha256 校验 → 调系统安装器.
//
// 仅 Android 用(UpdateService.supportsInAppInstall gate). 其余平台走"提示+跳转下载页".
// 系统安装器由原生 UpdatePlugin.installApk 拉起(需 REQUEST_INSTALL_PACKAGES + FileProvider),
// Dart 侧不真正"安装", 只负责下到本地 + 校验完整性 + 把路径交给原生.

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fl_clash/common/common.dart'; // packageName(= 'com.follow.clash')
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'update_manifest.dart';

/// 升级包下载 / 校验 / 安装失败.
class ApkInstallException implements Exception {
  final String message;
  ApkInstallException(this.message);
  @override
  String toString() => 'ApkInstallException: $message';
}

class ApkInstaller {
  // Kotlin 侧须用相同字面量 'com.follow.clash/update' 注册(见 UpdatePlugin.kt).
  static const MethodChannel _channel = MethodChannel('$packageName/update');

  final Dio _dio;
  ApkInstaller({Dio? dio}) : _dio = dio ?? _buildDio();

  static Dio _buildDio() {
    final dio = Dio();
    // 下载升级包也强制直连, 绕过 VPN proxy(同 update_service 理由).
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (_) => 'DIRECT';
        return client;
      },
    );
    return dio;
  }

  /// 设备 ABI 优先级(Build.SUPPORTED_ABIS 顺序). 用于从 manifest 选包. 失败兜底 arm64-v8a.
  Future<List<String>> deviceAbis() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      final abis = info.supportedAbis;
      if (abis.isNotEmpty) return abis;
    } catch (_) {}
    return const ['arm64-v8a'];
  }

  /// 选当前设备应装的产物. 无匹配返回 null.
  Future<UpdateArtifact?> resolveArtifact(UpdateRelease release) async {
    final abis = await deviceAbis();
    return release.pickArtifact(abis);
  }

  /// 下载 + sha256 校验 + 调起系统安装器. onProgress: 0..1.
  /// 校验不通过会删文件并抛 ApkInstallException(防投毒/损坏包被安装).
  Future<void> downloadAndInstall(
    UpdateArtifact artifact, {
    void Function(double progress)? onProgress,
  }) async {
    final dir = await getTemporaryDirectory();
    final shaTag = (artifact.sha256 != null && artifact.sha256!.length >= 8)
        ? artifact.sha256!.substring(0, 8)
        : 'nohash';
    final savePath = '${dir.path}/verstro-update-$shaTag.apk';

    // 下载
    try {
      await _dio.download(
        artifact.url,
        savePath,
        onReceiveProgress: (recv, total) {
          if (total > 0 && onProgress != null) onProgress(recv / total);
        },
      );
    } catch (e) {
      await _deleteQuietly(savePath);
      throw ApkInstallException('下载失败: $e');
    }

    // sha256 完整性校验(manifest 提供 sha256 时必校验)
    if (artifact.sha256 != null && artifact.sha256!.isNotEmpty) {
      final actual = await _sha256OfFile(savePath);
      if (actual.toLowerCase() != artifact.sha256!.toLowerCase()) {
        await _deleteQuietly(savePath);
        throw ApkInstallException('完整性校验失败(sha256 不匹配), 已丢弃下载');
      }
    }

    // 调原生安装器(系统弹安装确认界面; 若无"安装未知应用"权限, 原生会先引导去开)
    try {
      await _channel.invokeMethod('installApk', {'path': savePath});
    } on PlatformException catch (e) {
      throw ApkInstallException('调起安装失败: ${e.message ?? e.code}');
    }
  }

  Future<String> _sha256OfFile(String path) async {
    // 流式计算, 避免 50MB APK 全量进内存
    final digest = await sha256.bind(File(path).openRead()).first;
    return digest.toString();
  }

  Future<void> _deleteQuietly(String path) async {
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}
