import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> response() => {
  'balance_cents': 10,
  'credits': [
    {'id': 1, 'kind': 'manual', 'amount_cents': 20, 'usable_cents': 10},
  ],
  'pending_order_cents': 100,
  'pending_orders': [
    <String, dynamic>{
      'order_id': 93,
      'received_cents': 100,
      'remaining_cents': 401,
      'expires_at': '2026-09-06T12:00:00Z',
    },
  ],
};
void main() {
  test('可花10 cents，待补100 cents，明细只读usable_cents', () {
    final dto = CreditDto.fromJson(response());
    expect(dto.balanceCents, 10);
    expect(dto.credits.single.usableCents, 10);
    expect(dto.pendingOrderCents, 100);
    expect(dto.pendingOrders.single.orderId, 93);
    expect(dto.pendingOrders.single.remainingCents, 401);
    expect(dto.pendingOrders.single.expiresAt, DateTime.utc(2026, 9, 6, 12));
  });
  test('旧后端两个字段都缺省兼容空', () {
    final dto = CreditDto.fromJson({'balance_cents': 10, 'credits': null});
    expect(dto.pendingOrderCents, 0);
    expect(dto.pendingOrders, isEmpty);
  });
  for (final key in ['pending_order_cents', 'pending_orders']) {
    test('新版缺少$key拒绝', () {
      final json = response()..remove(key);
      expect(() => CreditDto.fromJson(json), throwsFormatException);
    });
    test('新版$key为null拒绝', () {
      final json = response()..[key] = null;
      expect(() => CreditDto.fromJson(json), throwsFormatException);
    });
  }
  for (final value in [-1, 100.5, '100']) {
    test('错误总额$value拒绝', () {
      final json = response()..['pending_order_cents'] = value;
      expect(() => CreditDto.fromJson(json), throwsFormatException);
    });
  }
  test('总额不一致拒绝', () {
    final json = response()..['pending_order_cents'] = 200;
    expect(() => CreditDto.fromJson(json), throwsFormatException);
  });
  test('重复订单拒绝，避免重复展示资金', () {
    final json = response();
    (json['pending_orders'] as List).add(
      (json['pending_orders'] as List).first,
    );
    json['pending_order_cents'] = 200;
    expect(() => CreditDto.fromJson(json), throwsFormatException);
  });
  for (final key in [
    'order_id',
    'received_cents',
    'remaining_cents',
    'expires_at',
  ]) {
    test('明细缺少$key拒绝', () {
      final json = response();
      (json['pending_orders'] as List).first.remove(key);
      expect(() => CreditDto.fromJson(json), throwsFormatException);
    });
  }
  test('整数字段不截断小数', () {
    final json = response();
    (json['pending_orders'] as List).first['received_cents'] = 100.5;
    expect(() => CreditDto.fromJson(json), throwsFormatException);
  });
}
