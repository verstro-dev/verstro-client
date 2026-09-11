// money_test.dart — usdToCents / centsToUsd 单元测试
//
// 覆盖常规金额、零值、以及 invoice 防冲突尾数对账场景。

import 'package:fl_clash/verstro/util/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('usdToCents', () {
    test('"5.00" → 500', () => expect(usdToCents('5.00'), 500));
    test('"2.50" → 250', () => expect(usdToCents('2.50'), 250));
    test('"45.00" → 4500', () => expect(usdToCents('45.00'), 4500));
    test('"0" → 0', () => expect(usdToCents('0'), 0));
    test('"1.72" → 172', () => expect(usdToCents('1.72'), 172));
    test('"0.22" → 22', () => expect(usdToCents('0.22'), 22));
    test('"1.00" → 100', () => expect(usdToCents('1.00'), 100));
    // 边界: 无小数点 / 一位小数
    test('"5" → 500（无小数点）', () => expect(usdToCents('5'), 500));
    test('"5.5" → 550（一位小数）', () => expect(usdToCents('5.5'), 550));
  });

  group('centsToUsd', () {
    test('172 → "1.72"', () => expect(centsToUsd(172), '1.72'));
    test('22 → "0.22"', () => expect(centsToUsd(22), '0.22'));
    test('500 → "5.00"', () => expect(centsToUsd(500), '5.00'));
    test('0 → "0.00"', () => expect(centsToUsd(0), '0.00'));
  });

  group('couponSuffixCents', () {
    // 券only: 原价5.00 - 券2.50 = 2.50, final=2.86 → 尾数=36¢（订单#48 实测）
    test('券only: 2.86 - (5.00-2.50) = 36', () {
      expect(couponSuffixCents('2.86', '5.00', '2.50', null), 36);
    });
    // credit only: 原价5.00 - credit1.00 = 4.00, final=4.22 → 尾数=22¢
    test('credit only: 4.22 - (5.00-1.00) = 22', () {
      expect(couponSuffixCents('4.22', '5.00', null, '1.00'), 22);
    });
    // 券+credit: 原价5.00 - 券1.50 - credit1.00 = 2.50, final=3.35 → 尾数=85¢（订单#55 实测）
    test('券+credit: 3.35 - (5.00-1.50-1.00) = 85', () {
      expect(couponSuffixCents('3.35', '5.00', '1.50', '1.00'), 85);
    });
    // 都无折扣（外部已用 hasDiscount 门控, 此处验证纯函数正确性）: 订单#54 实测
    test('都无折扣: 5.78 - 5.00 = 78', () {
      expect(couponSuffixCents('5.78', '5.00', null, null), 78);
    });
    // 尾数=0: 满折恰好无尾数
    test('尾数=0: 2.50 - (5.00-2.50) = 0', () {
      expect(couponSuffixCents('2.50', '5.00', '2.50', null), 0);
    });
  });
}
