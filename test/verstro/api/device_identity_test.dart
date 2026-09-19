// DeviceIdentity 纯逻辑测试 (T4.2, 见 docs/security/account-device-control.md)
//
// device_id 必须: 稳定 (同设备复用同值) + 唯一 (不同生成互不相同) + 格式固定.
// resolveDeviceName 依赖平台插件 channel, 不在单测覆盖 (靠 flutter analyze + 真机).

import 'package:fl_clash/verstro/api/device_identity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceIdentity.generateDeviceId', () {
    test('返回 32 位小写 hex (16 字节)', () {
      final id = DeviceIdentity.generateDeviceId();
      expect(id, hasLength(32));
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(id), isTrue);
    });

    test('多次生成互不相同 (随机性)', () {
      final ids = {
        for (var i = 0; i < 50; i++) DeviceIdentity.generateDeviceId(),
      };
      expect(ids.length, 50); // 50 次全不同
    });
  });

  group('DeviceIdentity.getOrCreateDeviceId', () {
    test('首次生成并持久化; 同实例再调返回同值 (幂等)', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final identity = DeviceIdentity(prefs);

      final first = identity.getOrCreateDeviceId();
      expect(first, hasLength(32));
      expect(identity.getOrCreateDeviceId(), first);
    });

    test('已有持久值时直接复用, 不重新生成', () async {
      SharedPreferences.setMockInitialValues({
        'verstro_device_id_v1': 'cafebabecafebabecafebabecafebabe',
      });
      final prefs = await SharedPreferences.getInstance();
      final identity = DeviceIdentity(prefs);

      expect(
        identity.getOrCreateDeviceId(),
        'cafebabecafebabecafebabecafebabe',
      );
    });
  });
}
