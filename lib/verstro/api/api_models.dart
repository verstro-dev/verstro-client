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
  final String id; // monthly / quarterly / yearly / premium-*
  final String name; // 显示名 (标准·月付 / 专业·月付 …)
  final int durationDays;
  final String priceUsd; // "5.00", "13.00", "45.00" — 显示用字符串保精度
  final int trafficLimitBytes;
  final int maxDevices; // 该套餐可同时登录设备数 (标准5/专业10; 旧后端无此字段=0)

  const PlanDto({
    required this.id,
    required this.name,
    required this.durationDays,
    required this.priceUsd,
    required this.trafficLimitBytes,
    this.maxDevices = 0,
  });

  factory PlanDto.fromJson(Map<String, dynamic> json) => PlanDto(
        id: json['id'] as String,
        name: json['name'] as String,
        durationDays: (json['duration_days'] as num).toInt(),
        priceUsd: json['price_usd'] as String,
        trafficLimitBytes: (json['traffic_limit_bytes'] as num).toInt(),
        maxDevices: (json['max_devices'] as num?)?.toInt() ?? 0,
      );

  // premium-* 前缀 = 专业档 (手动选点); 否则标准档 (自动选点)
  bool get isPremium => id.startsWith('premium');
}

class OrderDto {
  final int id;
  final String planId;
  final String basePrice; // "5.00"
  final String finalAmount; // "5.07" 含 cents 尾数
  final String? couponDiscount; // "1.00", 无券时 null (后端 omitempty)
  final String? creditApplied;  // "2.34", 无 credit 时 null
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
/// message 全部由后端生成 (人话), 前端按 resolution 决定 UI 形态, message 直接展示.
class ClaimTxResult {
  final bool matched;
  final String message;
  final String? resolution;   // null = 老后端 (无此字段)
  final int creditedCents;    // 已存入账户余额的金额 (credited_* 时 >0)
  final int shortfallCents;   // 少付缺口 (credited_underpay 时 >0)
  final String? orderStatus;  // claim 后订单状态

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

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) => SubscriptionDto(
        hasSubscription: json['has_subscription'] as bool? ?? false,
        subscriptionUrl: (json['subscription_url'] as String?)?.let((s) => s.isEmpty ? null : s),
        currentPlanId: json['current_plan_id'] as String?,
        tier: json['tier'] as String?,
        manualNodeSelection: json['manual_node_selection'] as bool? ?? false,
        periodStartedAt: _parseTime(json['period_started_at']),
        periodExpiresAt: _parseTime(json['period_expires_at']),
        trafficLimitBytes: (json['traffic_limit_bytes'] as num?)?.toInt() ?? 0,
        trafficUsedBytes: (json['traffic_used_bytes'] as num?)?.toInt() ?? 0,
        totalRemainingBytes: (json['total_remaining_bytes'] as num?)?.toInt() ?? 0,
        grants: (json['grants'] as List?)
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
        credits: (json['credits'] as List<dynamic>?)
                ?.map((e) => CreditItemDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            <CreditItemDto>[],
      );
}

/// GET /v1/agent 的代理视图. 包含邀请码/推荐统计 + 佣金钱包 + tier + 下线数等分销字段.
///
/// payout 透明化 (2026-07): paid_cents 语义变为"已打款"(sent 合计); 新增
/// processing_cents(已申请待打款) / min_payout_cents(最低提现额) / payouts(最近 10 条).
/// 新字段带默认值 (非 required), 老后端缺 key → 默认值, 空构造调用方零改动.
class AgentDto {
  final String code;             // 我的邀请码
  final int directCount;         // 我直接带来几人 (referred_by=me)
  final int refereeRewardCents;  // 被推荐人首购得
  final int referrerRewardCents; // 推荐人首购得
  // 分销佣金字段 (Task 1 新增)
  final String tier;                   // promoter / reseller / master
  final int pendingCents;              // 待成熟佣金(cent)
  final int availableCents;            // 可提现余额(cent)
  final int paidCents;                 // 已打款累计(cent, sent 合计)
  final int overrideAvailableCents;    // override(总代级) 可提现余额(cent)
  final int subAgentCount;             // 下线代理人数
  final bool canRecruit;               // 是否可招募下线
  // payout 透明化字段 (2026-07 新增)
  final int processingCents;           // 已申请待打款合计(cent)
  final int minPayoutCents;            // 最低提现额(cent); 0 = 旧后端未知
  final List<AgentPayoutDto> payouts;  // 最近 10 条提现记录
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
        overrideAvailableCents: (json['override_available_cents'] as num?)?.toInt() ?? 0,
        subAgentCount: (json['sub_agent_count'] as num?)?.toInt() ?? 0,
        canRecruit: json['can_recruit'] as bool? ?? false,
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
  final String dest;       // 收款 TRC20 地址
  final String status;     // requested / sent / failed
  final String? txid;      // 链上 hash, sent 后才有
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
  final int floorCents;
  final int? customCents; // 未设=null
  const AgentPlanPriceDto({
    required this.planId, required this.listCents, required this.floorCents, this.customCents,
  });
  factory AgentPlanPriceDto.fromJson(Map<String, dynamic> json) => AgentPlanPriceDto(
        planId: json['plan_id'] as String? ?? '',
        listCents: (json['list_cents'] as num?)?.toInt() ?? 0,
        floorCents: (json['floor_cents'] as num?)?.toInt() ?? 0,
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
    required this.enabled, required this.claimed, required this.days, required this.trafficGb,
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

// dart 没原生 ?.let, 简短扩展给 nullable 转换
extension _NullableLet<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
