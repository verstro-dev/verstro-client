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
  final String id; // monthly / quarterly / yearly
  final String name; // 显示名 (月付/季付/年付)
  final int durationDays;
  final String priceUsd; // "5.00", "13.00", "45.00" — 显示用字符串保精度
  final int trafficLimitBytes;

  const PlanDto({
    required this.id,
    required this.name,
    required this.durationDays,
    required this.priceUsd,
    required this.trafficLimitBytes,
  });

  factory PlanDto.fromJson(Map<String, dynamic> json) => PlanDto(
        id: json['id'] as String,
        name: json['name'] as String,
        durationDays: (json['duration_days'] as num).toInt(),
        priceUsd: json['price_usd'] as String,
        trafficLimitBytes: (json['traffic_limit_bytes'] as num).toInt(),
      );
}

class OrderDto {
  final int id;
  final String planId;
  final String basePrice; // "5.00"
  final String finalAmount; // "5.07" 含 cents 尾数
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

class ClaimTxResult {
  final bool matched;
  final String message;

  const ClaimTxResult({required this.matched, required this.message});

  factory ClaimTxResult.fromJson(Map<String, dynamic> json) => ClaimTxResult(
        matched: json['matched'] as bool? ?? false,
        message: json['message'] as String? ?? '',
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
    this.totalRemainingBytes = 0,
    this.grants = const [],
  });

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) => SubscriptionDto(
        hasSubscription: json['has_subscription'] as bool? ?? false,
        subscriptionUrl: (json['subscription_url'] as String?)?.let((s) => s.isEmpty ? null : s),
        currentPlanId: json['current_plan_id'] as String?,
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

// === 内部工具 ===

DateTime? _parseTime(dynamic v) {
  if (v == null) return null;
  if (v is String && v.isNotEmpty) return DateTime.parse(v);
  return null;
}

// dart 没原生 ?.let, 简短扩展给 nullable 转换
extension _NullableLet<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
