import 'dart:convert';

class EntitlementHistoryChanged implements Exception {
  const EntitlementHistoryChanged();
}

// 账户权益只读快照。缺失/无效数据必须抛错，不能伪装为零权益。
class AccountEntitlement {
  AccountEntitlement.fromJson(Map<String, dynamic> json)
    : grantId = json['grant_id'] as int,
      sourceKind = json['source_kind'] as String,
      sourceOrderId = json['source_order_id'] as int?,
      sourceCardId = json['source_card_id'] as String?,
      sourceConversionId = json['source_conversion_id'] as String?,
      sourceConversionPeriodId = json['source_conversion_period_id'] as int?,
      planId = json['plan_id'] as String,
      planName = json['plan_name'] as String,
      squadTier = json['squad_tier'] as String,
      status = json['status'] as String,
      historyReason = json['history_reason'] as String?,
      startsAt = DateTime.parse(json['starts_at'] as String),
      activeUntil = DateTime.parse(json['active_until'] as String),
      remainingServiceSeconds = json['remaining_service_seconds'] as int,
      quotaBytes = json['quota_bytes'] as int,
      consumedBytes = json['consumed_bytes'] as int,
      remainingBytes = json['remaining_bytes'] as int,
      isEstimated = json['is_estimated'] as bool,
      estimatedStartsAt = json['estimated_starts_at'] == null
          ? null
          : DateTime.parse(json['estimated_starts_at'] as String),
      estimatedEndsAt = json['estimated_ends_at'] == null
          ? null
          : DateTime.parse(json['estimated_ends_at'] as String);

  final String? historyReason;
  final int grantId;
  final String sourceKind;
  final int? sourceOrderId;
  final String? sourceCardId, sourceConversionId;
  final int? sourceConversionPeriodId;
  final String planId, planName, squadTier, status;
  final DateTime startsAt, activeUntil;
  final int remainingServiceSeconds, quotaBytes, consumedBytes, remainingBytes;
  final bool isEstimated;
  final DateTime? estimatedStartsAt, estimatedEndsAt;
}

class CurrentService {
  CurrentService.fromJson(Map<String, dynamic> json)
    : status = json['status'] as String,
      planId = json['plan_id'] as String? ?? '',
      squadTier = json['squad_tier'] as String? ?? '',
      maxDevices = json['max_devices'] as int? ?? 0,
      manualNodeSelection = json['manual_node_selection'] as bool? ?? false,
      remainingBytes = json['remaining_bytes'] as int? ?? 0,
      activeUntil = json['active_until'] == null
          ? null
          : DateTime.parse(json['active_until'] as String);
  final String status, planId, squadTier;
  final int maxDevices, remainingBytes;
  final bool manualNodeSelection;
  final DateTime? activeUntil;
}

class ConversionCapability {
  ConversionCapability.fromJson(Map<String, dynamic> json)
    : quoteSupported = json['quote_supported'] == true,
      executeSupported = json['execute_supported'] == true,
      reason = json['reason'] as String? ?? '';
  final bool quoteSupported, executeSupported;
  final String reason;
}

class AccountEntitlements {
  AccountEntitlements({
    required this.asOf,
    required this.revision,
    this.historyRevision = '',
    required this.currentService,
    required this.current,
    required this.pending,
    required this.history,
    required this.nextHistoryCursor,
    required this.conversionCapability,
    this.loadingMore = false,
    this.historyError = false,
    this.historyChanged = false,
  });

  factory AccountEntitlements.fromJson(Map<String, dynamic> json) =>
      AccountEntitlements(
        asOf: DateTime.parse(json['as_of'] as String),
        revision: json['revision'] as String,
        historyRevision: _historyRevision(json['history_revision']),
        currentService: CurrentService.fromJson(
          json['current_service'] as Map<String, dynamic>,
        ),
        current: _items(json['current']),
        pending: _items(json['pending']),
        history: _items(json['history']),
        nextHistoryCursor: json['next_history_cursor'] as String?,
        conversionCapability: ConversionCapability.fromJson(
          json['conversion_capability'] as Map<String, dynamic>,
        ),
      );

