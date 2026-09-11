// api_models.fromJson smoke tests
//
// 后端 JSON shape 跟 client 解析的接口边界. backend 改字段名 / 形状时, 这些测试
// 失败让我们立刻知道. 用真实后端 billing 服务返回的样本 JSON.

import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Promotion DTO', () {
    test('解析公开活动、本人资格和 UTC 时间且忽略未知字段', () {
      final summary = PromotionSummaryDto.fromJson({
        'campaign_id': 7,
        'revision_id': 9,
        'scenario': 'new_customer',
        'audience': 'new_customer',
        'plan_ids': ['monthly', 'yearly'],
        'title_i18n': {'zh-CN': '新客优惠', 'en': 'Welcome'},
        'description_i18n': <String, dynamic>{},
        'terms_i18n': <String, dynamic>{},
        'exposure_token': 'signed-exposure-token',
        'ends_at': '2026-09-01T08:00:00+08:00',
        'future_field': true,
      });
      expect(summary.campaignId, 7);
      expect(summary.planIds, ['monthly', 'yearly']);
      expect(summary.endsAt, DateTime.utc(2026, 9, 1));
      expect(summary.exposureToken, 'signed-exposure-token');

      final mine = MyPromotionsDto.fromJson({
        'automatic': [
          {
            'campaign_id': 7,
            'revision_id': 9,
            'scenario': 'new_customer',
            'availability': 'available',
            'eligible_plan_ids': ['monthly'],
            'title_i18n': {'en': 'Welcome'},
            'description_i18n': <String, dynamic>{},
            'terms_i18n': <String, dynamic>{},
          },
        ],
        'grants': <dynamic>[],
        'redemptions': <dynamic>[],
      });
      expect(mine.automatic.single.availability, 'available');
      expect(mine.automatic.single.eligiblePlanIds, ['monthly']);
    });

    test('报价金额保持整数、未知 application 安全保留、token 必填', () {
      final quote = PromotionQuoteDto.fromJson({
        'campaign_id': 7,
        'revision_id': 9,
        'application': 'future_kind',
        'base_price_cents': 600,
        'discount_cents': 60,
        'price_after_discount_cents': 540,
        'quote_token': 'signed-token',
        'expires_at': '2026-09-01T00:00:00Z',
      });
      expect(quote.application, 'future_kind');
      expect(quote.basePriceCents, 600);
      expect(quote.discountCents, 60);
      expect(quote.priceAfterDiscountCents, 540);
      expect(quote.expiresAt.isUtc, true);
      expect(
        () => PromotionQuoteDto.fromJson({
          'base_price_cents': 600,
          'discount_cents': 0,
          'price_after_discount_cents': 600,
          'expires_at': '2026-09-01T00:00:00Z',
        }),
        throwsFormatException,
      );
      expect(
        () => PromotionQuoteDto.fromJson({
          'base_price_cents': 600,
          'discount_cents': 60,
          'price_after_discount_cents': 599,
          'quote_token': 'signed-token',
          'expires_at': '2026-09-01T00:00:00Z',
        }),
        throwsFormatException,
      );
    });
  });

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
        'id': 1,
        'plan_id': 'monthly',
        'base_price': '5.00',
        'final_amount': '1.66',
        'coupon_discount': '1.00',
        'credit_applied': '2.34',
        'status': 'waiting',
        'deposit_address': 'T...',
        'pay_currency': 'usdttrc20',
        'created_at': '2026-06-22T00:00:00Z',
        'expires_at': '2026-06-23T00:00:00Z',
      });
      expect(dto.couponDiscount, '1.00');
      expect(dto.creditApplied, '2.34');
    });
    test('fromJson 无折扣字段 → null (后端 omitempty)', () {
      final dto = OrderDto.fromJson({
        'id': 2,
        'plan_id': 'monthly',
        'base_price': '5.00',
        'final_amount': '5.07',
        'status': 'waiting',
        'pay_currency': 'usdttrc20',
        'created_at': '2026-06-22T00:00:00Z',
        'expires_at': '2026-06-23T00:00:00Z',
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

    test('partially_paid 订单解析累计到账、剩余金额和付款笔数', () {
      final o = OrderDto.fromJson({
        'id': 9,
        'plan_id': 'monthly',
        'base_price': '6.00',
        'final_amount': '6.07',
        'status': 'partially_paid',
        'deposit_address': 'TXxxxxxxxxxxxxxxxxxxxxxxxxxxxEygM',
        'pay_currency': 'usdttrc20',
        'received_cents': 400,
        'remaining_cents': 207,
        'payment_count': 1,
        'created_at': '2026-09-05T00:00:00Z',
        'expires_at': '2026-09-06T00:00:00Z',
      });

      expect(o.isPartiallyPaid, isTrue);
      expect(o.receivedCents, 400);
      expect(o.remainingCents, 207);
      expect(o.paymentCount, 1);
      expect(o.depositAddress, startsWith('TX'));
    });

    test('旧订单响应缺少累计字段时保持零值兼容', () {
      final o = OrderDto.fromJson({
        'id': 10,
        'plan_id': 'monthly',
        'base_price': '6.00',
        'final_amount': '6.07',
        'status': 'waiting',
        'pay_currency': 'usdttrc20',
        'created_at': '2026-09-05T00:00:00Z',
        'expires_at': '2026-09-06T00:00:00Z',
      });

      expect(o.receivedCents, 0);
      expect(o.remainingCents, 0);
      expect(o.paymentCount, 0);
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
      expect(
        s.subscriptionUrl,
        'https://api.verstro.com/api/billing/sub/v2/abc123',
      );
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
      expect(p.effectivePriceCents, 500);
      expect(p.listPriceUsd, '5.00');
      expect(p.partnerPrice, isFalse);
    });

    test('登录态个性化套餐保留平台价与专属价', () {
      final p = PlanDto.fromJson({
        'id': 'monthly',
        'name': '标准·月付',
        'duration_days': 30,
        'price_usd': '4.80',
        'price_cents': 480,
        'effective_price_cents': 480,
        'list_price_usd': '6.00',
        'list_price_cents': 600,
        'partner_price': true,
        'purchase_available': false,
        'unavailable_reason': 'partner_plan_sales_paused',
        'plan_version_id': 17,
        'traffic_limit_bytes': 214748364800,
        'max_devices': 5,
      });
      expect(p.priceUsd, '4.80');
      expect(p.effectivePriceCents, 480);
      expect(p.listPriceUsd, '6.00');
      expect(p.listPriceCents, 600);
      expect(p.partnerPrice, isTrue);
      expect(p.purchaseAvailable, isFalse);
      expect(p.unavailableReason, 'partner_plan_sales_paused');
      expect(p.planVersionId, 17);
    });

    test('手写旧式 PlanDto 也能从 priceUsd 推导下单确认价', () {
      const p = PlanDto(
        id: 'monthly',
        name: '标准·月付',
        durationDays: 30,
        priceUsd: '6.00',
        trafficLimitBytes: 100,
      );
      expect(p.expectedBasePriceCents, 600);
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
        'message':
            '已记录该 tx, 但金额与订单不符. 私聊 Telegram 客服 @VerstroSupportBot 提交订单号/邮箱/tx hash 人工处理',
      });
      expect(r.matched, false);
      expect(r.message, contains('客服'));
    });
    test('新契约 payload: resolution + credited/shortfall + order_status', () {
      final r = ClaimTxResult.fromJson({
        'matched': false,
        'message': '到账 3.00 USDT 已全额存入你的账户余额, 重新下单可自动抵扣',
        'resolution': 'credited_underpay',
        'credited_cents': 300,
        'shortfall_cents': 207,
        'order_status': 'expired',
      });
      expect(r.matched, false);
      expect(r.resolution, 'credited_underpay');
      expect(r.creditedCents, 300);
      expect(r.shortfallCents, 207);
      expect(r.orderStatus, 'expired');
    });
    test('新契约 payload: overpaid_matched (matched=true)', () {
      final r = ClaimTxResult.fromJson({
        'matched': true,
        'message': '已开通, 多付 0.50 已存入账户余额',
        'resolution': 'overpaid_matched',
        'credited_cents': 50,
        'order_status': 'finished',
      });
      expect(r.matched, true);
      expect(r.resolution, 'overpaid_matched');
      expect(r.creditedCents, 50);
      expect(r.shortfallCents, 0); // 缺省 0
      expect(r.orderStatus, 'finished');
    });
    test('拆分付款和类型化验证字段保持整数 cents', () {
      final r = ClaimTxResult.fromJson({
        'matched': false,
        'message': '不得用于客户端分支判断',
        'resolution': 'partially_paid',
        'received_cents': 400,
        'remaining_cents': 207,
        'payment_count': 1,
        'retry_after_seconds': 30,
        'actual_recipient_masked': 'TA12…Z9xy',
        'order_status': 'partially_paid',
      });

      expect(r.resolution, 'partially_paid');
      expect(r.receivedCents, 400);
      expect(r.remainingCents, 207);
      expect(r.paymentCount, 1);
      expect(r.retryAfterSeconds, 30);
      expect(r.actualRecipientMasked, 'TA12…Z9xy');
      expect(r.receivedCents, isA<int>());
      expect(r.remainingCents, isA<int>());
    });
    test('全部新增 resolution 原样保留供结构化 UI 分支', () {
      const resolutions = [
        'pending_confirmation',
        'wrong_recipient',
        'unsupported_transfer',
        'not_found',
        'provider_unavailable',
        'partially_paid',
        'split_payment_completed',
      ];

      for (final resolution in resolutions) {
        final r = ClaimTxResult.fromJson({
          'matched': resolution == 'split_payment_completed',
          'message': '自由文案',
          'resolution': resolution,
        });
        expect(r.resolution, resolution, reason: resolution);
      }
    });
    test('老后端 payload 无新字段 → null/0 (容错缺省)', () {
      final r = ClaimTxResult.fromJson({'matched': true, 'message': 'ok'});
      expect(r.matched, true);
      expect(r.resolution, isNull);
      expect(r.creditedCents, 0);
      expect(r.shortfallCents, 0);
      expect(r.orderStatus, isNull);
      expect(r.receivedCents, 0);
      expect(r.remainingCents, 0);
      expect(r.paymentCount, 0);
      expect(r.retryAfterSeconds, 0);
      expect(r.actualRecipientMasked, isNull);
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
        'code': 'X',
        'direct_count': 3,
        'tier': 'reseller',
        'pending_cents': 100,
        'available_cents': 1500,
        'paid_cents': 200,
        'override_available_cents': 50,
        'sub_agent_count': 2,
        'can_recruit': false,
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
    test('fromJson 解析 payout 透明化字段 (processing/min_payout/payouts)', () {
      final d = AgentDto.fromJson({
        'code': 'X',
        'pending_cents': 100,
        'available_cents': 1500,
        'paid_cents': 2000, // 语义: 已打款 (sent 合计)
        'processing_cents': 500,
        'min_payout_cents': 2000,
        'payouts': [
          {
            'id': 3,
            'amount_cents': 2000,
            'dest': 'TLyqzVGLV1srkB7dToTAEqgDSfPtXRJZYH',
            'status': 'sent',
            'txid':
                'aabbccddeeff00112233445566778899aabbccddeeff00112233445566778899',
            'created_at': '2026-07-01T08:00:00Z',
            'settled_at': '2026-07-01T10:00:00Z',
          },
          {
            'id': 4,
            'amount_cents': 500,
            'dest': 'TLyqzVGLV1srkB7dToTAEqgDSfPtXRJZYH',
            'status': 'requested',
            'created_at': '2026-07-02T08:00:00Z',
          },
        ],
      });
      expect(d.processingCents, 500);
      expect(d.minPayoutCents, 2000);
      expect(d.payouts, hasLength(2));
      expect(d.payouts[0].status, 'sent');
      expect(d.payouts[0].txid, startsWith('aabbccdd'));
      expect(d.payouts[0].settledAt, isNotNull);
      expect(d.payouts[1].status, 'requested');
      expect(d.payouts[1].txid, isNull);
      expect(d.payouts[1].settledAt, isNull);
    });
    test('fromJson 老后端无 payout 新 key → 默认值 (兼容)', () {
      final d = AgentDto.fromJson({'code': 'X', 'paid_cents': 100});
      expect(d.processingCents, 0);
      expect(d.minPayoutCents, 0);
      expect(d.payouts, isEmpty);
    });
    test('fromJson payouts=null (后端 nil slice) → 空 List', () {
      final d = AgentDto.fromJson({'code': 'X', 'payouts': null});
      expect(d.payouts, isEmpty);
    });
    test('fromJson 解析正式合作伙伴授权安全视图', () {
      final d = AgentDto.fromJson({
        'code': 'X',
        'tier': 'master',
        'partner_authorization': {
          'authorization_code': 'VPA-23456789',
          'level': 'strategic_distributor',
          'status': 'active',
          'cooperation_mode': 'non_exclusive',
          'capabilities': [
            'referral_link',
            'verified_partner_badge',
            'custom_pricing',
            'manage_resellers',
          ],
          'effective_at': '2026-07-21T08:00:00Z',
          'expires_at': '2027-07-21T08:00:00Z',
        },
      });
      expect(d.partnerAuthorization, isNotNull);
      expect(d.partnerAuthorization!.authorizationCode, 'VPA-23456789');
      expect(d.partnerAuthorization!.level, 'strategic_distributor');
      expect(d.partnerAuthorization!.status, 'active');
      expect(d.partnerAuthorization!.isVerified, isTrue);
      expect(d.partnerAuthorization!.isNonExclusive, isTrue);
      expect(
        d.partnerAuthorization!.capabilities,
        contains('manage_resellers'),
      );
      expect(d.partnerAuthorization!.expiresAt, isNotNull);
    });
  });

  group('AgentPayoutDto', () {
    test('fromJson 完整解析', () {
      final p = AgentPayoutDto.fromJson({
        'id': 7,
        'amount_cents': 1234,
        'dest': 'TLyqzVGLV1srkB7dToTAEqgDSfPtXRJZYH',
        'status': 'sent',
        'txid': 'ff00' * 16,
        'created_at': '2026-07-01T08:00:00Z',
        'settled_at': '2026-07-02T08:00:00Z',
      });
      expect(p.id, 7);
      expect(p.amountCents, 1234);
      expect(p.dest, startsWith('TLyqzV'));
      expect(p.status, 'sent');
      expect(p.txid, hasLength(64));
      expect(p.createdAt, isNotNull);
      expect(p.settledAt, isNotNull);
    });
    test('fromJson txid/settled_at 缺省 → null (requested 在途)', () {
      final p = AgentPayoutDto.fromJson({
        'id': 8,
        'amount_cents': 1000,
        'dest': 'T...',
        'status': 'requested',
        'created_at': '2026-07-01T08:00:00Z',
      });
      expect(p.txid, isNull);
      expect(p.settledAt, isNull);
    });
    test('fromJson 时间串非法/空 → null 不抛 (DateTime.tryParse 容错)', () {
      final p = AgentPayoutDto.fromJson({
        'id': 9,
        'amount_cents': 1000,
        'dest': 'T...',
        'status': 'failed',
        'created_at': 'not-a-date',
        'settled_at': '',
      });
      expect(p.createdAt, isNull);
      expect(p.settledAt, isNull);
    });
    test('fromJson 全字段缺省 → 默认值不抛', () {
      final p = AgentPayoutDto.fromJson(<String, dynamic>{});
      expect(p.id, 0);
      expect(p.amountCents, 0);
      expect(p.dest, '');
      expect(p.status, '');
      expect(p.txid, isNull);
      expect(p.createdAt, isNull);
      expect(p.settledAt, isNull);
    });
    test('fromJson 浮点金额 → toInt 降级', () {
      final p = AgentPayoutDto.fromJson({'id': 1.0, 'amount_cents': 1500.0});
      expect(p.id, 1);
      expect(p.amountCents, 1500);
    });
  });

  group('AgentPricesDto', () {
    test('fromJson 解析 tier + 平台价/拿货价/最低售价/custom', () {
      final d = AgentPricesDto.fromJson({
        'tier': 'reseller',
        'prices': [
          {
            'plan_id': 'monthly',
            'list_cents': 600,
            'wholesale_cents': 390,
            'minimum_sale_cents': 480,
            'floor_cents': 480,
            'price_cents': 500,
          },
          {
            'plan_id': 'yearly',
            'list_cents': 4900,
            'wholesale_cents': 3185,
            'minimum_sale_cents': 3920,
            'floor_cents': 3920,
          },
        ],
      });
      expect(d.tier, 'reseller');
      expect(d.prices.length, 2);
      expect(d.prices[0].planId, 'monthly');
      expect(d.prices[0].listCents, 600);
      expect(d.prices[0].wholesaleCents, 390);
      expect(d.prices[0].floorCents, 480);
      expect(d.prices[0].customCents, 500);
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
        'enabled': true,
        'claimed': false,
        'days': 3,
        'traffic_gb': 10,
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
          {
            'id': 1,
            'kind': 'referral_reward',
            'amount_cents': 200,
            'usable_cents': 200,
            'expires_at': '2026-12-01T00:00:00Z',
          },
          {
            'id': 2,
            'kind': 'manual',
            'amount_cents': 150,
            'usable_cents': 150,
            'expires_at': null,
          },
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
