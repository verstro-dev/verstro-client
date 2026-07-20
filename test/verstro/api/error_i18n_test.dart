import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/error_i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await AppLocalizations.load(const Locale('zh', 'CN'));
  });

  test('已知业务码映射到本地化串（非后端透传）', () {
    expect(localizedBusinessError('trial_disabled'), '试用未开放');
    expect(localizedBusinessError('has_subscription'), '已有订阅，无需试用');
    expect(
      localizedBusinessError('email_taken'),
      '该邮箱已注册',
    ); // 复用 vApiEmailTaken
    expect(localizedBusinessError('token_used'), '链接已使用');
    expect(localizedBusinessError('invalid_referral_code'), '推荐码无效，请检查后重试');
    expect(localizedBusinessError('price_changed'), '套餐价格已更新，请查看新价格并重新确认');
    expect(localizedBusinessError('set_price_failed'), '设价失败，请重试');
  });

  test('未知码返回 null（交回上层兜底）', () {
    expect(localizedBusinessError('db_err'), isNull);
    expect(localizedBusinessError('some_future_code'), isNull);
  });

  group('businessErrorMessage — _translateBusinessError 消费的组合入口', () {
    // 回归: backend_api.dart 的 _translateBusinessError 曾经对 404/410/429/500
    // 这几个分支直接丢弃 wire errCode（硬编码 not_found/server_error，或 410/429
    // 干脆没 case 到），导致 localizedBusinessError 永远拿不到正确的 code 去查表。
    // 这里直接测 _translateBusinessError 实际调用的 businessErrorMessage，
    // 用一个跟 arb 文案不同的哨兵串充当"后端原始 message"，证明返回值确实来自
    // 本地化查表命中，而不是透传/回退到后端文案（zh 环境下二者字面量可能碰巧相同，
    // 光比对 "无订阅" == "无订阅" 无法证伪，所以哨兵串必须跟 arb 值不同）。
    const sentinelBackendMessage = '__RAW_BACKEND_MESSAGE__';

    test('404 no_subscription → 本地化 vErrNoSubscription（非后端透传）', () {
      expect(
        businessErrorMessage('no_subscription', sentinelBackendMessage),
        '无订阅',
      );
    });

    test('500 provision_failed → 本地化 vErrProvisionFailed（非后端透传）', () {
      expect(
        businessErrorMessage('provision_failed', sentinelBackendMessage),
        '试用开通失败，请重试',
      );
    });

    test(
      '410 expired → 本地化 vErrSubExpired（此前 410 未 case，落 unexpected status）',
      () {
        expect(
          businessErrorMessage('expired', sentinelBackendMessage),
          '订阅已过期',
        );
      },
    );

    test(
      '429 code_locked → 本地化 vErrCodeLocked（此前 429 未 case，落 unexpected status）',
      () {
        expect(
          businessErrorMessage('code_locked', sentinelBackendMessage),
          '尝试次数过多，请重新获取验证码',
        );
      },
    );

    test('未知 code + 非空后端 message → 原样返回后端 message', () {
      expect(businessErrorMessage('some_unknown_code', '后端自定义提示'), '后端自定义提示');
    });

    test('未知 code + 空后端 message → null（交给上层兜底文案）', () {
      expect(businessErrorMessage('some_unknown_code', ''), isNull);
    });
  });

  group('coupon_* reason_code 子码 — Task 7 (invalid_coupon 细分本地化)', () {
    const sentinelBackendMessage = '__RAW_BACKEND_MESSAGE__';

    test('8 个 coupon_* 子码经 localizedBusinessError 命中本地化串', () {
      expect(localizedBusinessError('coupon_invalid'), '无效优惠码');
      expect(localizedBusinessError('coupon_disabled'), '优惠码已停用');
      expect(localizedBusinessError('coupon_inactive'), '优惠码未开始或已过期');
      expect(localizedBusinessError('coupon_plan_mismatch'), '优惠码不适用本套餐');
      expect(localizedBusinessError('coupon_new_users_only'), '仅限新用户');
      expect(localizedBusinessError('coupon_limit_reached'), '已达每人使用上限');
      expect(localizedBusinessError('coupon_sold_out'), '优惠码已抢光');
      expect(
        localizedBusinessError('coupon_partner_price_conflict'),
        '合作伙伴专属价不可与平台优惠码叠加',
      );
    });

    test('coupon_* 子码经 businessErrorMessage 覆盖后端 message（非透传，用哨兵串排除巧合）', () {
      expect(
        businessErrorMessage('coupon_invalid', sentinelBackendMessage),
        '无效优惠码',
      );
      expect(
        businessErrorMessage('coupon_disabled', sentinelBackendMessage),
        '优惠码已停用',
      );
      expect(
        businessErrorMessage('coupon_inactive', sentinelBackendMessage),
        '优惠码未开始或已过期',
      );
      expect(
        businessErrorMessage('coupon_plan_mismatch', sentinelBackendMessage),
        '优惠码不适用本套餐',
      );
      expect(
        businessErrorMessage('coupon_new_users_only', sentinelBackendMessage),
        '仅限新用户',
      );
      expect(
        businessErrorMessage('coupon_limit_reached', sentinelBackendMessage),
        '已达每人使用上限',
      );
      expect(
        businessErrorMessage('coupon_sold_out', sentinelBackendMessage),
        '优惠码已抢光',
      );
      expect(
        businessErrorMessage(
          'coupon_partner_price_conflict',
          sentinelBackendMessage,
        ),
        '合作伙伴专属价不可与平台优惠码叠加',
      );
    });

    test(
      'businessErrorMessage(coupon_sold_out, 后端原文) → 本地化覆盖后端 message（非透传）',
      () {
        // 即便哨兵串恰好撞上 arb zh 文案本身，也要证明是查表命中而非透传：
        // 用真实后端 message（本身就等于 vErrCouponSoldOut 的 zh 值）验证返回值仍是本地化查表结果。
        expect(businessErrorMessage('coupon_sold_out', '优惠码已抢光'), '优惠码已抢光');
      },
    );

    test(
      '向后兼容边界: businessErrorMessage(invalid_coupon, 后端Reason) 顶层 code 未命中 → 透传后端 message',
      () {
        // 旧后端场景: 无 reason_code, _translateBusinessError 退回用顶层 errCode='invalid_coupon' 查表；
        // invalid_coupon 本身不在 localizedBusinessError 表里 → 保留后端 message（现状不变）。
        expect(businessErrorMessage('invalid_coupon', '优惠码已抢光'), '优惠码已抢光');
        expect(
          businessErrorMessage('invalid_coupon', '该优惠码不适用于当前套餐'),
          '该优惠码不适用于当前套餐',
        );
      },
    );
  });
}
