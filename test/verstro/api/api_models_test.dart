// api_models.fromJson smoke tests
//
// 后端 JSON shape 跟 client 解析的接口边界. backend 改字段名 / 形状时, 这些测试
// 失败让我们立刻知道. 用真实后端 billing 服务返回的样本 JSON.

import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthResult.fromJson', () {
    test('register 成功响应', () {
      final json = {
        'access_token': 'eyJhbGc.iOiJIUzI1NiIsInR5cCI...',
        'token_type': 'Bearer',
        'expires_in': 86400,
        'user': {
          'id': 42,
          'email': 'test-xxxx@verstro.com',
          'email_verified_at': null,
          'created_at': '2026-05-28T03:31:17Z',
        },
      };
      final auth = AuthResult.fromJson(json);
      expect(auth.accessToken, startsWith('eyJhbGc'));
      expect(auth.tokenType, 'Bearer');
      expect(auth.expiresIn, 86400);
      expect(auth.user.id, 42);
      expect(auth.user.email, 'test-xxxx@verstro.com');
      expect(auth.user.isEmailVerified, false);
    });

    test('已验证邮箱的 user', () {
      final json = {
        'access_token': 'tok',
        'expires_in': 3600,
        'user': {
          'id': 1,
          'email': 'a@b.com',
          'email_verified_at': '2026-05-28T10:00:00Z',
          'created_at': '2026-05-27T12:00:00Z',
        },
      };
      final auth = AuthResult.fromJson(json);
      expect(auth.user.isEmailVerified, true);
    });
  });

  group('OrderDto.fromJson', () {
    test('waiting 订单 (含 deposit_address 和 cents 尾数 final_amount)', () {
      final json = {
        'id': 7,
        'plan_id': 'monthly',
        'base_price': '5.00',
        'final_amount': '5.49',
        'status': 'waiting',
        'deposit_address': 'TXxxxxxxxxxxxxxxxxxxxxxxxxxxxEygM',
        'pay_currency': 'usdttrc20',
        'created_at': '2026-05-28T03:31:17Z',
        'expires_at': '2026-05-29T03:31:17Z',
        'paid_at': null,
        'txid': null,
      };
      final o = OrderDto.fromJson(json);
      expect(o.id, 7);
      expect(o.planId, 'monthly');
      expect(o.basePrice, '5.00');
      expect(o.finalAmount, '5.49');
      expect(o.isWaiting, true);
      expect(o.isFinished, false);
      expect(o.depositAddress, endsWith('EygM'));
      expect(o.txid, null);
      expect(o.paidAt, null);
    });

    test('finished 订单 (含 txid + paid_at, deposit_address 已 null)', () {
      final json = {
        'id': 8,
        'plan_id': 'quarterly',
        'base_price': '13.00',
        'final_amount': '13.56',
        'status': 'finished',
        'deposit_address': null,
        'pay_currency': 'usdttrc20',
        'created_at': '2026-05-28T03:31:17Z',
        'expires_at': '2026-05-29T03:31:17Z',
        'paid_at': '2026-05-28T03:35:42Z',
        'txid': 'abcdef1234567890',
      };
      final o = OrderDto.fromJson(json);
      expect(o.isFinished, true);
      expect(o.txid, 'abcdef1234567890');
      expect(o.paidAt, isNotNull);
      expect(o.depositAddress, null);
    });
  });

  group('SubscriptionDto.fromJson', () {
    test('无订阅', () {
      final json = {'has_subscription': false, 'is_expired': false};
      final s = SubscriptionDto.fromJson(json);
      expect(s.hasSubscription, false);
      expect(s.subscriptionUrl, null);
      expect(s.currentPlanId, null);
    });

    test('有订阅 + URL + 剩余天数', () {
      final json = {
        'has_subscription': true,
        'subscription_url': 'https://api.verstro.com/api/billing/sub/v2/abc123',
        'current_plan_id': 'monthly',
        'period_started_at': '2026-05-28T00:00:00Z',
        'period_expires_at': '2026-06-27T00:00:00Z',
        'traffic_limit_bytes': 214748364800,
        'is_expired': false,
      };
      final s = SubscriptionDto.fromJson(json);
      expect(s.hasSubscription, true);
      expect(s.subscriptionUrl, 'https://api.verstro.com/api/billing/sub/v2/abc123');
      expect(s.currentPlanId, 'monthly');
      expect(s.trafficLimitBytes, 200 * 1024 * 1024 * 1024);
      expect(s.isExpired, false);
    });

    test('过期订阅: backend 返空 URL → 客户端转 null', () {
      final json = {
        'has_subscription': true,
        'subscription_url': '', // 过期 backend 强制空 (subscription.go 逻辑)
        'current_plan_id': 'monthly',
        'period_expires_at': '2026-04-01T00:00:00Z',
        'is_expired': true,
      };
      final s = SubscriptionDto.fromJson(json);
      expect(s.subscriptionUrl, null); // 空字符串应该被规范化成 null
      expect(s.isExpired, true);
    });
  });

  group('PlanDto.fromJson', () {
    test(r'monthly $5.00 plan', () {
      final json = {
        'id': 'monthly',
        'name': '月付',
        'duration_days': 30,
        'price_usd': '5.00',
        'traffic_limit_bytes': 214748364800,
      };
      final p = PlanDto.fromJson(json);
      expect(p.id, 'monthly');
      expect(p.name, '月付');
      expect(p.priceUsd, '5.00');
      expect(p.trafficLimitBytes, 200 * 1024 * 1024 * 1024);
    });
  });

  group('ClaimTxResult.fromJson', () {
    test('matched true', () {
      final r = ClaimTxResult.fromJson({
        'matched': true,
        'message': '已确认, 订阅已开通',
      });
      expect(r.matched, true);
      expect(r.message, contains('订阅'));
    });
    test('matched false 兜底文案', () {
      final r = ClaimTxResult.fromJson({
        'matched': false,
        'message': '已记录该 tx, 但金额与订单不符. 联系客服 @verstro_support 处理',
      });
      expect(r.matched, false);
      expect(r.message, contains('客服'));
    });
  });

  group('BootstrapDto.fromJson', () {
    test('3 域名 default scheme', () {
      final json = {
        'domains': ['api.verstro.com', 'api.verstro.dev', 'api.verstro.io'],
        'scheme': 'https',
        'api_prefix': '/api/billing',
      };
      final b = BootstrapDto.fromJson(json);
      expect(b.domains, hasLength(3));
      expect(b.domains, contains('api.verstro.dev'));
      expect(b.scheme, 'https');
      expect(b.apiPrefix, '/api/billing');
    });
  });
}
