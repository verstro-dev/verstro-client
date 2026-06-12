// AboutPage — Verstro 关于页
//
// 合规决策 (2026-06-09, 取代早先"App 内不暴露源码"的产品决策):
//   所分发二进制基于 FlClash + Mihomo/sing-box (均 GPLv3) 衍生, GPLv3 §6 要求向
//   二进制接收者提供对应源码. 删去 App 内署名不解除义务, 反而构成 §4/§5 违约.
//   因此关于页恢复一个"开源与许可"入口.
//
// 匿名设计: App 内链接指向品牌域名 https://verstro.com/opensource (间接层), 不直链
//   GitHub. 好处 (1) 匿名镜像账号名不进二进制字符串表; (2) 换账号无需重新发版——
//   只改官网那一页的跳转. 真正的公开镜像仓地址由 website/opensource.html 承载.
//
// 关于页其余部分仍只承载信任建设: 客服 / 官网 / 隐私承诺 / 致谢.
// 不动 FlClash 上游, lib/verstro/ 独立页.

import 'package:fl_clash/verstro/update/update_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// App 内对外的"源码与许可"入口. 走品牌域名间接层, 而非直链匿名镜像仓:
/// 匿名账号名不进二进制, 且换账号只需改官网跳转、无需重新发版.
const String kVerstroSourceUrl = 'https://verstro.com/opensource';

class VerstroAboutPage extends StatefulWidget {
  const VerstroAboutPage({super.key});

  @override
  State<VerstroAboutPage> createState() => _VerstroAboutPageState();
}

class _VerstroAboutPageState extends State<VerstroAboutPage> {
  PackageInfo? _info;
  bool _checkingUpdate = false;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      final i = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _info = i);
    } catch (_) {
      // ignore: package_info_plus 偶发 fail in some platforms, 不显示版本即可
    }
  }

  /// 用户主动检查更新(无更新也提示"已是最新", 无视"忽略此版本").
  Future<void> _checkUpdate() async {
    if (_checkingUpdate) return;
    setState(() => _checkingUpdate = true);
    try {
      await runUpdateCheck(context, isUser: true);
    } finally {
      if (mounted) setState(() => _checkingUpdate = false);
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法打开: $url')),
      );
    }
  }

  Future<void> _copy(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 已复制'), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final version = _info != null
        ? 'v${_info!.version} (${_info!.buildNumber})'
        : 'v? (?)';

    return Scaffold(
      appBar: AppBar(title: const Text('关于 Verstro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === 顶部 logo + 版本 ===
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                // Verstro 品牌 logo (v4 几何字母标记 V, 深靛蓝底 + 青).
                // 源矢量 assets/images/verstro_logo.svg; icon.png 是其 550px 光栅.
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/images/icon.png',
                    width: 84,
                    height: 84,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Verstro',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  version,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                ),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: _checkingUpdate ? null : _checkUpdate,
                  icon: _checkingUpdate
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.system_update, size: 18),
                  label: Text(_checkingUpdate ? '检查中…' : '检查更新'),
                ),
                const SizedBox(height: 4),
                Text(
                  '隐私优先的全球网络',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // === 客服 ===
          _Section(
            title: '联系与支持',
            children: [
              _LinkTile(
                icon: Icons.telegram,
                title: 'Telegram 客服',
                subtitle: '@verstro_support',
                onTap: () => _open('https://t.me/verstro_support'),
              ),
              // feedback@verstro.com 走 CF Email Routing 收信(已开通);
              // 勿用 hello@mail.verstro.com —— mail.* 是 Resend 只发不收域, 无收信 MX, 回信会退。
              _LinkTile(
                icon: Icons.email_outlined,
                title: '邮件',
                subtitle: 'feedback@verstro.com',
                onTap: () => _open('mailto:feedback@verstro.com'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // === 官网 ===
          _Section(
            title: '官网',
            children: [
              _DomainTile(domain: 'verstro.com', onCopy: () => _copy('https://verstro.com', '官网地址')),
            ],
          ),

          const SizedBox(height: 12),

          // === 隐私承诺 ===
          _Section(
            title: '隐私承诺',
            children: [
              _InfoText(
                  '• 邮箱仅用于支付通知和找回密码, 不发营销邮件\n'
                  '• 不收集设备 ID / 位置 / 通讯录 / 联系人\n'
                  '• 流量统计仅记录用量, 不记录内容\n'
                  '• 收款经自建链上接收, 不经过第三方托管'),
            ],
          ),

          const SizedBox(height: 12),

          // === 致谢 ===
          _Section(
            title: '致谢',
            children: [
              _InfoText(
                  '感谢 FlClash (chen08209)、Mihomo (Clash.Meta) 团队、sing-box 团队, '
                  '以及整个开源网络社区. Verstro 的网络能力建立在这些项目之上.'),
            ],
          ),

          const SizedBox(height: 12),

          // === 开源与许可 (GPLv3 合规入口) ===
          _Section(
            title: '开源与许可',
            children: [
              const _InfoText(
                  'Verstro 客户端基于开源项目 FlClash (GPLv3) 衍生, '
                  '内核为 Mihomo / sing-box (均 GPLv3). 依据 GPLv3, '
                  '本客户端的完整源代码对外公开.'),
              _LinkTile(
                icon: Icons.code,
                title: '源代码与许可证',
                subtitle: 'verstro.com/opensource',
                onTap: () => _open(kVerstroSourceUrl),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // === Build info (debug) ===
          if (_info != null)
            Center(
              child: Text(
                'Build: ${_info!.packageName} • ${_info!.buildSignature.isNotEmpty ? _info!.buildSignature.substring(0, _info!.buildSignature.length.clamp(0, 12)) : "-"}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                      fontSize: 10,
                    ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ============================================================
// 子组件
// ============================================================

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _DomainTile extends StatelessWidget {
  final String domain;
  final VoidCallback onCopy;

  const _DomainTile({required this.domain, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(Icons.domain, color: Theme.of(context).colorScheme.primary),
      title: SelectableText(
        domain,
        style: const TextStyle(fontFamily: 'monospace'),
      ),
      trailing: IconButton(
        tooltip: '复制 https://$domain',
        icon: const Icon(Icons.copy, size: 18),
        onPressed: onCopy,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;

  const _InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
      ),
    );
  }
}