  static String _historyRevision(dynamic value) {
    if (value is! String || value.trim().isEmpty) {
      throw const FormatException('Missing entitlement history revision');
    }
    return value;
  }

  static List<AccountEntitlement> _items(dynamic list) => (list as List)
      .map(
        (value) => AccountEntitlement.fromJson(value as Map<String, dynamic>),
      )
      .toList(growable: false);
  final DateTime asOf;
  final String revision, historyRevision;
  final CurrentService currentService;
  final List<AccountEntitlement> current, pending, history;
  final String? nextHistoryCursor;
  final ConversionCapability conversionCapability;
  final bool loadingMore, historyError, historyChanged;

  AccountEntitlements withHistory({
    List<AccountEntitlement>? history,
    String? cursor,
    bool loadingMore = false,
    bool historyError = false,
    bool historyChanged = false,
    bool replaceCursor = false,
  }) => AccountEntitlements(
    asOf: asOf,
    revision: revision,
    historyRevision: historyRevision,
    currentService: currentService,
    current: current,
    pending: pending,
    history: history ?? this.history,
    nextHistoryCursor: replaceCursor ? cursor : nextHistoryCursor,
    conversionCapability: conversionCapability,
    loadingMore: loadingMore,
    historyError: historyError,
    historyChanged: historyChanged,
  );

  AccountEntitlements append(AccountEntitlements page) {
    _historyRevision(historyRevision);
    _historyRevision(page.historyRevision);
    if (historyRevision != page.historyRevision) {
      throw const EntitlementHistoryChanged();
    }
    // 游标只绑定历史修订，服务端负责拒绝历史漂移；当前服务允许随分页更新。
    final ids = history.map((item) => item.grantId).toSet();
    return page.withHistory(
      history: [
        ...history,
        ...page.history.where((item) => ids.add(item.grantId)),
      ],
      cursor: page.nextHistoryCursor,
      replaceCursor: true,
    );
  }

  String paymentState(int orderId) {
    final entries = [
      ...current,
      ...pending,
    ].where((item) => item.sourceOrderId == orderId);
    if (entries.any(
      (item) => item.status == 'scheduled' || item.status == 'paused',
    )) {
      return 'queued';
    }
    if (currentService.status == 'active' &&
        entries.any((item) => item.status == 'active')) {
      return 'active';
    }
    return 'sync_pending';
  }
}

