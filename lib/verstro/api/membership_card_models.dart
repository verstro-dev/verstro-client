// Verstro 会员卡 API 模型。
//
// 定价、买家档位、卡类和权益排期均是服务端权威事实；
// App 只解析和展示，不在本地重算价格或档位。

enum MembershipCardClass {
  retailGift('retail_gift'),
  wholesaleInventory('wholesale_inventory');

  const MembershipCardClass(this.value);
  final String value;

  static MembershipCardClass fromJson(String value) => switch (value) {
    'retail_gift' => MembershipCardClass.retailGift,
    'wholesale_inventory' => MembershipCardClass.wholesaleInventory,
    _ => throw FormatException('unknown membership card class: $value'),
  };
}

int _int(Map<String, dynamic> json, String key) =>
    (json[key] as num?)?.toInt() ?? 0;

String _string(Map<String, dynamic> json, String key) =>
    json[key] as String? ?? '';

DateTime? _date(Map<String, dynamic> json, String key) {
  final raw = json[key] as String?;
  return raw == null || raw.isEmpty ? null : DateTime.parse(raw).toUtc();
}

List<Map<String, dynamic>> _maps(dynamic value) => (value as List? ?? const [])
    .whereType<Map>()
    .map((item) => Map<String, dynamic>.from(item))
    .toList(growable: false);

class MembershipCardCartItem {
  const MembershipCardCartItem({required this.planId, required this.quantity});

  final String planId;
  final int quantity;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'plan_id': planId,
    'quantity': quantity,
  };
}

class MembershipCardQuoteItem {
  const MembershipCardQuoteItem({
    required this.planVersionId,
    required this.planId,
    required this.planName,
    required this.durationDays,
    required this.trafficLimitBytes,
    required this.maxDevices,
    required this.squadTier,
    required this.manualNodeSelection,
    required this.quantity,
    required this.listUnitCents,
    required this.saleUnitCents,
    required this.lineListTotalCents,
    required this.lineTotalCents,
  });

  factory MembershipCardQuoteItem.fromJson(Map<String, dynamic> json) =>
      MembershipCardQuoteItem(
        planVersionId: _int(json, 'plan_version_id'),
        planId: _string(json, 'plan_id'),
        planName: _string(json, 'plan_name'),
        durationDays: _int(json, 'duration_days'),
        trafficLimitBytes: _int(json, 'traffic_limit_bytes'),
        maxDevices: _int(json, 'max_devices'),
        squadTier: _string(json, 'squad_tier'),
        manualNodeSelection: json['manual_node_selection'] == true,
        quantity: _int(json, 'quantity'),
        listUnitCents: _int(json, 'list_unit_cents'),
        saleUnitCents: _int(json, 'sale_unit_cents'),
        lineListTotalCents: _int(json, 'line_list_total_cents'),
        lineTotalCents: _int(json, 'line_total_cents'),
      );

  final int planVersionId;
  final String planId;
  final String planName;
  final int durationDays;
  final int trafficLimitBytes;
  final int maxDevices;
  final String squadTier;
  final bool manualNodeSelection;
  final int quantity;
  final int listUnitCents;
  final int saleUnitCents;
  final int lineListTotalCents;
  final int lineTotalCents;
}

class MembershipCardQuote {
  const MembershipCardQuote({
    required this.cardClass,
    required this.buyerTier,
    required this.costBps,
    required this.cardCount,
    required this.itemCount,
    required this.listTotalCents,
    required this.goodsTotalCents,
    required this.cashBackedCreditAvailableCents,
    required this.cashBackedCreditAppliedCents,
    required this.cashDueCents,
    required this.planReleaseVersion,
    required this.membershipCardConfigReleaseId,
    required this.membershipCardConfigVersion,
    required this.commerceConfigVersion,
    required this.items,
    required this.quoteHash,
  });

  factory MembershipCardQuote.fromJson(Map<String, dynamic> json) =>
      MembershipCardQuote(
        cardClass: MembershipCardClass.fromJson(_string(json, 'card_class')),
        buyerTier: _string(json, 'buyer_tier'),
        costBps: _int(json, 'cost_bps'),
        cardCount: _int(json, 'card_count'),
        itemCount: _int(json, 'item_count'),
        listTotalCents: _int(json, 'list_total_cents'),
        goodsTotalCents: _int(json, 'goods_total_cents'),
        cashBackedCreditAvailableCents: _int(
          json,
          'cash_backed_credit_available_cents',
        ),
        cashBackedCreditAppliedCents: _int(
          json,
          'cash_backed_credit_applied_cents',
        ),
        cashDueCents: _int(json, 'cash_due_cents'),
        planReleaseVersion: _int(json, 'plan_release_version'),
        membershipCardConfigReleaseId: _int(
          json,
          'membership_card_config_release_id',
        ),
        membershipCardConfigVersion: _int(
          json,
          'membership_card_config_version',
        ),
        commerceConfigVersion: _int(json, 'commerce_config_version'),
        items: _maps(
          json['items'],
        ).map(MembershipCardQuoteItem.fromJson).toList(growable: false),
        quoteHash: _string(json, 'quote_hash'),
      );

