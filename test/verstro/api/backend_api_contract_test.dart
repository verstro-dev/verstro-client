import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('创建订单请求携带用户刚确认的服务端有效价', () {
    expect(
      buildCreateOrderBody(
        'monthly',
        couponCode: 'WELCOME10',
        expectedPlanVersionId: 17,
        expectedBasePriceCents: 480,
      ),
      {
        'plan_id': 'monthly',
        'coupon_code': 'WELCOME10',
        'expected_plan_version_id': 17,
        'expected_base_price_cents': 480,
      },
    );
  });

  test('空优惠码不进入请求体', () {
    expect(
      buildCreateOrderBody(
        'yearly',
        expectedPlanVersionId: 23,
        expectedBasePriceCents: 3920,
      ),
      {
        'plan_id': 'yearly',
        'expected_plan_version_id': 23,
        'expected_base_price_cents': 3920,
      },
    );
  });
}