// 金额和推荐完全由服务端生成；UI 不重新计算残值、不创建全价替代订单。
class EntitlementConversionQuote {
  EntitlementConversionQuote.fromJson(Map<String, dynamic> json)
    : _encodedJson = jsonEncode(json),
      asOf = DateTime.parse(json['as_of'] as String),
      expiresAt = DateTime.parse(json['expires_at'] as String),
      revision = json['revision'] as String,
      quoteToken = json['quote_token'] as String,
      recoverablePayments = (json['recoverable_payments'] as List? ?? const [])
          .cast<Map<String, dynamic>>(),
      sources = (json['sources'] as List).cast<Map<String, dynamic>>(),
      target = json['target'] as Map<String, dynamic>?,
      amounts = json['amounts'] as Map<String, dynamic>,
      before = json['before'] as Map<String, dynamic>,
      after = json['after'] as Map<String, dynamic>? ?? const {},
      conversionValueCents = json['conversion_value_cents'] as int,
      recommendationReason = json['recommendation_reason'] as String? ?? '',
      capability = ConversionCapability.fromJson(
        json['capability'] as Map<String, dynamic>,
      ) {
    void requireInts(Map<String, dynamic> value, List<String> keys) {
      if (keys.any((key) => value[key] is! int || (value[key] as int) < 0)) {
        throw const FormatException('invalid conversion quote amount');
      }
    }

    final paymentIds = <int>{};
    for (final payment in recoverablePayments) {
      requireInts(payment, ['order_id', 'available_cents']);
      if (payment['order_id'] == 0 ||
          payment['available_cents'] == 0 ||
          !paymentIds.add(payment['order_id'] as int)) {
        throw const FormatException('invalid recoverable payment');
      }
    }
    requireInts(amounts, [
      'conversion_value_cents',
      'account_credit_cents',
      'due_cents',
    ]);
    if (amounts.containsKey('carried_funding_cents')) {
      requireInts(amounts, ['carried_funding_cents']);
    }
    if ((amounts['carried_funding_cents'] as int? ?? 0) > 0) {
      requireInts(amounts, ['carried_from_order_id']);
      if (amounts['carried_from_order_id'] == 0) {
        throw const FormatException('missing carried payment');
      }
    }
    requireInts(before, ['remaining_seconds', 'remaining_bytes']);
    if (target != null) {
      requireInts(target!, [
        'plan_version_id',
        'quantity',
        'duration_days',
        'traffic_bytes',
        'base_price_cents',
        'discount_cents',
        'price_after_discount_cents',
      ]);
      requireInts(after, ['duration_days', 'traffic_bytes']);
      final price = target!['price_after_discount_cents'] as int;
      if (target!['quantity'] == 0 ||
          target!['plan_version_id'] == 0 ||
          price < amounts['conversion_value_cents'] ||
          target!['base_price_cents'] - target!['discount_cents'] != price ||
          price !=
              amounts['conversion_value_cents'] +
                  (amounts['carried_funding_cents'] ?? 0) +
                  amounts['account_credit_cents'] +
                  amounts['due_cents']) {
        throw const FormatException('inconsistent conversion price');
      }
    }
    for (final source in sources) {
      requireInts(source, [
        'purchase_value_cents',
        'remaining_seconds',
        'remaining_bytes',
        'total_seconds',
        'total_bytes',
      ]);
    }
  }
  final String _encodedJson;
  Map<String, dynamic> toJson() =>
      jsonDecode(_encodedJson) as Map<String, dynamic>;
  final DateTime asOf, expiresAt;
  final String revision, quoteToken, recommendationReason;
  final List<Map<String, dynamic>> sources, recoverablePayments;
  final Map<String, dynamic>? target;
  final Map<String, dynamic> amounts, before, after;
  final int conversionValueCents;
  final ConversionCapability capability;
}

/// 服务端持久换购资源，失败或坏响应绝不能被解释为已完成。
class EntitlementConversion {
  EntitlementConversion.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      status = json['status'] as String,
      revision = json['revision'] as int,
      quote = EntitlementConversionQuote.fromJson(
        json['quote'] as Map<String, dynamic>,
      ),
      paymentOrderId = json['payment_order_id'] as int?,
      expiresAt = DateTime.parse(json['expires_at'] as String),
      canConfirm = json['can_confirm'] as bool,
      canCancel = json['can_cancel'] as bool,
      reason = json['reason'] as String,
      resultGrantIds = List<int>.unmodifiable(
        (json['result_grant_ids'] as List).cast<int>(),
      ) {
    if (!RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
        ).hasMatch(id) ||
        revision <= 0 ||
        (paymentOrderId != null && paymentOrderId! <= 0) ||
        !const {
          'awaiting_payment',
          'reconfirm_required',
          'settling',
          'pending_sync',
          'completed',
          'cancelled',
          'expired',
          'recovery_required',
        }.contains(status) ||
        resultGrantIds.any((id) => id <= 0) ||
        resultGrantIds.toSet().length != resultGrantIds.length) {
      throw const FormatException('invalid conversion resource');
    }
    if ((isTerminal ||
            status == 'pending_sync' ||
            status == 'settling' ||
            status == 'recovery_required') &&
        (canConfirm || canCancel)) {
      throw const FormatException('inconsistent conversion actions');
    }
  }
  final String id, status, reason;
  final int revision;
  final EntitlementConversionQuote quote;
  final int? paymentOrderId;
  final DateTime expiresAt;
  final bool canConfirm, canCancel;
  final List<int> resultGrantIds;
  bool get isTerminal =>
      const {'completed', 'cancelled', 'expired'}.contains(status);
  bool get canRequote =>
      const {'awaiting_payment', 'reconfirm_required'}.contains(status);
}
