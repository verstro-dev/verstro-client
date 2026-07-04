// 升级 manifest 数据模型 + 升级决策(纯逻辑, 全可单测).
//
// manifest 是放在 R2(dl.verstro.com/manifest/{platform}.json)的静态 JSON,
// 客户端拉取后据此决定是否升级、以何种方式升级. 见 docs 计划: app-goofy-zephyr.
//
// 风格对齐 lib/verstro/api/api_models.dart: 手写 fromJson(不引 freezed/json_serializable),
// 字段容错(缺字段降级而非抛), 服务于 update_service 的 fail-open.

import 'semver.dart';

/// 升级类型. 对应 manifest 的 upgrade_type 字段.
/// 注意 force 在客户端通常由 min_supported_version 动态推导, 也允许 manifest 显式标注.
enum UpgradeType { silent, optional, recommended, force }

/// 解析 upgrade_type 字符串. 未知/缺省 → optional(最温和, 安全默认).
UpgradeType parseUpgradeType(String? s) {
  switch (s) {
    case 'silent':
      return UpgradeType.silent;
    case 'recommended':
      return UpgradeType.recommended;
    case 'force':
      return UpgradeType.force;
    case 'optional':
    default:
      return UpgradeType.optional;
  }
}

/// 单个下载产物. Android 按 ABI(arm64-v8a/...)分多个; 桌面按 arch(arm64/amd64)分.
class UpdateArtifact {
  final String url;
  final String? sha256; // 完整性校验(Android 下载后必校验); 桌面仅展示
  final int? size; // 字节数, 进度/展示用

  const UpdateArtifact({required this.url, this.sha256, this.size});

  factory UpdateArtifact.fromJson(Map<String, dynamic> json) => UpdateArtifact(
        url: json['url'] as String,
        sha256: json['sha256'] as String?,
        size: (json['size'] as num?)?.toInt(),
      );
}

/// 最新版本信息.
class UpdateRelease {
  final String version; // "1.3.0" —— 比较基准
  final int? build; // 仅展示, 不参与比较(ABI 偏移坑)
  final UpgradeType upgradeType;
  final String? notes; // 更新说明(可含换行)
  final String? releasedAt;
  final String? downloadPage; // 桌面/iOS 跳转的下载页(应用内不直接安装时用)
  final Map<String, UpdateArtifact> artifacts; // key = abi / arch

  const UpdateRelease({
    required this.version,
    this.build,
    required this.upgradeType,
    this.notes,
    this.releasedAt,
    this.downloadPage,
    this.artifacts = const {},
  });

  factory UpdateRelease.fromJson(Map<String, dynamic> json) {
    final rawArtifacts = json['artifacts'];
    final artifacts = <String, UpdateArtifact>{};
    if (rawArtifacts is Map) {
      rawArtifacts.forEach((k, v) {
        if (v is Map) {
          artifacts['$k'] = UpdateArtifact.fromJson(
              v.map((key, value) => MapEntry('$key', value)));
        }
      });
    }
    return UpdateRelease(
      version: json['version'] as String,
      build: (json['build'] as num?)?.toInt(),
      upgradeType: parseUpgradeType(json['upgrade_type'] as String?),
      notes: json['notes'] as String?,
      releasedAt: json['released_at'] as String?,
      downloadPage: json['download_page'] as String?,
      artifacts: artifacts,
    );
  }

  /// 按设备 ABI 候选列表(优先级从高到低)选第一个命中的产物. 无命中返回 null.
  UpdateArtifact? pickArtifact(List<String> abiPriority) {
    for (final abi in abiPriority) {
      final a = artifacts[abi];
      if (a != null) return a;
    }
    return null;
  }
}

/// 完整 manifest.
class UpdateManifest {
  final int schema;
  final String platform;
  final UpdateRelease latest;
  final String minSupportedVersion; // 低于此版本强制升级

  const UpdateManifest({
    required this.schema,
    required this.platform,
    required this.latest,
    required this.minSupportedVersion,
  });

  factory UpdateManifest.fromJson(Map<String, dynamic> json) => UpdateManifest(
        schema: (json['schema'] as num?)?.toInt() ?? 1,
        platform: json['platform'] as String? ?? 'unknown',
        latest:
            UpdateRelease.fromJson(json['latest'] as Map<String, dynamic>),
        // 缺省 0.0.0 = 不强制任何人(安全默认)
        minSupportedVersion:
            json['min_supported_version'] as String? ?? '0.0.0',
      );
}

/// 升级决策结果(evaluateUpdate 的产物).
class UpdateDecision {
  final bool hasUpdate;
  final UpgradeType type; // hasUpdate=true 时有效
  final UpdateManifest? manifest;

  const UpdateDecision({
    required this.hasUpdate,
    required this.type,
    this.manifest,
  });

  /// 无更新.
  static const none =
      UpdateDecision(hasUpdate: false, type: UpgradeType.optional);

  UpdateRelease? get latest => manifest?.latest;
  String? get latestVersion => manifest?.latest.version;

  bool get isForce => hasUpdate && type == UpgradeType.force;
  bool get isSilent => hasUpdate && type == UpgradeType.silent;

  /// 可"忽略此版本"的是最温和的两档(silent/optional). recommended/force 不允许永久忽略.
  bool get allowIgnore =>
      hasUpdate &&
      (type == UpgradeType.optional || type == UpgradeType.silent);
}

/// 升级决策(纯函数). 强制门槛优先于 release 标注的类型.
///
///   currentVersion < min_supported_version  → 强制(force)
///   currentVersion < latest.version          → latest.upgrade_type
///   否则                                      → 无更新
UpdateDecision evaluateUpdate({
  required String currentVersion,
  required UpdateManifest manifest,
}) {
  if (compareSemver(currentVersion, manifest.minSupportedVersion) < 0) {
    return UpdateDecision(
      hasUpdate: true,
      type: UpgradeType.force,
      manifest: manifest,
    );
  }
  if (compareSemver(currentVersion, manifest.latest.version) < 0) {
    return UpdateDecision(
      hasUpdate: true,
      type: manifest.latest.upgradeType,
      manifest: manifest,
    );
  }
  return UpdateDecision.none;
}
