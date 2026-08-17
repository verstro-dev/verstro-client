// Verstro backend API request/response Dart 类型
//
// 跟 后端 billing 服务各 endpoint 的 JSON 形状一一对应.
// 不用 json_serializable 等代码生成器, 手写 fromJson — 阶段 2.2 字段还在迭代,
// 手写改动快; 字段稳定后可以再切代码生成.

class AuthResult {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final UserDto user;

  const AuthResult({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
    accessToken: json['access_token'] as String,
    tokenType: json['token_type'] as String? ?? 'Bearer',
    expiresIn: (json['expires_in'] as num?)?.toInt() ?? 86400,
    user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
  );
}

class UserDto {
  final int id;
  final String email;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;

  const UserDto({
    required this.id,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: (json['id'] as num).toInt(),
    email: json['email'] as String,
    emailVerifiedAt: _parseTime(json['email_verified_at']),
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  bool get isEmailVerified => emailVerifiedAt != null;
}

class PlanDto {
  final int planVersionId; // 下单时回传，防止展示后套餐权益被静默替换
  final String id; // monthly / quarterly / yearly / premium-*
  final String name; // 显示名 (标准·月付 / 专业·月付 …)
  final int durationDays;
  final String priceUsd; // "6.00", "15.00", "49.00" — 显示用字符串保精度
  final int effectivePriceCents; // 下单确认价；旧后端由 price_usd 推导
  final String listPriceUsd; // 平台原价；无代理价时等于 priceUsd
  final int listPriceCents;
  final bool partnerPrice; // 是否为合作伙伴专属折扣价
  final bool purchaseAvailable; // 代理套餐发布冲突时可只暂停该套餐新购
  final String unavailableReason;
  final int trafficLimitBytes;
  final int maxDevices; // 该套餐可同时登录设备数 (标准5/专业10; 旧后端无此字段=0)

  const PlanDto({
    this.planVersionId = 0,
    required this.id,
    required this.name,
    required this.durationDays,
    required this.priceUsd,
    this.effectivePriceCents = 0,
    this.listPriceUsd = '',
    this.listPriceCents = 0,
    this.partnerPrice = false,
    this.purchaseAvailable = true,
    this.unavailableReason = '',
    required this.trafficLimitBytes,
    this.maxDevices = 0,
  });

  factory PlanDto.fromJson(Map<String, dynamic> json) {
    final priceUsd = json['price_usd'] as String;
    final effective =
        (json['effective_price_cents'] as num?)?.toInt() ??
        (json['price_cents'] as num?)?.toInt() ??
        _usdStringToCents(priceUsd);
    final listUsd = json['list_price_usd'] as String? ?? priceUsd;
    final listCents =
        (json['list_price_cents'] as num?)?.toInt() ??
        _usdStringToCents(listUsd);
    return PlanDto(
      planVersionId: (json['plan_version_id'] as num?)?.toInt() ?? 0,
      id: json['id'] as String,
      name: json['name'] as String,
      durationDays: (json['duration_days'] as num).toInt(),
      priceUsd: priceUsd,
      effectivePriceCents: effective,
      listPriceUsd: listUsd,
      listPriceCents: listCents,
      partnerPrice: json['partner_price'] as bool? ?? effective < listCents,
      purchaseAvailable: json['purchase_available'] as bool? ?? true,
      unavailableReason: json['unavailable_reason'] as String? ?? '',
      trafficLimitBytes: (json['traffic_limit_bytes'] as num).toInt(),
      maxDevices: (json['max_devices'] as num?)?.toInt() ?? 0,
    );
  }

  // premium-* 前缀 = 专业档 (手动选点); 否则标准档 (自动选点)
  bool get isPremium => id.startsWith('premium');

  // API 解析后 effectivePriceCents 总是有值；手写测试/旧调用若只传 priceUsd，
  // 仍从展示价安全推导确认价，避免把 0 cents 发给下单接口。
  int get expectedBasePriceCents => effectivePriceCents > 0
      ? effectivePriceCents
      : _usdStringToCents(priceUsd);
}

class PromotionSummaryDto {
  final int campaignId;
  final int revisionId;
  final String scenario;
  final String audience;
  final List<String> planIds;
  final Map<String, String> titleI18n;
  final Map<String, String> descriptionI18n;
  final Map<String, String> termsI18n;
  final DateTime? startsAt;
  final DateTime? endsAt;

  const PromotionSummaryDto({
    required this.campaignId,
    required this.revisionId,
    required this.scenario,
    required this.audience,
    required this.planIds,
    required this.titleI18n,
    required this.descriptionI18n,
    required this.termsI18n,
    this.startsAt,
    this.endsAt,
  });

  factory PromotionSummaryDto.fromJson(Map<String, dynamic> json) =>
      PromotionSummaryDto(
        campaignId: (json['campaign_id'] as num?)?.toInt() ?? 0,
        revisionId: (json['revision_id'] as num?)?.toInt() ?? 0,
        scenario: json['scenario'] as String? ?? '',
        audience: json['audience'] as String? ?? '',
        planIds: _stringList(json['plan_ids']),
        titleI18n: _stringMap(json['title_i18n']),
        descriptionI18n: _stringMap(json['description_i18n']),
        termsI18n: _stringMap(json['terms_i18n']),
        startsAt: _parseTime(json['starts_at'])?.toUtc(),
        endsAt: _parseTime(json['ends_at'])?.toUtc(),
      );
}

class PromotionEligibilityDto {
  final int campaignId;
  final int revisionId;
  final String scenario;
  final String availability;
  final List<String> eligiblePlanIds;
  final Map<String, String> titleI18n;
  final Map<String, String> descriptionI18n;
  final Map<String, String> termsI18n;
  final DateTime? endsAt;

  const PromotionEligibilityDto({
    required this.campaignId,
    required this.revisionId,
    required this.scenario,
    required this.availability,
    required this.eligiblePlanIds,
    required this.titleI18n,
    required this.descriptionI18n,
    required this.termsI18n,
    this.endsAt,
  });

  factory PromotionEligibilityDto.fromJson(Map<String, dynamic> json) =>
      PromotionEligibilityDto(
        campaignId: (json['campaign_id'] as num?)?.toInt() ?? 0,
        revisionId: (json['revision_id'] as num?)?.toInt() ?? 0,
        scenario: json['scenario'] as String? ?? '',
        availability: json['availability'] as String? ?? 'unavailable',
        eligiblePlanIds: _stringList(json['eligible_plan_ids']),
        titleI18n: _stringMap(json['title_i18n']),
        descriptionI18n: _stringMap(json['description_i18n']),
        termsI18n: _stringMap(json['terms_i18n']),
        endsAt: _parseTime(json['ends_at'])?.toUtc(),
      );
}

class PromotionGrantDto {
  final int campaignId;
  final int revisionId;
  final String state;
  final bool redeemable;
  final String availability;
  final DateTime? expiresAt;
  final Map<String, String> titleI18n;

  const PromotionGrantDto({
    required this.campaignId,
    required this.revisionId,
    required this.state,
    required this.redeemable,
    required this.availability,
    required this.titleI18n,
    this.expiresAt,
  });

  factory PromotionGrantDto.fromJson(Map<String, dynamic> json) =>
      PromotionGrantDto(
        campaignId: (json['campaign_id'] as num?)?.toInt() ?? 0,
        revisionId: (json['revision_id'] as num?)?.toInt() ?? 0,
        state: json['state'] as String? ?? '',
        redeemable: json['redeemable'] as bool? ?? false,
        availability: json['availability'] as String? ?? 'unavailable',
        expiresAt: _parseTime(json['expires_at'])?.toUtc(),
        titleI18n: _stringMap(json['title_i18n']),
      );
}

class PromotionRedemptionDto {
  final int campaignId;
  final int revisionId;
  final String application;
  final int discountCents;
  final String status;
  final DateTime? heldAt;
  final DateTime? settledAt;
  final DateTime? releasedAt;

  const PromotionRedemptionDto({
    required this.campaignId,
    required this.revisionId,
    required this.application,
    required this.discountCents,
    required this.status,
    this.heldAt,
    this.settledAt,
    this.releasedAt,
  });

  factory PromotionRedemptionDto.fromJson(Map<String, dynamic> json) =>
      PromotionRedemptionDto(
        campaignId: (json['campaign_id'] as num?)?.toInt() ?? 0,
        revisionId: (json['revision_id'] as num?)?.toInt() ?? 0,
        application: json['application'] as String? ?? 'none',
        discountCents: (json['discount_cents'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? '',
        heldAt: _parseTime(json['held_at'])?.toUtc(),
        settledAt: _parseTime(json['settled_at'])?.toUtc(),
        releasedAt: _parseTime(json['released_at'])?.toUtc(),
      );
}

class MyPromotionsDto {
  final List<PromotionEligibilityDto> automatic;
  final List<PromotionGrantDto> grants;
  final List<PromotionRedemptionDto> redemptions;

  const MyPromotionsDto({
    required this.automatic,
    required this.grants,
    required this.redemptions,
  });

  factory MyPromotionsDto.fromJson(Map<String, dynamic> json) =>
      MyPromotionsDto(
        automatic: _jsonMaps(
          json['automatic'],
        ).map(PromotionEligibilityDto.fromJson).toList(growable: false),
        grants: _jsonMaps(
          json['grants'],
        ).map(PromotionGrantDto.fromJson).toList(growable: false),
        redemptions: _jsonMaps(
          json['redemptions'],
        ).map(PromotionRedemptionDto.fromJson).toList(growable: false),
      );
}

class PromotionQuoteDto {
  final int campaignId;
  final int revisionId;
  final String application;
  final int basePriceCents;
  final int discountCents;
  final int priceAfterDiscountCents;
  final String quoteToken;
  final DateTime expiresAt;

  const PromotionQuoteDto({
    required this.campaignId,
    required this.revisionId,
    required this.application,
    required this.basePriceCents,
    required this.discountCents,
    required this.priceAfterDiscountCents,
    required this.quoteToken,
    required this.expiresAt,
  });

  factory PromotionQuoteDto.fromJson(Map<String, dynamic> json) {
    final token = json['quote_token'] as String? ?? '';
    final expiresAt = _parseTime(json['expires_at']);
    final base = (json['base_price_cents'] as num?)?.toInt() ?? -1;
    final discount = (json['discount_cents'] as num?)?.toInt() ?? -1;
    final after = (json['price_after_discount_cents'] as num?)?.toInt() ?? -1;
    if (token.isEmpty ||
        expiresAt == null ||
        base < 0 ||
        discount < 0 ||
        after < 0 ||
        after != base - discount) {
      throw const FormatException('promotion quote token or expiry missing');
    }
    return PromotionQuoteDto(
      campaignId: (json['campaign_id'] as num?)?.toInt() ?? 0,
      revisionId: (json['revision_id'] as num?)?.toInt() ?? 0,
      application: json['application'] as String? ?? 'none',
      basePriceCents: base,
      discountCents: discount,
      priceAfterDiscountCents: after,
      quoteToken: token,
      expiresAt: expiresAt.toUtc(),
    );
  }

  bool get isExpired => !DateTime.now().toUtc().isBefore(expiresAt);
}

class OrderPromotionDto {
  final int campaignId;
  final int revisionId;
  final String application;
  final int discountCents;

  const OrderPromotionDto({
    required this.campaignId,
    required this.revisionId,
    required this.application,
    required this.discountCents,
  });

  factory OrderPromotionDto.fromJson(Map<String, dynamic> json) =>
      OrderPromotionDto(
        campaignId: (json['campaign_id'] as num?)?.toInt() ?? 0,
        revisionId: (json['revision_id'] as num?)?.toInt() ?? 0,
        application: json['application'] as String? ?? 'none',
        discountCents: (json['discount_cents'] as num?)?.toInt() ?? 0,
      );
}

class OrderDto {
  final int id;
  final String planId;
  final String basePrice; // "5.00"
  final String finalAmount; // "5.07" 含 cents 尾数
  final String? couponDiscount; // "1.00", 无券时 null (后端 omitempty)
  final String? creditApplied; // "2.34", 无 credit 时 null
  final OrderPromotionDto? promotion;
  final String status; // waiting / finished / expired / failed
  final String? depositAddress; // Tron 收款地址, waiting 状态返
  final String payCurrency; // "usdttrc20"
  final String? txid; // 链上 hash, finished 后才有
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? paidAt;

  const OrderDto({
    required this.id,
    required this.planId,
    required this.basePrice,
    required this.finalAmount,
    this.couponDiscount,
    this.creditApplied,
    this.promotion,
    required this.status,
    required this.depositAddress,
    required this.payCurrency,
    required this.txid,
    required this.createdAt,
    required this.expiresAt,
    required this.paidAt,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) => OrderDto(
    id: (json['id'] as num).toInt(),
    planId: json['plan_id'] as String,
    basePrice: json['base_price'] as String,
    finalAmount: json['final_amount'] as String,
    couponDiscount: json['coupon_discount'] as String?,
    creditApplied: json['credit_applied'] as String?,
    promotion: json['promotion'] is Map<String, dynamic>
        ? OrderPromotionDto.fromJson(json['promotion'] as Map<String, dynamic>)
        : null,
    status: json['status'] as String,
    depositAddress: json['deposit_address'] as String?,
    payCurrency: json['pay_currency'] as String? ?? 'usdttrc20',
    txid: json['txid'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    expiresAt: DateTime.parse(json['expires_at'] as String),
    paidAt: _parseTime(json['paid_at']),
  );

  bool get isFinished => status == 'finished';
  bool get isWaiting => status == 'waiting';
  bool get isExpired => status == 'expired';
}

/// POST /v1/orders/{id}/claim-tx 响应.
///
/// 新契约 (2026-07 风控批次后): 在 {matched, message} 基础上扩了 resolution 枚举
/// (matched / overpaid_matched / credited_underpay / credited_expired /
///  matched_other_order / already_processed / rejected_manual) + 入余额金额等.
/// 老后端没有新字段 → resolution/orderStatus 为 null, cents 为 0; UI 按 matched 布尔回退.
/// message 已弃用, 前端按 resolution 本地化 (见 claim_display.dart), 不再展示后端 message.
class ClaimTxResult {
  final bool matched;
  final String message;
  final String? resolution; // null = 老后端 (无此字段)
  final int creditedCents; // 已存入账户余额的金额 (credited_* 时 >0)
  final int shortfallCents; // 少付缺口 (credited_underpay 时 >0)
  final String? orderStatus; // claim 后订单状态

  const ClaimTxResult({
    required this.matched,
    required this.message,
    this.resolution,
    this.creditedCents = 0,
    this.shortfallCents = 0,
    this.orderStatus,
  });

  factory ClaimTxResult.fromJson(Map<String, dynamic> json) => ClaimTxResult(
    matched: json['matched'] as bool? ?? false,
    message: json['message'] as String? ?? '',
    resolution: json['resolution'] as String?,
    creditedCents: (json['credited_cents'] as num?)?.toInt() ?? 0,
    shortfallCents: (json['shortfall_cents'] as num?)?.toInt() ?? 0,
    orderStatus: json['order_status'] as String?,
  );
}

/// 单个流量套餐桶 (多套餐流量账本, 修复"旧套餐流量被新套餐吞掉" bug). 每次购买产生一个,
/// 各自配额/各自到期/各自计量. status: active(可用) / exhausted(用尽未到期) / expired(到期作废).
class GrantDto {
  final String planId;
  final String planName;
  final int quotaBytes;
  final int consumedBytes;
  final int remainingBytes;
  final DateTime? expiresAt;
  final String status;

  const GrantDto({
    required this.planId,
    required this.planName,
    required this.quotaBytes,
    required this.consumedBytes,
    required this.remainingBytes,
    required this.expiresAt,
    required this.status,
  });

  factory GrantDto.fromJson(Map<String, dynamic> json) => GrantDto(
    planId: json['plan_id'] as String? ?? '',
    planName: json['plan_name'] as String? ?? '',
    quotaBytes: (json['quota_bytes'] as num?)?.toInt() ?? 0,
    consumedBytes: (json['consumed_bytes'] as num?)?.toInt() ?? 0,
    remainingBytes: (json['remaining_bytes'] as num?)?.toInt() ?? 0,
    expiresAt: _parseTime(json['expires_at']),
    status: json['status'] as String? ?? 'active',
  );
}

class SubscriptionDto {
  final bool hasSubscription;
  final String? subscriptionUrl;
  final String? currentPlanId;
  // 套餐档位 + 选点能力 (plan 1-2 阶段B). tier: standard/premium (无订阅 null);
  // manualNodeSelection: 专业档 true=客户端开放手动选国家/节点, 标准档 false=隐藏走自动.
  // (真正的节点隔离是 Remnawave squad 成员=服务端边界; 此处只是 UI gate.)
  final String? tier;
  final bool manualNodeSelection;
  final DateTime? periodStartedAt;
  final DateTime? periodExpiresAt;
  // 流量上限/已用: 多套餐时 = 所有未过期套餐合计 (向后兼容单条进度条).
  final int trafficLimitBytes;
  final int trafficUsedBytes;
  // 多套餐流量账本: 总剩余可用 (= 所有未过期套餐剩余之和), 与各套餐明细. 旧后端无此字段时为默认值.
  final int totalRemainingBytes;
  final List<GrantDto> grants;
  final bool isExpired;

  const SubscriptionDto({
    required this.hasSubscription,
    required this.subscriptionUrl,
    required this.currentPlanId,
    required this.periodStartedAt,
    required this.periodExpiresAt,
    required this.trafficLimitBytes,
    required this.trafficUsedBytes,
    required this.isExpired,
    this.tier,
    this.manualNodeSelection = false,
    this.totalRemainingBytes = 0,
    this.grants = const [],
  });

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) =>
      SubscriptionDto(
        hasSubscription: json['has_subscription'] as bool? ?? false,
        subscriptionUrl: (json['subscription_url'] as String?)?.let(
          (s) => s.isEmpty ? null : s,
        ),
        currentPlanId: json['current_plan_id'] as String?,
        tier: json['tier'] as String?,
        manualNodeSelection: json['manual_node_selection'] as bool? ?? false,
        periodStartedAt: _parseTime(json['period_started_at']),
        periodExpiresAt: _parseTime(json['period_expires_at']),
        trafficLimitBytes: (json['traffic_limit_bytes'] as num?)?.toInt() ?? 0,
        trafficUsedBytes: (json['traffic_used_bytes'] as num?)?.toInt() ?? 0,
        totalRemainingBytes:
            (json['total_remaining_bytes'] as num?)?.toInt() ?? 0,
        grants:
            (json['grants'] as List?)
                ?.map((e) => GrantDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        isExpired: json['is_expired'] as bool? ?? false,
      );

  bool get isPremium => tier == 'premium';
}

class BootstrapDto {
  final List<String> domains;
  final String scheme; // "https"
  final String apiPrefix; // "/api/billing"

  const BootstrapDto({
    required this.domains,
    required this.scheme,
    required this.apiPrefix,
  });

  factory BootstrapDto.fromJson(Map<String, dynamic> json) => BootstrapDto(
    domains: (json['domains'] as List).cast<String>(),
    scheme: json['scheme'] as String? ?? 'https',
    apiPrefix: json['api_prefix'] as String? ?? '/api/billing',
  );
}

class DeviceDto {
  final String deviceId;
  final String deviceName;
  final String platform;
  final DateTime lastSeenAt;
  final DateTime createdAt;

  const DeviceDto({
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.lastSeenAt,
    required this.createdAt,
  });

  factory DeviceDto.fromJson(Map<String, dynamic> json) => DeviceDto(
    deviceId: json['device_id'] as String,
    deviceName: json['device_name'] as String? ?? '',
    platform: json['platform'] as String? ?? '',
    lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

/// GET /v1/devices 响应: 设备列表 + 当前套餐设备上限 (plan 1-2 阶段C 设备数展示).
class DevicesInfo {
  final List<DeviceDto> devices;
  final int maxDevices; // 当前套餐上限 (标准5/专业10); 0 = 未知/旧后端

  const DevicesInfo({required this.devices, required this.maxDevices});

  factory DevicesInfo.fromJson(Map<String, dynamic> json) => DevicesInfo(
    devices: ((json['devices'] as List?) ?? const [])
        .map((e) => DeviceDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    maxDevices: (json['max_devices'] as num?)?.toInt() ?? 0,
  );
}

/// GET /v1/me/credit 单笔 credit (v1 只用作 CreditDto.credits 元素, 卡不单独渲染明细).
class CreditItemDto {
  final int id;
  final String kind;
  final int amountCents;
  final int usableCents;
  final DateTime? expiresAt;

  const CreditItemDto({
    required this.id,
    required this.kind,
    required this.amountCents,
    required this.usableCents,
    required this.expiresAt,
  });

  factory CreditItemDto.fromJson(Map<String, dynamic> json) => CreditItemDto(
    id: (json['id'] as num).toInt(),
    kind: json['kind'] as String,
    amountCents: (json['amount_cents'] as num).toInt(),
    usableCents: (json['usable_cents'] as num).toInt(),
    expiresAt: _parseTime(json['expires_at']),
  );
}

/// GET /v1/me/credit 响应: 可抵扣余额 + 明细. 后端 credits 空时返 null.
class CreditDto {
  final int balanceCents;
  final List<CreditItemDto> credits;

  const CreditDto({required this.balanceCents, required this.credits});

  factory CreditDto.fromJson(Map<String, dynamic> json) => CreditDto(
    balanceCents: (json['balance_cents'] as num).toInt(),
    credits:
        (json['credits'] as List<dynamic>?)
            ?.map((e) => CreditItemDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <CreditItemDto>[],
  );
}

/// 平台正式合作伙伴授权的对外安全视图。
/// 内部批准人、批准原因、合同/申请引用和渠道父级不会下发到普通账号端。
class PartnerAuthorizationDto {
  final String authorizationCode;
  final String level;
  final String status;
  final String cooperationMode;
  final List<String> capabilities;
  final DateTime? effectiveAt;
  final DateTime? expiresAt;

  const PartnerAuthorizationDto({
    required this.authorizationCode,
    required this.level,
    required this.status,
    required this.cooperationMode,
    required this.capabilities,
    this.effectiveAt,
    this.expiresAt,
  });

  factory PartnerAuthorizationDto.fromJson(Map<String, dynamic> json) =>
      PartnerAuthorizationDto(
        authorizationCode: json['authorization_code'] as String? ?? '',
        level: json['level'] as String? ?? '',
        status: json['status'] as String? ?? '',
        cooperationMode: json['cooperation_mode'] as String? ?? '',
        capabilities: ((json['capabilities'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        effectiveAt: _parseTime(json['effective_at']),
        expiresAt: _parseTime(json['expires_at']),
      );

  bool get isVerified =>
      status == 'active' &&
      authorizationCode.isNotEmpty &&
      capabilities.contains('verified_partner_badge');
  bool get isNonExclusive => cooperationMode == 'non_exclusive';
  bool hasCapability(String capability) => capabilities.contains(capability);
}

/// GET /v1/agent 的代理视图. 包含邀请码/推荐统计 + 佣金钱包 + tier + 下线数等分销字段.
///
/// payout 透明化 (2026-07): paid_cents 语义变为"已打款"(sent 合计); 新增
/// processing_cents(已申请待打款) / min_payout_cents(最低提现额) / payouts(最近 10 条).
/// 新字段带默认值 (非 required), 老后端缺 key → 默认值, 空构造调用方零改动.
class AgentDto {
  final String code; // 我的邀请码
  final int directCount; // 我直接带来几人 (referred_by=me)
  final int refereeRewardCents; // 被推荐人首购得
  final int referrerRewardCents; // 推荐人首购得
  // 分销佣金字段 (Task 1 新增)
  final String tier; // promoter / reseller / master
  final int pendingCents; // 待成熟佣金(cent)
  final int availableCents; // 可提现余额(cent)
  final int paidCents; // 已打款累计(cent, sent 合计)
  final int overrideAvailableCents; // override(战略分销伙伴级) 可提现余额(cent)
  final int subAgentCount; // 下线代理人数
  final bool canRecruit; // 是否可招募下线
  final PartnerAuthorizationDto? partnerAuthorization; // 平台正式授权；普通推广为空
  // payout 透明化字段 (2026-07 新增)
  final int processingCents; // 已申请待打款合计(cent)
  final int minPayoutCents; // 最低提现额(cent); 0 = 旧后端未知
  final List<AgentPayoutDto> payouts; // 最近 10 条提现记录
  const AgentDto({
    required this.code,
    required this.directCount,
    required this.refereeRewardCents,
    required this.referrerRewardCents,
    required this.tier,
    required this.pendingCents,
    required this.availableCents,
    required this.paidCents,
    required this.overrideAvailableCents,
    required this.subAgentCount,
    required this.canRecruit,
    this.partnerAuthorization,
    this.processingCents = 0,
    this.minPayoutCents = 0,
    this.payouts = const [],
  });
  factory AgentDto.fromJson(Map<String, dynamic> json) => AgentDto(
    code: json['code'] as String? ?? '',
    directCount: (json['direct_count'] as num?)?.toInt() ?? 0,
    refereeRewardCents: (json['referee_reward_cents'] as num?)?.toInt() ?? 0,
    referrerRewardCents: (json['referrer_reward_cents'] as num?)?.toInt() ?? 0,
    tier: json['tier'] as String? ?? 'promoter',
    pendingCents: (json['pending_cents'] as num?)?.toInt() ?? 0,
    availableCents: (json['available_cents'] as num?)?.toInt() ?? 0,
    paidCents: (json['paid_cents'] as num?)?.toInt() ?? 0,
    overrideAvailableCents:
        (json['override_available_cents'] as num?)?.toInt() ?? 0,
    subAgentCount: (json['sub_agent_count'] as num?)?.toInt() ?? 0,
    canRecruit: json['can_recruit'] as bool? ?? false,
    partnerAuthorization: json['partner_authorization'] is Map
        ? PartnerAuthorizationDto.fromJson(
            Map<String, dynamic>.from(json['partner_authorization'] as Map),
          )
        : null,
    processingCents: (json['processing_cents'] as num?)?.toInt() ?? 0,
    minPayoutCents: (json['min_payout_cents'] as num?)?.toInt() ?? 0,
    payouts: ((json['payouts'] as List?) ?? const [])
        .map((e) => AgentPayoutDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// GET /v1/agent payouts[] 单条提现记录 (payout 透明化, 2026-07).
/// status: requested(已申请, 人工打款中) / sent(已打款) / failed(打款失败, 金额已退回).
/// txid 仅 sent 有; settled_at 为 sent/failed 的终态时间. 全字段容错 (老后端/字段缺省不抛).
class AgentPayoutDto {
  final int id;
  final int amountCents;
  final String dest; // 收款 TRC20 地址
  final String status; // requested / sent / failed
  final String? txid; // 链上 hash, sent 后才有
  final DateTime? createdAt;
  final DateTime? settledAt;

  const AgentPayoutDto({
    required this.id,
    required this.amountCents,
    required this.dest,
    required this.status,
    this.txid,
    this.createdAt,
    this.settledAt,
  });

  factory AgentPayoutDto.fromJson(Map<String, dynamic> json) => AgentPayoutDto(
    id: (json['id'] as num?)?.toInt() ?? 0,
    amountCents: (json['amount_cents'] as num?)?.toInt() ?? 0,
    dest: json['dest'] as String? ?? '',
    status: json['status'] as String? ?? '',
    txid: json['txid'] as String?,
    createdAt: _parseTime(json['created_at']),
    settledAt: _parseTime(json['settled_at']),
  );
}

/// GET /v1/agent/prices 单个套餐价格项. list_cents=平台价 / floor_cents=底价 / customCents=自定义售价(未设为null).
class AgentPlanPriceDto {
  final String planId;
  final int listCents;
  final int wholesaleCents;
  final int floorCents;
  final int? customCents; // 未设=null
  const AgentPlanPriceDto({
    required this.planId,
    required this.listCents,
    required this.floorCents,
    this.wholesaleCents = 0,
    this.customCents,
  });
  factory AgentPlanPriceDto.fromJson(Map<String, dynamic> json) =>
      AgentPlanPriceDto(
        planId: json['plan_id'] as String? ?? '',
        listCents: (json['list_cents'] as num?)?.toInt() ?? 0,
        wholesaleCents:
            (json['wholesale_cents'] as num?)?.toInt() ??
            (json['floor_cents'] as num?)?.toInt() ??
            0,
        floorCents:
            (json['minimum_sale_cents'] as num?)?.toInt() ??
            (json['floor_cents'] as num?)?.toInt() ??
            0,
        customCents: (json['price_cents'] as num?)?.toInt(),
      );
}

/// GET /v1/agent/prices 响应: 当前 tier + 各套餐可设价范围/当前售价.
class AgentPricesDto {
  final String tier;
  final List<AgentPlanPriceDto> prices;
  const AgentPricesDto({required this.tier, required this.prices});
  factory AgentPricesDto.fromJson(Map<String, dynamic> json) => AgentPricesDto(
    tier: json['tier'] as String? ?? 'promoter',
    prices: ((json['prices'] as List?) ?? const [])
        .map((e) => AgentPlanPriceDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// GET /v1/trial/status 视图. enabled/claimed 是后端独有(客户端 email/订阅自知).
class TrialStatusDto {
  final bool enabled;
  final bool claimed;
  final int days;
  final int trafficGb;
  const TrialStatusDto({
    required this.enabled,
    required this.claimed,
    required this.days,
    required this.trafficGb,
  });
  factory TrialStatusDto.fromJson(Map<String, dynamic> json) => TrialStatusDto(
    enabled: json['enabled'] as bool? ?? false,
    claimed: json['claimed'] as bool? ?? false,
    days: (json['days'] as num?)?.toInt() ?? 0,
    trafficGb: (json['traffic_gb'] as num?)?.toInt() ?? 0,
  );
}

// === 内部工具 ===

// 可空时间字段统一容错解析: null / 空串 / 非法串 都返 null (tryParse), 不抛.
DateTime? _parseTime(dynamic v) {
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  return null;
}

List<String> _stringList(dynamic value) => value is List
    ? value.whereType<String>().toList(growable: false)
    : const <String>[];

Map<String, String> _stringMap(dynamic value) {
  if (value is! Map) return const <String, String>{};
  return <String, String>{
    for (final entry in value.entries)
      if (entry.key is String && entry.value is String)
        entry.key as String: entry.value as String,
  };
}

List<Map<String, dynamic>> _jsonMaps(dynamic value) => value is List
    ? value.whereType<Map<String, dynamic>>().toList(growable: false)
    : const <Map<String, dynamic>>[];

int _usdStringToCents(String value) =>
    ((double.tryParse(value) ?? 0) * 100).round();

// dart 没原生 ?.let, 简短扩展给 nullable 转换
extension _NullableLet<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
