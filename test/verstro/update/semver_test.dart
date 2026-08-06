// compareSemver 单测 —— 升级检测的版本比对正确性.
// 重点覆盖"数值比较而非字典序"(1.10.0 > 1.9.0)和容错(fail-open 依赖它不抛).

import 'package:fl_clash/verstro/update/semver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('compareSemver', () {
    test('相等', () {
      expect(compareSemver('1.2.1', '1.2.1'), 0);
    });

    test('补丁号大小', () {
      expect(compareSemver('1.2.1', '1.2.2'), -1);
      expect(compareSemver('1.2.2', '1.2.1'), 1);
    });

    test('数值比较而非字典序(关键): 1.10.0 > 1.9.0', () {
      expect(compareSemver('1.10.0', '1.9.0'), 1);
      expect(compareSemver('1.9.0', '1.10.0'), -1);
    });

    test('主/次版本', () {
      expect(compareSemver('2.0.0', '1.99.99'), 1);
      expect(compareSemver('1.3.0', '1.2.9'), 1);
    });

    test('段数不齐按 0 补齐', () {
      expect(compareSemver('1.2', '1.2.0'), 0);
      expect(compareSemver('1.2.1', '1.2'), 1);
    });

    test('去前导 v 与 build/pre-release 后缀', () {
      expect(compareSemver('v1.2.1', '1.2.1'), 0);
      expect(compareSemver('1.2.1+17500', '1.2.1'), 0);
      expect(compareSemver('1.2.1-beta', '1.2.1'), 0);
      expect(compareSemver('1.3.0+18000', '1.2.1+17500'), 1);
    });

    test('容错: 空/垃圾输入不抛异常(fail-open 依赖)', () {
      expect(compareSemver('', '0.0.0'), 0);
      expect(compareSemver('abc', '0.0.0'), 0);
      expect(compareSemver('1.2.1', ''), 1);
    });

    test('isNewerVersion', () {
      expect(isNewerVersion('1.3.0', '1.2.1'), true);
      expect(isNewerVersion('1.2.1', '1.2.1'), false);
      expect(isNewerVersion('1.2.0', '1.2.1'), false);
    });
  });
}
