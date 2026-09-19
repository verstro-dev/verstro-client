import '../api/account_entitlement_models.dart';
import '../api/api_models.dart';

enum PurchaseRouteKind { first, renewal, queued, upgrade, unverified }

enum PurchaseOrderErrorKind {
  upgradeRequired,
  entitlementsUnverified,
  historyReviewRequired,
  priceChanged,
  invalidCoupon,
  other,
}

class PurchaseRouteDecision {
  const PurchaseRouteDecision({
    required this.kind,
    required this.remainingRank,
  });

  final PurchaseRouteKind kind;
  final int remainingRank;

  /// 已核验且无剩余权益时隐藏；加载中/不可核验/仍有剩余时保留显式独立购买。
  bool get independentVisible =>
      kind == PurchaseRouteKind.unverified || remainingRank > 0;
}

class CreditHonesty {
  const CreditHonesty({
    required this.showBlockedNote,
    required this.showPreviewDeduction,
    required this.previewCreditCents,
    required this.previewPayableCents,
  });

  final bool showBlockedNote;
  final bool showPreviewDeduction;
  final int previewCreditCents;
  final int previewPayableCents;

  @override
  bool operator ==(Object other) =>
      other is CreditHonesty &&
      other.showBlockedNote == showBlockedNote &&
      other.showPreviewDeduction == showPreviewDeduction &&
      other.previewCreditCents == previewCreditCents &&
      other.previewPayableCents == previewPayableCents;

  @override
  int get hashCode => Object.hash(
    showBlockedNote,
    showPreviewDeduction,
    previewCreditCents,
    previewPayableCents,
  );
}

class OrderPaymentSplit {
  const OrderPaymentSplit({
    required this.creditCents,
    required this.newPayCents,
  });

  final int creditCents;
  final int newPayCents;

  bool get hasCredit => creditCents > 0;

  @override
  bool operator ==(Object other) =>
      other is OrderPaymentSplit &&
      other.creditCents == creditCents &&
      other.newPayCents == newPayCents;

  @override
  int get hashCode => Object.hash(creditCents, newPayCents);
}

const _tierRanks = {'standard': 1, 'premium': 2};

PurchaseRouteDecision classifyPurchaseRoute({
  required String targetTier,
  required AccountEntitlements snapshot,
}) {
  try {
    final remaining = remainingPaidRank(snapshot);
    final target = _tierRanks[targetTier] ?? 0;
    if (target == 0) {
      return PurchaseRouteDecision(
        kind: PurchaseRouteKind.unverified,
        remainingRank: remaining,
      );
    }
    if (remaining == 0) {
      return const PurchaseRouteDecision(
        kind: PurchaseRouteKind.first,
        remainingRank: 0,
      );
    }
    if (target > remaining) {
      return PurchaseRouteDecision(
        kind: PurchaseRouteKind.upgrade,
        remainingRank: remaining,
      );
    }
    if (target == remaining) {
      return PurchaseRouteDecision(
        kind: PurchaseRouteKind.renewal,
        remainingRank: remaining,
      );
    }
    return PurchaseRouteDecision(
      kind: PurchaseRouteKind.queued,
      remainingRank: remaining,
    );
  } on FormatException {
    return const PurchaseRouteDecision(
      kind: PurchaseRouteKind.unverified,
      remainingRank: 0,
    );
  }
}

/// 只依据权威档位及尚有剩余的已购权益决定购买路径，不用价格或 SKU 名猜测。
bool purchaseNeedsUpgrade(PlanDto plan, AccountEntitlements snapshot) {
  final decision = classifyPurchaseRoute(
    targetTier: plan.squadTier,
    snapshot: snapshot,
  );
  if (decision.kind == PurchaseRouteKind.unverified) {
    throw const FormatException(
      'Unknown purchase tier or entitlement revision',
    );
  }
  return decision.kind == PurchaseRouteKind.upgrade;
}

