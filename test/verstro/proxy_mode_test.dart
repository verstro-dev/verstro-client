import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

Group _g(String name, GroupType type, {bool? hidden = false}) =>
    Group(name: name, type: type, hidden: hidden);

void main() {
  group('primarySelectorName', () {
    test('取可见的、非 GLOBAL 的 Selector 组', () {
      final groups = [
        _g('GLOBAL', GroupType.Selector),
        _g('线路', GroupType.Selector),
        _g('Auto', GroupType.URLTest),
      ];
      expect(groups.primarySelectorName, '线路');
    });

    test('跳过 hidden 与非 Selector，取首个合格组', () {
      final groups = [
        _g('隐藏组', GroupType.Selector, hidden: true),
        _g('Auto', GroupType.URLTest),
        _g('线路', GroupType.Selector),
      ];
      expect(groups.primarySelectorName, '线路');
    });

    test('无合格组返回 null', () {
      final groups = [
        _g('GLOBAL', GroupType.Selector),
        _g('Auto', GroupType.URLTest),
      ];
      expect(groups.primarySelectorName, isNull);
    });
  });

  group('ModeExt', () {
    test('label 用用户语言', () {
      expect(Mode.rule.label, '智能分流');
      expect(Mode.global.label, '全局代理');
      expect(Mode.direct.label, '直连');
    });

    test('visibleValues 隐藏 direct', () {
      expect(ModeExt.visibleValues, [Mode.rule, Mode.global]);
      expect(ModeExt.visibleValues.contains(Mode.direct), isFalse);
    });
  });
}
