// 升级相关本地偏好. 目前只有"忽略此版本"(仅 optional/silent 允许).

import 'package:shared_preferences/shared_preferences.dart';

class UpdatePrefs {
  static const _kIgnoredVersion = 'verstro_update_ignored_version';

  /// 用户"忽略此版本"记录的版本号(null = 未忽略任何).
  static Future<String?> getIgnoredVersion() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kIgnoredVersion);
  }

  static Future<void> setIgnoredVersion(String version) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kIgnoredVersion, version);
  }

  static Future<void> clearIgnoredVersion() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kIgnoredVersion);
  }
}