  final MembershipCardClass cardClass;
  final String buyerTier;
  final int costBps;
  final int cardCount;
  final int itemCount;
  final int listTotalCents;
  final int goodsTotalCents;
  final int cashBackedCreditAvailableCents;
  final int cashBackedCreditAppliedCents;
  final int cashDueCents;
  final int planReleaseVersion;
  final int membershipCardConfigReleaseId;
  final int membershipCardConfigVersion;
  final int commerceConfigVersion;
  final List<MembershipCardQuoteItem> items;
  final String quoteHash;

  String get pricingCopyKey {
    if (buyerTier == 'master') return 'vCardPriceMaster';
    if (buyerTier == 'reseller') return 'vCardPriceReseller';
    if (buyerTier == 'promoter') return 'vCardPricePromoter';
    if (cardClass == MembershipCardClass.wholesaleInventory) {
      return 'vCardPriceBulkRetail';
    }
    return 'vCardPriceRetail';
  }

  List<String> get purchaseWarningKeys =>
      cardClass == MembershipCardClass.wholesaleInventory
      ? const <String>['vCardWarningWholesaleSelf']
      : const <String>[];
}

class MembershipCardOrder {
  const MembershipCardOrder({
    required this.id,
    required this.cardClass,
    required this.buyerTier,
    required this.paymentState,
    required this.issuanceState,
    required this.cardCount,
    required this.listTotalCents,
    required this.goodsTotalCents,
    required this.cashBackedCreditAppliedCents,
    required this.finalAmountCents,
    required this.depositAddress,
    required this.txid,
    required this.createdAt,
    required this.expiresAt,
    required this.paidAt,
    required this.items,
  });

  factory MembershipCardOrder.fromJson(Map<String, dynamic> json) =>
      MembershipCardOrder(
        id: _int(json, 'id'),
        cardClass: MembershipCardClass.fromJson(_string(json, 'card_class')),
        buyerTier: _string(json, 'buyer_tier'),
        paymentState: _string(json, 'payment_state'),
        issuanceState: _string(json, 'issuance_state'),
        cardCount: _int(json, 'card_count'),
        listTotalCents: _int(json, 'list_total_cents'),
        goodsTotalCents: _int(json, 'goods_total_cents'),
        cashBackedCreditAppliedCents: _int(
          json,
          'cash_backed_credit_applied_cents',
        ),
        finalAmountCents: _int(json, 'final_amount_cents'),
        depositAddress: _string(json, 'deposit_address'),
        txid: _string(json, 'txid'),
        createdAt: _date(json, 'created_at')!,
        expiresAt: _date(json, 'expires_at')!,
        paidAt: _date(json, 'paid_at'),
        items: _maps(
          json['items'],
        ).map(MembershipCardQuoteItem.fromJson).toList(growable: false),
      );

  final int id;
  final MembershipCardClass cardClass;
  final String buyerTier;
  final String paymentState;
  final String issuanceState;
  final int cardCount;
  final int listTotalCents;
  final int goodsTotalCents;
  final int cashBackedCreditAppliedCents;
  final int finalAmountCents;
  final String depositAddress;
  final String txid;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? paidAt;
  final List<MembershipCardQuoteItem> items;

  bool get isIssued => issuanceState == 'succeeded';
  bool get isWaiting => paymentState == 'waiting';
  bool get isTerminal => isIssued || paymentState == 'expired';
}

class MembershipCardOrderResult {
  const MembershipCardOrderResult({
    required this.order,
    required this.replayed,
  });

  factory MembershipCardOrderResult.fromJson(Map<String, dynamic> json) =>
      MembershipCardOrderResult(
        order: MembershipCardOrder.fromJson(
          Map<String, dynamic>.from(json['order'] as Map),
        ),
        replayed: json['replayed'] == true,
      );

  final MembershipCardOrder order;
  final bool replayed;
}

class MembershipCardInventoryItem {
  const MembershipCardInventoryItem({
    required this.id,
    required this.planId,
    required this.planName,
    required this.maskedCode,
    required this.state,
    required this.issuanceType,
    required this.redeemBefore,
    required this.revealCount,
    required this.lastRevealedAt,
    required this.createdAt,
  });

