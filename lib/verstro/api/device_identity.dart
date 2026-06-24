// 设备身份 (T4.2, 见 docs/security/account-device-control.md)
//
// 给每台客户端生成稳定且唯一的 device_id, 上报给 billing /v1/devices/register,
// 配合后端每用户设备数上限 (T4.1) 防一人买多人共用 / 转卖订阅.
//
// device_id 策略: 首次随机生成 16 字节 hex, 持久化到 SharedPreferences, 之后复用.
//   - 稳定: 同一安装内不变 (正确计数设备数).
//   - 唯一: Random.secure() 16 字节碰撞概率可忽略.
//   - 重装会变 (SharedPreferences 清空) — 可接受; 阶段 2.6 与 token 一起迁
//     flutter_secure_storage 后, iOS keychain 跨重装保留可进一步稳定 (见 token_storage.dart).
//
// 不用 uuid 包: 项目未引入, 自生成 hex 即可, 不增依赖.

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdentity {
  static const _kDeviceIdKey = 'verstro_device_id_v1';

  final SharedPreferences _prefs;

  DeviceIdentity(this._prefs);

  /// 取当前 device_id; 不存在则生成并持久化 (fire-and-forget 写, 同步返回新值).
  String getOrCreateDeviceId() {
    final existing = _prefs.getString(_kDeviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = generateDeviceId();
    unawaited(_prefs.setString(_kDeviceIdKey, id));
    return id;
  }

  /// 生成 16 字节随机 device_id, 32 位小写 hex.
  static String generateDeviceId() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// 当前平台名, 与 billing 期望对齐 (ios/android/macos/windows/linux).
  static String platformName() => Platform.operatingSystem;

  /// 设备显示名 (best-effort). 插件不可用 / 平台异常时退回平台名, 绝不抛.
  static Future<String> resolveDeviceName() async {
    try {
      final info = DeviceInfoPlugin();
      if (Platform.isIOS) return (await info.iosInfo).name;
      if (Platform.isAndroid) {
        final a = await info.androidInfo;
        return '${a.brand} ${a.model}'.trim();
      }
      if (Platform.isMacOS) return (await info.macOsInfo).computerName;
      if (Platform.isWindows) return (await info.windowsInfo).computerName;
      if (Platform.isLinux) return (await info.linuxInfo).name;
    } catch (_) {
      // 插件未注册 (如单测) / 平台异常: 退回平台名
    }
    return Platform.operatingSystem;
  }
}