bool independentPurchaseVisible(AccountEntitlements? snapshot) {
  if (snapshot == null) return true;
  return classifyPurchaseRoute(
    targetTier: 'standard',
    snapshot: snapshot,
  ).independentVisible;
}

int remainingPaidRank(AccountEntitlements snapshot) {
  if (snapshot.revision.trim().isEmpty ||
      !const {
        'none',
        'active',
        'pending_sync',
        'expired',
        'exhausted',
      }.contains(snapshot.currentService.status) ||
      (const {
            'active',
            'pending_sync',
          }.contains(snapshot.currentService.status) &&
          snapshot.current.isEmpty &&
          snapshot.pending.isEmpty)) {
    throw const FormatException(
      'Unknown purchase tier or entitlement revision',
    );
  }
  var highest = 0;
  for (final item in [...snapshot.current, ...snapshot.pending]) {
    if (item.sourceKind == 'trial' ||
        const {
          'expired',
          'exhausted',
          'refunded',
          'converted',
          'revoked',
        }.contains(item.status)) {
      continue;
    }
    if (!const {
          'active',
          'scheduled',
          'paused',
          'activation_pending',
        }.contains(item.status) ||
        item.remainingBytes < 0 ||
        item.remainingServiceSeconds < 0) {
      throw const FormatException('Unknown entitlement state');
    }
    if (item.remainingBytes == 0 || item.remainingServiceSeconds == 0) {
      continue;
    }
    if (!const {
      'order',
      'card',
      'conversion',
      'legacy',
    }.contains(item.sourceKind)) {
      throw const FormatException('Unknown entitlement source');
    }
    final rank = _tierRanks[item.squadTier];
    if (rank == null) throw const FormatException('Unknown entitlement tier');
    if (rank > highest) highest = rank;
  }
  return highest;
}

PurchaseOrderErrorKind classifyPurchaseOrderError(String? code) {
  switch (code) {
    case 'entitlement_upgrade_required':
      return PurchaseOrderErrorKind.upgradeRequired;
    case 'purchase_entitlements_unverified':
      return PurchaseOrderErrorKind.entitlementsUnverified;
    case 'current_service_history_review_required':
      return PurchaseOrderErrorKind.historyReviewRequired;
    case 'price_changed':
    case 'plan_version_changed':
    case 'plan_confirmation_required':
    case 'plan_version_unavailable':
      return PurchaseOrderErrorKind.priceChanged;
    case 'invalid_coupon':
      return PurchaseOrderErrorKind.invalidCoupon;
    default:
      return PurchaseOrderErrorKind.other;
  }
}

CreditHonesty creditHonesty({
  required int purchaseBalanceCents,
  required bool? creditAllowed,
  required int priceAfterDiscountCents,
}) {
  final after = priceAfterDiscountCents < 0 ? 0 : priceAfterDiscountCents;
  final balance = purchaseBalanceCents < 0 ? 0 : purchaseBalanceCents;
  if (balance <= 0) {
    return CreditHonesty(
      showBlockedNote: false,
      showPreviewDeduction: false,
      previewCreditCents: 0,
      previewPayableCents: after,
    );
  }
  final applied = balance > after ? after : balance;
  return CreditHonesty(
    showBlockedNote: false,
    showPreviewDeduction: true,
    previewCreditCents: applied,
    previewPayableCents: after - applied,
  );
}

OrderPaymentSplit orderPaymentSplit({
  required int creditAppliedCents,
  required int newPayCents,
}) {
  return OrderPaymentSplit(
    creditCents: creditAppliedCents < 0 ? 0 : creditAppliedCents,
    newPayCents: newPayCents < 0 ? 0 : newPayCents,
  );
}

String? renewalServiceStatus(String status) {
  switch (status) {
    case 'expired':
    case 'exhausted':
    case 'none':
      return status;
    default:
      return null;
  }
}
