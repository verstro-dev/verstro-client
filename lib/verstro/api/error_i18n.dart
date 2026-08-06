import 'package:fl_clash/common/app_localizations.dart';

/// 后端业务错误 code → 本地化文案。未知码返回 null，由上层落 HTTP 状态兜底。
/// 后端保持 locale-agnostic，中文 message 仅作未知码的理论兜底（正常流程不出现）。
String? localizedBusinessError(String code) {
  final l = appLocalizations;
  switch (code) {
    // 复用既有 vApi* 键
    case 'email_taken':
      return l.vApiEmailTaken;
    case 'invalid_credentials':
      return l.vApiInvalidCredentials;
    case 'token_expired':
      return l.vApiTokenExpired;
    case 'invalid_token':
      return l.vApiTokenInvalid;
    case 'unauthorized':
      return l.vApiUnauthorized;
    // 新增 vErr* 键
    case 'code_expired':
      return l.vErrCodeExpired;
    case 'code_locked':
      return l.vErrCodeLocked;
    case 'duplicate_code':
      return l.vErrDuplicateCode;
    case 'email_unverified':
      return l.vErrEmailUnverified;
    case 'expired':
      return l.vErrSubExpired;
    case 'has_subscription':
      return l.vErrHasSubscription;
    case 'invalid_code':
      return l.vErrInvalidCode;
    case 'invalid_dest':
      return l.vErrInvalidDest;
    case 'invalid_plan':
      return l.vErrInvalidPlan;
    case 'invalid_referral_code':
      return l.vErrInvalidReferralCode;
    case 'price_changed':
    case 'plan_version_changed':
    case 'plan_confirmation_required':
    case 'plan_version_unavailable':
      return l.vPlanPriceChanged;
    case 'partner_plan_sales_paused':
      return l.vPlanPartnerSalesPaused;
    case 'set_price_failed':
      return l.vAgentPriceSetFailed;
    case 'invalid_tx_hash':
      return l.vErrInvalidTxHash;
    case 'missing_code':
      return l.vErrMissingCode;
    case 'no_subscription':
      return l.vErrNoSubscription;
    case 'provision_failed':
      return l.vErrProvisionFailed;
    case 'sub_proxy_disabled':
      return l.vErrSubProxyDisabled;
    case 'token_used':
      return l.vErrTokenUsed;
    case 'trial_claimed':
      return l.vErrTrialClaimed;
    case 'trial_disabled':
      return l.vErrTrialDisabled;
    // invalid_coupon 的 reason_code 细分子码 (Task 7)
    case 'coupon_invalid':
      return l.vErrCouponInvalid;
    case 'coupon_disabled':
      return l.vErrCouponDisabled;
    case 'coupon_inactive':
      return l.vErrCouponInactive;
    case 'coupon_plan_mismatch':
      return l.vErrCouponPlanMismatch;
    case 'coupon_new_users_only':
      return l.vErrCouponNewUsersOnly;
    case 'coupon_limit_reached':
      return l.vErrCouponLimitReached;
    case 'coupon_sold_out':
      return l.vErrCouponSoldOut;
    case 'coupon_partner_price_conflict':
      return l.vErrCouponPartnerPriceConflict;
    case 'card_sales_disabled':
    case 'membership_cards_unavailable':
      return l.vCardUnavailableSales;
    case 'card_bulk_purchase_disabled':
      return l.vCardUnavailableBulk;
    case 'card_quote_changed':
      return l.vCardErrQuoteChanged;
    case 'card_open_order_limit':
      return l.vCardErrOpenOrderLimit;
    case 'membership_card_wholesale_self_redemption_forbidden':
      return l.vCardErrWholesaleSelf;
    case 'membership_card_redemption_frozen':
      return l.vCardErrRedemptionFrozen;
    case 'membership_card_preview_expired':
      return l.vCardErrPreviewExpired;
    case 'membership_card_preview_consumed':
      return l.vCardErrPreviewConsumed;
    case 'membership_card_schedule_changed':
      return l.vCardErrScheduleChanged;
    case 'card_reveal_auth_required':
      return l.vCardErrRevealAuth;
    case 'card_reveal_grant_expired':
      return l.vCardErrRevealExpired;
    case 'card_invalid_or_unavailable':
      return l.vCardErrUnavailable;
    case 'card_export_unavailable':
      return l.vCardErrExportUnavailable;
    default:
      return null;
  }
}

/// 业务错误展示文案: 已知 code → 本地化; 否则后端 message(为空则 null, 交给上层兜底)。
/// 抽成纯函数是为了 [BackendApi._translateBusinessError] 里对每个 HTTP 状态分支
/// 复用同一套 "本地化优先, 否则后端 message, 否则兜底" 逻辑, 同时便于单测直接覆盖
/// 4xx/5xx 各分支不再需要真的构造 BackendApi/Dio。
String? businessErrorMessage(String code, String backendMessage) {
  final localized = localizedBusinessError(code);
  if (localized != null) return localized;
  return backendMessage.isEmpty ? null : backendMessage;
}
