import 'package:fl_clash/verstro/api/account_entitlement_models.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/util/purchase_route.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _item({
  int id = 1,
  String status = 'expired',
  String tier = 'standard',
  String source = 'order',
  int remainingBytes = 0,
  int remainingSeconds = 0,
}) => {
  'grant_id': id,
  'source_kind': source,
  'source_order_id': id + 10,
  'plan_id': 'monthly',
  'plan_name': '标准·月付',
  'squad_tier': tier,
  'status': status,
  'starts_at': '2026-01-01T00:00:00Z',
  'active_until': '2026-02-01T00:00:00Z',
  'remaining_service_seconds': remainingSeconds,
  'quota_bytes': 1024,
  'consumed_bytes': 1024 - remainingBytes,
  'remaining_bytes': remainingBytes,
  'is_estimated': false,
};

AccountEntitlements _snapshot({
  String service = 'expired',
  List<Map<String, dynamic>> current = const [],
  List<Map<String, dynamic>> pending = const [],
}) => AccountEntitlements.fromJson({
  'as_of': '2026-09-18T00:00:00Z',
  'revision': 'rev-1',
  'history_revision': 'href-1',
  'current_service': {'status': service},
  'current': current,
  'pending': pending,
  'history': <Map<String, dynamic>>[],
  'next_history_cursor': null,
  'conversion_capability': <String, dynamic>{},
});

void main() {
  test('过期且无剩余权益：普通复购，不展示独立购买', () {
    final expired = _snapshot(
      current: [
        _item(status: 'expired', remainingBytes: 0, remainingSeconds: 0),
      ],
    );
    final decision = classifyPurchaseRoute(
      targetTier: 'standard',
      snapshot: expired,
    );
    expect(decision.kind, PurchaseRouteKind.first);
    expect(decision.independentVisible, isFalse);
    expect(independentPurchaseVisible(expired), isFalse);
    expect(purchaseNeedsUpgrade(_plan('standard'), expired), isFalse);
  });

  test('有剩余标准权益买专业：升档，展示次要独立购买', () {
    final active = _snapshot(
      service: 'active',
      current: [
        _item(
          status: 'active',
          remainingBytes: 100,
          remainingSeconds: 3600,
        ),
      ],
    );
    final decision = classifyPurchaseRoute(
      targetTier: 'premium',
      snapshot: active,
    );
    expect(decision.kind, PurchaseRouteKind.upgrade);
    expect(decision.independentVisible, isTrue);
    expect(purchaseNeedsUpgrade(_plan('premium'), active), isTrue);
    expect(purchaseNeedsUpgrade(_plan('standard'), active), isFalse);
  });

  test('快照不可核验：不自动下单，独立购买只作为显式确认', () {
    final unverified = _snapshot(service: 'legacy_unverified');
    final decision = classifyPurchaseRoute(
      targetTier: 'standard',
      snapshot: unverified,
    );
    expect(decision.kind, PurchaseRouteKind.unverified);
    expect(decision.independentVisible, isTrue);
    expect(independentPurchaseVisible(unverified), isTrue);
    expect(
      () => purchaseNeedsUpgrade(_plan('standard'), unverified),
      throwsFormatException,
    );
  });

  test('普通下单错误码映射稳定，不把独立购买当自动回退', () {
    expect(
      classifyPurchaseOrderError('entitlement_upgrade_required'),
      PurchaseOrderErrorKind.upgradeRequired,
    );
    expect(
      classifyPurchaseOrderError('purchase_entitlements_unverified'),
      PurchaseOrderErrorKind.entitlementsUnverified,
    );
    expect(
      classifyPurchaseOrderError('current_service_history_review_required'),
      PurchaseOrderErrorKind.historyReviewRequired,
    );
    expect(
      classifyPurchaseOrderError('price_changed'),
      PurchaseOrderErrorKind.priceChanged,
    );
    expect(
      classifyPurchaseOrderError('invalid_coupon'),
      PurchaseOrderErrorKind.invalidCoupon,
    );
    expect(classifyPurchaseOrderError('db_err'), PurchaseOrderErrorKind.other);
  });

  test('余额从优惠后应付预演抵扣，不再因 credit_allowed 拦截', () {
    expect(
      creditHonesty(
        purchaseBalanceCents: 200,
        creditAllowed: false,
        priceAfterDiscountCents: 450,
      ),
      const CreditHonesty(
        showBlockedNote: false,
        showPreviewDeduction: true,
        previewCreditCents: 200,
        previewPayableCents: 250,
      ),
    );
    expect(
      creditHonesty(
        purchaseBalanceCents: 200,
        creditAllowed: true,
        priceAfterDiscountCents: 450,
      ),
      const CreditHonesty(
        showBlockedNote: false,
        showPreviewDeduction: true,
        previewCreditCents: 200,
        previewPayableCents: 250,
      ),
    );
    expect(
      creditHonesty(
        purchaseBalanceCents: 0,
        creditAllowed: false,
        priceAfterDiscountCents: 450,
      ).showPreviewDeduction,
      isFalse,
    );
    expect(
      orderPaymentSplit(creditAppliedCents: 300, newPayCents: 247),
      const OrderPaymentSplit(creditCents: 300, newPayCents: 247),
    );
  });
}

PlanDto _plan(String tier) => PlanDto(
  id: 'monthly',
  name: '标准·月付',
  durationDays: 30,
  priceUsd: '6.00',
  trafficLimitBytes: 1024,
  squadTier: tier,
);
