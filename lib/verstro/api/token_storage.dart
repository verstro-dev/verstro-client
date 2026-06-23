// JWT 持久化存储
//
// 阶段 2.3.1: 临时用 SharedPreferences (因为 macOS ad-hoc signed app 拿不到
// keychain-access-groups entitlement, flutter_secure_storage 会抛
// PlatformException(-34018 errSecMissingEntitlement)).
//
// 阶段 2.6 真签 Apple Developer team 后切回 flutter_secure_storage 走系统 keychain:
// - macOS / iOS: Keychain
// - Android: EncryptedSharedPreferences (硬件级密钥)
// - Windows: Credential Manager
// - Linux: libsecret
//
// SharedPreferences 在 macOS 上落地 ~/Library/Containers/<bundle>/Data/Library/Preferences/<bundle>.plist
// 明文存储, 但因为是 user-local sandbox 路径, 同机其他用户 / 其他 app 拿不到, 风险可控.

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _kTokenKey = 'verstro_jwt_v1'; // v1 留意 schema 演化
  static const _kEmailKey = 'verstro_email_v1';

  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  Future<String?> getToken() async => _prefs.getString(_kTokenKey);

  Future<void> setToken(String token) async {
    await _prefs.setString(_kTokenKey, token);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_kTokenKey);
  }

  Future<bool> isLoggedIn() async => (await getToken()) != null;

  Future<String?> getEmail() async => _prefs.getString(_kEmailKey);

  Future<void> setEmail(String email) async {
    await _prefs.setString(_kEmailKey, email);
  }

  Future<void> logout() async {
    await _prefs.remove(_kTokenKey);
    // email 留着方便重新登录, 不删
  }
}
