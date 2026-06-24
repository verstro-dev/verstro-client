import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import 'common.dart';

extension PackageInfoExtension on PackageInfo {
  String get ua {
    // Verstro iOS：核心是 sing-box（跑在 VerstroTunnel NE 扩展里），订阅必须是 sing-box JSON。
    // 订阅服务端按订阅请求的 User-Agent 选格式。**实测核实（2026-06-05）**：
    //   仅官方 sing-box app 的 `SFI/`(iOS) / `SFA/`(Android) 前缀触发 sing-box JSON；
    //   `sing-box` / `sing-box/x.y` 只得 base64 兜底（不可用）；`clash`/`mihomo` 得 Clash YAML。
    //   版本号无关（SFI/1.0.0 与 SFI/1.13.13 输出 md5 相同），故用 app 版本即可。
    // 安卓/桌面保持 FlClash UA + Clash YAML（已验证链路，勿动）。
    // ⚠️ 已知阻断（待面板修）：订阅服务端当前 sing-box 模板的 dns 段是旧版(≤1.11)格式
    //    （servers[].address + 顶层 fakeip），sing-box 1.13.13 拒绝加载 → 须先更新面板模板 dns 段为
    //    1.12+ 新格式。见 docs/phase-2.7-ios-device-verification.md 前置 A + docs/todo.md。
    if (Platform.isIOS) {
      return 'SFI/$version';
    }
    return [
      '$appName/v$version',
      'clash-verge',
      'Platform/${Platform.operatingSystem}',
    ].join(' ');
  }
}
