// planVerstroProfile 纯决策测试 (T3.2 profile 迁移, 见 docs/security/client-credential-security.md)
//
// 背景: 开 SUB_PROXY flag 后订阅 URL 原生→v2, 旧逻辑按 url 匹配→重复导入 profile (真机已复现).
// 修复: verstro 隐藏了手动导入(kVerstroHideManualImport), 所以所有 profile 都是 verstro 托管 →
//   保留一个 canonical (优先存的 managedId, 否则第一个), URL 变则替换(同 id 不新增), 删多余(清重复).

import 'package:fl_clash/verstro/profile_sync.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ({int id, String url}) p(int id, String url) => (id: id, url: url);

  group('planVerstroProfile', () {
    test('空 → import', () {
      final r = planVerstroProfile(null, [], 'U');
      expect(r.action, VerstroProfileAction.import);
      expect(r.deleteIds, isEmpty);
    });

    test('已有同 url → skip 保留', () {
      final r = planVerstroProfile(null, [p(1, 'U')], 'U');
      expect(r.action, VerstroProfileAction.skip);
      expect(r.keepId, 1);
      expect(r.deleteIds, isEmpty);
    });

    test('存量原生 url 变 v2 → replace 同 id (不新增)', () {
      final r = planVerstroProfile(null, [p(1, 'OLD')], 'NEW');
      expect(r.action, VerstroProfileAction.replace);
      expect(r.keepId, 1);
      expect(r.deleteIds, isEmpty);
    });

    test('已重复(原生+v2) managedId=1 → 更新 canonical 1 + 删多余 2', () {
      final r = planVerstroProfile(1, [p(1, 'OLD'), p(2, 'NEW')], 'NEW');
      expect(r.action, VerstroProfileAction.replace);
      expect(r.keepId, 1);
      expect(r.deleteIds, [2]);
    });

    test('重复同 url → skip + 删多余', () {
      final r = planVerstroProfile(null, [p(1, 'U'), p(2, 'U')], 'U');
      expect(r.action, VerstroProfileAction.skip);
      expect(r.keepId, 1);
      expect(r.deleteIds, [2]);
    });

    test('managedId 已被删 → 用现有第一个当 canonical', () {
      final r = planVerstroProfile(9, [p(5, 'X')], 'Y');
      expect(r.action, VerstroProfileAction.replace);
      expect(r.keepId, 5);
      expect(r.deleteIds, isEmpty);
    });

    test('managedId 命中 + url 同 → skip 删其余', () {
      final r = planVerstroProfile(2, [p(1, 'A'), p(2, 'B')], 'B');
      expect(r.action, VerstroProfileAction.skip);
      expect(r.keepId, 2);
      expect(r.deleteIds, [1]);
    });
  });
}
