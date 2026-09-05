import 'dart:io';

import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('创建订单请求携带用户刚确认的服务端有效价', () {
    expect(
      buildCreateOrderBody(
        'monthly',
        couponCode: 'WELCOME10',
        promotionQuoteToken: 'signed-quote',
        expectedPlanVersionId: 17,
        expectedBasePriceCents: 480,
      ),
      {
        'plan_id': 'monthly',
        'coupon_code': 'WELCOME10',
        'promotion_quote_token': 'signed-quote',
        'expected_plan_version_id': 17,
        'expected_base_price_cents': 480,
      },
    );
  });

  test('统一促销报价请求只发送套餐权威事实和可选优惠码', () {
    expect(
      buildPromotionQuoteBody(
        'monthly',
        couponCode: 'WELCOME10',
        expectedPlanVersionId: 17,
        expectedBasePriceCents: 600,
      ),
      {
        'plan_id': 'monthly',
        'coupon_code': 'WELCOME10',
        'expected_plan_version_id': 17,
        'expected_base_price_cents': 600,
      },
    );
  });

  test('统一促销 API 路径和 404 能力降级写入客户端契约', () {
    final apiSource = File(
      'lib/verstro/api/backend_api.dart',
    ).readAsStringSync();
    final providerSource = File(
      'lib/verstro/providers/promotions_provider.dart',
    ).readAsStringSync();
    expect(apiSource, contains("'/v1/promotions/active'"));
    expect(apiSource, contains("'/v1/me/promotions'"));
    expect(apiSource, contains("'/v1/me/promotions/events'"));
    expect(apiSource, contains("'/v1/orders/quote'"));
    expect(providerSource, contains('on NotFoundException'));
    expect(providerSource, isNot(contains('print(')));
    expect(providerSource, isNot(contains('debugPrint(')));
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

  test('claim-tx 新响应通过模型边界保留拆分付款事实而非 message', () {
    final result = ClaimTxResult.fromJson({
      'matched': true,
      'message': '这段自由文案即使变化也不能改变客户端处置',
      'resolution': 'split_payment_completed',
      'received_cents': 607,
      'remaining_cents': 0,
      'payment_count': 2,
      'credited_cents': 50,
      'order_status': 'finished',
    });

    expect(result.resolution, 'split_payment_completed');
    expect(result.receivedCents, 607);
    expect(result.remainingCents, 0);
    expect(result.paymentCount, 2);
    expect(result.creditedCents, 50);
    expect(result.orderStatus, 'finished');
  });

  test('claim-tx pending 和 wrong-recipient 保留等待秒数及脱敏地址', () {
    final pending = ClaimTxResult.fromJson({
      'matched': false,
      'message': '自由文案',
      'resolution': 'pending_confirmation',
      'retry_after_seconds': 45,
    });
    final wrong = ClaimTxResult.fromJson({
      'matched': false,
      'message': '不得包含完整地址',
      'resolution': 'wrong_recipient',
      'actual_recipient_masked': 'TBcd…wXYZ',
    });

    expect(pending.retryAfterSeconds, 45);
    expect(wrong.actualRecipientMasked, 'TBcd…wXYZ');
  });
}