  factory MembershipCardInventoryItem.fromJson(Map<String, dynamic> json) =>
      MembershipCardInventoryItem(
        id: _string(json, 'id'),
        planId: _string(json, 'plan_id'),
        planName: _string(json, 'plan_name'),
        maskedCode: _string(json, 'masked_code'),
        state: _string(json, 'state'),
        issuanceType: _string(json, 'issuance_type'),
        redeemBefore: _date(json, 'redeem_before'),
        revealCount: _int(json, 'reveal_count'),
        lastRevealedAt: _date(json, 'last_revealed_at'),
        createdAt: _date(json, 'created_at')!,
      );

  final String id;
  final String planId;
  final String planName;
  final String maskedCode;
  final String state;
  final String issuanceType;
  final DateTime? redeemBefore;
  final int revealCount;
  final DateTime? lastRevealedAt;
  final DateTime createdAt;

  bool get isAvailable => state == 'available';
  bool get revealRequiresRefundWarning => issuanceType == 'paid';
}

class MembershipCardRevealGrant {
  const MembershipCardRevealGrant({
    required this.token,
    required this.purpose,
    required this.expiresAt,
    required this.remainingUses,
  });

  factory MembershipCardRevealGrant.fromJson(Map<String, dynamic> json) =>
      MembershipCardRevealGrant(
        token: _string(json, 'token'),
        purpose: _string(json, 'purpose'),
        expiresAt: _date(json, 'expires_at')!,
        remainingUses: _int(json, 'remaining_uses'),
      );

  final String token;
  final String purpose;
  final DateTime expiresAt;
  final int remainingUses;
}

class MembershipCardRevealResult {
  const MembershipCardRevealResult({
    required this.cardId,
    required this.code,
    required this.state,
  });

  factory MembershipCardRevealResult.fromJson(Map<String, dynamic> json) =>
      MembershipCardRevealResult(
        cardId: _string(json, 'card_id'),
        code: _string(json, 'code'),
        state: _string(json, 'state'),
      );

  final String cardId;
  final String code;
  final String state;
}

class MembershipCardEntitlementSnapshot {
  const MembershipCardEntitlementSnapshot({
    required this.planVersionId,
    required this.planId,
    required this.planName,
    required this.durationDays,
    required this.trafficLimitBytes,
    required this.maxDevices,
    required this.squadTier,
    required this.manualNodeSelection,
  });

  factory MembershipCardEntitlementSnapshot.fromJson(
    Map<String, dynamic> json,
  ) => MembershipCardEntitlementSnapshot(
    planVersionId: _int(json, 'plan_version_id'),
    planId: _string(json, 'plan_id'),
    planName: _string(json, 'plan_name'),
    durationDays: _int(json, 'duration_days'),
    trafficLimitBytes: _int(json, 'traffic_limit_bytes'),
    maxDevices: _int(json, 'max_devices'),
    squadTier: _string(json, 'squad_tier'),
    manualNodeSelection: json['manual_node_selection'] == true,
  );

  final int planVersionId;
  final String planId;
  final String planName;
  final int durationDays;
  final int trafficLimitBytes;
  final int maxDevices;
  final String squadTier;
  final bool manualNodeSelection;
}

class MembershipCardRedemptionPreview {
  const MembershipCardRedemptionPreview({
    required this.previewToken,
    required this.maskedCode,
    required this.entitlement,
    required this.activationMode,
    required this.scheduledFor,
    required this.expiresAt,
  });

  factory MembershipCardRedemptionPreview.fromJson(Map<String, dynamic> json) =>
      MembershipCardRedemptionPreview(
        previewToken: _string(json, 'preview_token'),
        maskedCode: _string(json, 'masked_code'),
        entitlement: MembershipCardEntitlementSnapshot.fromJson(
          Map<String, dynamic>.from(json['entitlement'] as Map),
        ),
        activationMode: _string(json, 'activation_mode'),
        scheduledFor: _date(json, 'scheduled_for'),
        expiresAt: _date(json, 'expires_at')!,
      );

  final String previewToken;
  final String maskedCode;
  final MembershipCardEntitlementSnapshot entitlement;
  final String activationMode;
  final DateTime? scheduledFor;
  final DateTime expiresAt;
}

Map<String, dynamic> buildMembershipCardConfirmBody(
  Map<String, dynamic> preview,
) => <String, dynamic>{
  'preview_token': preview['preview_token'] as String? ?? '',
};

class MembershipCardRedemptionResult {
  const MembershipCardRedemptionResult({
    required this.id,
    required this.cardId,
    required this.state,
    required this.activationMode,
    required this.scheduledFor,
    required this.attributionResult,
    required this.entitlement,
    required this.acceptedAt,
    required this.replayed,
  });

