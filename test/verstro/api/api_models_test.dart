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

    test('fromJson 解析 coupon_discount + credit_applied', () {
      final dto = OrderDto.fromJson({
        'id': 1, 'plan_id': 'monthly', 'base_price': '5.00', 'final_amount': '1.66',
        'coupon_discount': '1.00', 'credit_applied': '2.34',
        'status': 'waiting', 'deposit_address': 'T...', 'pay_currency': 'usdttrc20',
        'created_at': '2026-06-22T00:00:00Z', 'expires_at': '2026-06-23T00:00:00Z',
      });
      expect(dto.couponDiscount, '1.00');
      expect(dto.creditApplied, '2.34');
    });
    test('fromJson 无折扣字段 → null (后端 omitempty)', () {
      final dto = OrderDto.fromJson({
        'id': 2, 'plan_id': 'monthly', 'base_price': '5.00', 'final_amount': '5.07',
        'status': 'waiting', 'pay_currency': 'usdttrc20',
        'created_at': '2026-06-22T00:00:00Z', 'expires_at': '2026-06-23T00:00:00Z',
      });
      expect(dto.couponDiscount, isNull);
      expect(dto.creditApplied, isNull);
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

  group('AgentDto', () {
    test('fromJson 完整解析', () {
      final dto = AgentDto.fromJson({
        'code': 'ABCD1234',
        'direct_count': 5,
        'referee_reward_cents': 200,
        'referrer_reward_cents': 300,
      });
      expect(dto.code, 'ABCD1234');
      expect(dto.directCount, 5);
      expect(dto.refereeRewardCents, 200);
      expect(dto.referrerRewardCents, 300);
    });
    test('fromJson 字段缺省 → 默认值(不抛)', () {
      final dto = AgentDto.fromJson(<String, dynamic>{});
      expect(dto.code, '');
      expect(dto.directCount, 0);
      expect(dto.refereeRewardCents, 0);
      expect(dto.referrerRewardCents, 0);
    });
    test('fromJson 浮点数字段 → toInt 降级(防 JSON 浮点)', () {
      final dto = AgentDto.fromJson({
        'code': 'X',
        'direct_count': 5.0,
        'referee_reward_cents': 200.0,
        'referrer_reward_cents': 300.0,
      });
      expect(dto.directCount, 5);
      expect(dto.refereeRewardCents, 200);
      expect(dto.referrerRewardCents, 300);
    });
    test('fromJson 解析佣金/tier 字段', () {
      final d = AgentDto.fromJson({
        'code': 'X', 'direct_count': 3, 'tier': 'reseller',
        'pending_cents': 100, 'available_cents': 1500, 'paid_cents': 200,
        'override_available_cents': 50, 'sub_agent_count': 2, 'can_recruit': false,
      });
      expect(d.tier, 'reseller');
      expect(d.availableCents, 1500);
      expect(d.pendingCents, 100);
      expect(d.paidCents, 200);
      expect(d.overrideAvailableCents, 50);
      expect(d.subAgentCount, 2);
    });
    test('fromJson 佣金字段缺省 → 0/promoter/false', () {
      final d = AgentDto.fromJson(<String, dynamic>{});
      expect(d.tier, 'promoter'); // 缺省 promoter(后端默认)
      expect(d.availableCents, 0);
      expect(d.canRecruit, false);
    });
  });

  group('AgentPricesDto', () {
    test('fromJson 解析 tier + 各套餐 list/floor/custom', () {
      final d = AgentPricesDto.fromJson({
        'tier': 'reseller',
        'prices': [
          {'plan_id': 'monthly', 'list_cents': 500, 'floor_cents': 300, 'price_cents': 450},
          {'plan_id': 'yearly', 'list_cents': 4500, 'floor_cents': 2700},
        ],
      });
      expect(d.tier, 'reseller');
      expect(d.prices.length, 2);
      expect(d.prices[0].planId, 'monthly');
      expect(d.prices[0].listCents, 500);
      expect(d.prices[0].floorCents, 300);
      expect(d.prices[0].customCents, 450);
      expect(d.prices[1].customCents, null); // 未设
    });
    test('fromJson prices 空列表 → 空 List', () {
      final d = AgentPricesDto.fromJson({'tier': 'promoter', 'prices': []});
      expect(d.tier, 'promoter');
      expect(d.prices, isEmpty);
    });
    test('fromJson prices 缺省 → 空 List', () {
      final d = AgentPricesDto.fromJson(<String, dynamic>{});
      expect(d.tier, 'promoter');
      expect(d.prices, isEmpty);
    });
  });

  group('TrialStatusDto', () {
    test('fromJson 完整解析', () {
      final dto = TrialStatusDto.fromJson({
        'enabled': true, 'claimed': false, 'days': 3, 'traffic_gb': 10,
      });
      expect(dto.enabled, true);
      expect(dto.claimed, false);
      expect(dto.days, 3);
      expect(dto.trafficGb, 10);
    });
    test('fromJson 缺省 → 默认值(不抛)', () {
      final dto = TrialStatusDto.fromJson(<String, dynamic>{});
      expect(dto.enabled, false);
      expect(dto.claimed, false);
      expect(dto.days, 0);
      expect(dto.trafficGb, 0);
    });
    test('fromJson 浮点 traffic_gb → toInt 降级', () {
      final dto = TrialStatusDto.fromJson({'traffic_gb': 10.0, 'days': 3.0});
      expect(dto.trafficGb, 10);
      expect(dto.days, 3);
    });
  });

  group('CreditDto', () {
    test('fromJson 解析 balance + credits (含可空 expires_at)', () {
      final dto = CreditDto.fromJson({
        'balance_cents': 350,
        'credits': [
          {'id': 1, 'kind': 'referral_reward', 'amount_cents': 200, 'usable_cents': 200, 'expires_at': '2026-12-01T00:00:00Z'},
          {'id': 2, 'kind': 'manual', 'amount_cents': 150, 'usable_cents': 150, 'expires_at': null},
        ],
      });
      expect(dto.balanceCents, 350);
      expect(dto.credits.length, 2);
      expect(dto.credits[0].kind, 'referral_reward');
      expect(dto.credits[0].usableCents, 200);
      expect(dto.credits[0].expiresAt, isNotNull);
      expect(dto.credits[1].expiresAt, isNull);
    });

    test('fromJson 容 credits=null (后端 nil slice)', () {
      final dto = CreditDto.fromJson({'balance_cents': 0, 'credits': null});
      expect(dto.balanceCents, 0);
      expect(dto.credits, isEmpty);
    });
  });
}
