// 语义化版本（semver）比较 —— 升级检测的版本号比对基础.
//
// 为什么用版本字符串而非 Android versionCode:
//   release 走 split-per-abi, versionCode 带 ABI 偏移(v7a+1000/arm64+2000/x64+4000),
//   运行时 package_info.buildNumber 在 arm64 设备上 = pubspec+2000, 直接比 build 会误判.
//   而 package_info.version("1.2.1") 跨 ABI 一致, 故一律用它做 semver 比较.
//
// 版本号格式可控(纯 x.y.z), 无需引入 pub_semver 依赖, 手写逐段数值比较即可.
// 数值比较而非字典序: "1.10.0" > "1.9.0"(若按字符串则 "1" 段后 "10" < "9" 误判).

/// 比较两个版本号. a < b 返回 -1, a == b 返回 0, a > b 返回 1.
///
/// 容错: 去前导 'v'、去 build/pre-release 后缀(+xxx / -beta), 段内取前缀数字,
/// 缺段按 0 补齐. 任何无法解析的段降级为 0(绝不抛异常, 服务于 fail-open).
int compareSemver(String a, String b) {
  final pa = _parse(a);
  final pb = _parse(b);
  final n = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < n; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x < y ? -1 : 1;
  }
  return 0;
}

/// candidate 是否比 current 更新(严格大于).
bool isNewerVersion(String candidate, String current) =>
    compareSemver(candidate, current) > 0;

List<int> _parse(String v) {
  var s = v.trim();
  if (s.isEmpty) return const [0];
  if (s.startsWith('v') || s.startsWith('V')) s = s.substring(1);
  // 截断 build metadata('+') 与 pre-release('-'), 只比较核心 x.y.z
  final plus = s.indexOf('+');
  if (plus >= 0) s = s.substring(0, plus);
  final dash = s.indexOf('-');
  if (dash >= 0) s = s.substring(0, dash);
  if (s.isEmpty) return const [0];
  return s.split('.').map((seg) {
    final m = RegExp(r'\d+').firstMatch(seg.trim());
    return m == null ? 0 : (int.tryParse(m.group(0)!) ?? 0);
  }).toList();
}
