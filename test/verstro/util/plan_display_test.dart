// plan_display_test.dart — localizedPlanName 单元测试
//
// 覆盖已知套餐 id（含 premium-* 前缀、trial）映射到本地化文案，
// 以及未知 id 回退后端下发的 plan.name（兼容旧后端/未来新套餐）。

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/util/plan_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await AppLocalizations.load(const Locale('zh', 'CN'));
  });

  test('已知 id 映射本地化名', () {
    expect(localizedPlanName('monthly', 'X'), '标准·月付');
    expect(localizedPlanName('premium-yearly', 'X'), '专业·年付');
    expect(localizedPlanName('trial', 'X'), '试用');
  });

  test('未知 id 回退后端 name', () {
    expect(localizedPlanName('legacy-foo', '旧套餐名'), '旧套餐名');
  });
}