  factory MembershipCardRedemptionResult.fromJson(Map<String, dynamic> json) {
    final payload = json['result'] is Map
        ? Map<String, dynamic>.from(json['result'] as Map)
        : json;
    return MembershipCardRedemptionResult(
      id: _string(payload, 'id'),
      cardId: _string(payload, 'card_id'),
      state: _string(payload, 'state'),
      activationMode: _string(payload, 'activation_mode'),
      scheduledFor: _date(payload, 'scheduled_for'),
      attributionResult: _string(payload, 'attribution_result'),
      entitlement: MembershipCardEntitlementSnapshot.fromJson(
        Map<String, dynamic>.from(payload['entitlement'] as Map),
      ),
      acceptedAt: _date(payload, 'accepted_at')!,
      replayed: payload['replayed'] == true || json['replayed'] == true,
    );
  }

  final String id;
  final String cardId;
  final String state;
  final String activationMode;
  final DateTime? scheduledFor;
  final String attributionResult;
  final MembershipCardEntitlementSnapshot entitlement;
  final DateTime acceptedAt;
  final bool replayed;
}

class MembershipEntitlementTimelineItem {
  const MembershipEntitlementTimelineItem({
    required this.grantId,
    required this.sourceKind,
    required this.sourceOrderId,
    required this.sourceCardId,
    required this.planId,
    required this.planName,
    required this.squadTier,
    required this.status,
    required this.startsAt,
    required this.activeUntil,
    required this.remainingServiceSeconds,
    required this.quotaBytes,
    required this.consumedBytes,
  });

  factory MembershipEntitlementTimelineItem.fromJson(
    Map<String, dynamic> json,
  ) => MembershipEntitlementTimelineItem(
    grantId: _int(json, 'grant_id'),
    sourceKind: _string(json, 'source_kind'),
    sourceOrderId: json['source_order_id'] == null
        ? null
        : _int(json, 'source_order_id'),
    sourceCardId: json['source_card_id'] as String?,
    planId: _string(json, 'plan_id'),
    planName: _string(json, 'plan_name'),
    squadTier: _string(json, 'squad_tier'),
    status: _string(json, 'status'),
    startsAt: _date(json, 'starts_at')!,
    activeUntil: _date(json, 'active_until')!,
    remainingServiceSeconds: _int(json, 'remaining_service_seconds'),
    quotaBytes: _int(json, 'quota_bytes'),
    consumedBytes: _int(json, 'consumed_bytes'),
  );

  final int grantId;
  final String sourceKind;
  final int? sourceOrderId;
  final String? sourceCardId;
  final String planId;
  final String planName;
  final String squadTier;
  final String status;
  final DateTime startsAt;
  final DateTime activeUntil;
  final int remainingServiceSeconds;
  final int quotaBytes;
  final int consumedBytes;
}

class MembershipEntitlementTimeline {
  const MembershipEntitlementTimeline({
    required this.current,
    required this.pending,
  });

  factory MembershipEntitlementTimeline.fromJson(Map<String, dynamic> json) =>
      MembershipEntitlementTimeline(
        current: _maps(json['current'])
            .map(MembershipEntitlementTimelineItem.fromJson)
            .toList(growable: false),
        pending: _maps(json['pending'])
            .map(MembershipEntitlementTimelineItem.fromJson)
            .toList(growable: false),
      );

  final List<MembershipEntitlementTimelineItem> current;
  final List<MembershipEntitlementTimelineItem> pending;
}

String? membershipCardErrorKey(String code) => switch (code) {
  'card_sales_disabled' ||
  'membership_cards_unavailable' => 'vCardUnavailableSales',
  'card_bulk_purchase_disabled' => 'vCardUnavailableBulk',
  'card_quote_changed' => 'vCardErrQuoteChanged',
  'card_open_order_limit' => 'vCardErrOpenOrderLimit',
  'membership_card_wholesale_self_redemption_forbidden' =>
    'vCardErrWholesaleSelf',
  'membership_card_redemption_frozen' => 'vCardErrRedemptionFrozen',
  'membership_card_preview_expired' => 'vCardErrPreviewExpired',
  'membership_card_preview_consumed' => 'vCardErrPreviewConsumed',
  'membership_card_schedule_changed' => 'vCardErrScheduleChanged',
  'card_reveal_auth_required' => 'vCardErrRevealAuth',
  'card_reveal_grant_expired' => 'vCardErrRevealExpired',
  'card_invalid_or_unavailable' => 'vCardErrUnavailable',
  'card_export_unavailable' => 'vCardErrExportUnavailable',
  _ => null,
};
