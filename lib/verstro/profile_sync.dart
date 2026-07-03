// Verstro 订阅 profile 迁移决策 (T3.2, 见 docs/security/client-credential-security.md)
//
// 纯逻辑: 给定已存的托管 profile id + 现有 profiles + 目标订阅 URL, 决定 import/replace/skip
// 以及要删的多余 profile。配合 application.dart _verstroAutoIntegrate 执行。
//
// 前提不变量: kVerstroHideManualImport=true, 用户无法手动加 profile → 所有 profile 都是
// verstro 托管, 故可安全保留一个 canonical、删多余 (修开 flag 时 URL 变导致的重复导入).

enum VerstroProfileAction { import, replace, skip }

class VerstroProfilePlan {
  final VerstroProfileAction action;
  final int? keepId; // replace/skip 保留并(replace 时)更新 url 的 profile id
  final List<int> deleteIds; // 多余 profile, 删除(清理重复)

  const VerstroProfilePlan(this.action, {this.keepId, this.deleteIds = const []});
}

/// 决定如何把目标订阅 [targetUrl] 同步到本地 profile。
/// [managedId] 上次记录的托管 profile id (可空); [profiles] 现有 profile 的 (id,url)。
VerstroProfilePlan planVerstroProfile(
  int? managedId,
  List<({int id, String url})> profiles,
  String targetUrl,
) {
  if (profiles.isEmpty) {
    return const VerstroProfilePlan(VerstroProfileAction.import);
  }
  // canonical: 优先 managedId 命中的, 否则第一个
  var canonical = profiles.first;
  if (managedId != null) {
    final idx = profiles.indexWhere((p) => p.id == managedId);
    if (idx != -1) canonical = profiles[idx];
  }
  final deleteIds = [
    for (final p in profiles)
      if (p.id != canonical.id) p.id,
  ];
  final action = canonical.url == targetUrl
      ? VerstroProfileAction.skip
      : VerstroProfileAction.replace;
  return VerstroProfilePlan(action, keepId: canonical.id, deleteIds: deleteIds);
}
