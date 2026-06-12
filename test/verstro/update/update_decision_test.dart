// UpdateManifest.fromJson + evaluateUpdate 单测.
// 用真实形状的 android manifest 样本, 覆盖四种升级类型推导 + 强制门槛 + 边界.

import 'package:fl_clash/verstro/update/update_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> androidManifest({
  String latest = '1.3.0',
  String upgradeType = 'optional',
  String minSupported = '1.0.0',
}) =>
    {
      'schema': 1,
      'platform': 'android',
      'latest': {
        'version': latest,
        'build': 18000,
        'upgrade_type': upgradeType,
        'notes': '• 修复 xxx\n• 优化 yyy',
        'released_at': '2026-06-15',
        'artifacts': {
          'arm64-v8a': {
            'url': 'https://dl.verstro.com/Verstro-$latest-arm64-v8a.apk',
            'sha256': 'a' * 64,
            'size': 50331648,
          },
          'armeabi-v7a': {
            'url': 'https://dl.verstro.com/Verstro-$latest-armeabi-v7a.apk',
            'sha256': 'b' * 64,
            'size': 48234496,
          },
        },
      },
      'min_supported_version': minSupported,
    };

void main() {
  group('UpdateManifest.fromJson', () {
    test('解析完整 android manifest', () {
      final m = UpdateManifest.fromJson(androidManifest());
      expect(m.platform, 'android');
      expect(m.latest.version, '1.3.0');
      expect(m.latest.build, 18000);
      expect(m.latest.upgradeType, UpgradeType.optional);
      expect(m.latest.notes, contains('修复'));
      expect(m.minSupportedVersion, '1.0.0');
      expect(m.latest.artifacts.length, 2);
      expect(m.latest.artifacts['arm64-v8a']!.sha256, 'a' * 64);
      expect(m.latest.artifacts['arm64-v8a']!.size, 50331648);
    });

    test('缺 min_supported_version → 默认 0.0.0(不强制任何人)', () {
      final json = androidManifest()..remove('min_supported_version');
      final m = UpdateManifest.fromJson(json);
      expect(m.minSupportedVersion, '0.0.0');
    });

    test('未知 upgrade_type → optional(安全默认)', () {
      final m = UpdateManifest.fromJson(androidManifest(upgradeType: 'wat'));
      expect(m.latest.upgradeType, UpgradeType.optional);
    });

    test('pickArtifact 按 ABI 优先级选', () {
      final m = UpdateManifest.fromJson(androidManifest());
      expect(m.latest.pickArtifact(['arm64-v8a', 'armeabi-v7a'])!.url,
          contains('arm64-v8a'));
      expect(m.latest.pickArtifact(['armeabi-v7a'])!.url,
          contains('armeabi-v7a'));
      expect(m.latest.pickArtifact(['x86_64']), isNull);
    });
  });

  group('evaluateUpdate', () {
    test('当前已是最新 → 无更新', () {
      final m = UpdateManifest.fromJson(androidManifest(latest: '1.3.0'));
      final d = evaluateUpdate(currentVersion: '1.3.0', manifest: m);
      expect(d.hasUpdate, false);
    });

    test('有更新且 optional(可忽略)', () {
      final m = UpdateManifest.fromJson(
          androidManifest(latest: '1.3.0', upgradeType: 'optional'));
      final d = evaluateUpdate(currentVersion: '1.2.1', manifest: m);
      expect(d.hasUpdate, true);
      expect(d.type, UpgradeType.optional);
      expect(d.allowIgnore, true);
      expect(d.isForce, false);
      expect(d.latestVersion, '1.3.0');
    });

    test('recommended 不允许忽略', () {
      final m =
          UpdateManifest.fromJson(androidManifest(upgradeType: 'recommended'));
      final d = evaluateUpdate(currentVersion: '1.2.1', manifest: m);
      expect(d.type, UpgradeType.recommended);
      expect(d.allowIgnore, false);
    });

    test('silent', () {
      final m = UpdateManifest.fromJson(androidManifest(upgradeType: 'silent'));
      final d = evaluateUpdate(currentVersion: '1.2.1', manifest: m);
      expect(d.type, UpgradeType.silent);
      expect(d.isSilent, true);
    });

    test('低于 min_supported_version → 强制(覆盖 release 标注的 optional)', () {
      final m = UpdateManifest.fromJson(androidManifest(
          latest: '1.3.0', upgradeType: 'optional', minSupported: '1.2.0'));
      final d = evaluateUpdate(currentVersion: '1.1.0', manifest: m);
      expect(d.hasUpdate, true);
      expect(d.type, UpgradeType.force);
      expect(d.isForce, true);
      expect(d.allowIgnore, false);
    });

    test('等于 min_supported_version → 不强制(边界), 但仍提示 optional 更新', () {
      final m = UpdateManifest.fromJson(androidManifest(
          latest: '1.3.0', upgradeType: 'optional', minSupported: '1.2.0'));
      final d = evaluateUpdate(currentVersion: '1.2.0', manifest: m);
      expect(d.isForce, false);
      expect(d.type, UpgradeType.optional);
    });

    test('数值版本比较: 设备 1.9.0 vs 最新 1.10.0 有更新', () {
      final m = UpdateManifest.fromJson(androidManifest(latest: '1.10.0'));
      final d = evaluateUpdate(currentVersion: '1.9.0', manifest: m);
      expect(d.hasUpdate, true);
    });
  });
}
