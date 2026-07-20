// 分享推广页 — 营销海报(可存 PNG) + 分享文案(可复制)
//
// 路由: 设置页「分享 Verstro」/ 推广中心「分享海报」→ Navigator.push
// 数据: agentProvider(邀请码/双边奖励额) + trialStatusProvider(试用开关/天数)
//   金额与试用全部实时取自后端配置, 不硬编码 —— 运营改配置, 海报/文案自动跟随。
// 导出: RepaintBoundary.toImage(pixelRatio: 3) → 360×480 逻辑 = 1080×1440 px(3:4),
//   经 picker.saveFile 走全平台已有保存路径(Android SAF / 桌面另存对话框)。
//
// 文案口径(全部风格统一遵守):
//   - 不承诺「免费 / 无限流量」—— 试用句仅在 trial enabled 时拼入
//   - 不用「解锁地域限制」类措辞, 统一「全球网络」
//   - TUN 等技术词只进「开发者向」风格
//
// 海报配色硬编码品牌 token(取自 verstro_logo.svg 实色), 不随 App 主题变 ——
// 营销物料要求跨设备/跨主题渲染一致。

import 'dart:ui' as ui;

import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../providers/agent_provider.dart';
import '../providers/trial_provider.dart';

/// 分享物料统一落地域名(与文案库口径一致, 勿用 get.* 等副本域名)。
const String kVerstroSiteUrl = 'https://verstro.com';

// ── 海报品牌 token(verstro_logo.svg 实色) ────────────────────────────────────
const _navy900 = Color(0xFF0B1726); // 底色(logo 背景渐变终点)
const _navy800 = Color(0xFF16324F); // 底色渐变起点(派生)
const _navy700 = Color(0xFF142C47); // 行动面板底
const _aqua = Color(0xFF7DF2DE); // 强调(logo V 渐变起点)
const _teal = Color(0xFF10A696); // 深强调(logo V 渐变终点)
const _mist = Color(0xFF9FB6CC); // 次级文字

// ============================================================
// 分享文案(纯函数, 供页面与单测)
// ============================================================

enum ShareCopyStyle {
  general,
  brief,
  developer;

  String get label => switch (this) {
        general => appLocalizations.vShareStyleGeneral,
        brief => appLocalizations.vShareStyleBrief,
        developer => appLocalizations.vShareStyleDeveloper,
      };
}

/// cents → "$2" / "$2.50"(整额不带小数, 文案更口语)。
String fmtUsdShort(int cents) => cents % 100 == 0
    ? '\$${cents ~/ 100}'
    : '\$${(cents / 100).toStringAsFixed(2)}';

/// 邀请句: 奖励三分支(相等>0 / 仅受众额>0 / 无奖励), code 为空整句省略。
/// 只对受众陈述其可得利益, 不展示分享者收益。
/// 「首购后」不可省: 奖励在被推荐人首笔付费履约时发放(后端
/// GrantFirstPurchaseRewards), 注册瞬间不到账, 措辞须与真实时机一致。
String _inviteSentence({
  required String code,
  required int refereeRewardCents,
  required int referrerRewardCents,
  required bool brief,
}) {
  if (code.isEmpty) return '';
  final prefix = brief
      ? appLocalizations.vShareInvitePrefixBrief(code)
      : appLocalizations.vShareInvitePrefix(code);
  if (refereeRewardCents > 0 && refereeRewardCents == referrerRewardCents) {
    return appLocalizations.vShareInviteBoth(
        prefix, fmtUsdShort(refereeRewardCents));
  }
  if (refereeRewardCents > 0) {
    return appLocalizations.vShareInviteReferee(
        prefix, fmtUsdShort(refereeRewardCents));
  }
  return appLocalizations.vShareInvitePlain(prefix);
}

/// 组装分享文案。奖励/试用参数实时来自后端, 文案句式随之增减。
String buildShareText({
  required ShareCopyStyle style,
  required String code,
  required int refereeRewardCents,
  required int referrerRewardCents,
  required bool trialEnabled,
  required int trialDays,
}) {
  final invite = _inviteSentence(
    code: code,
    refereeRewardCents: refereeRewardCents,
    referrerRewardCents: referrerRewardCents,
    brief: style != ShareCopyStyle.general,
  );
  switch (style) {
    case ShareCopyStyle.general:
      final trial = trialEnabled
          ? (trialDays > 0
              ? appLocalizations.vShareTrialGeneralDays(trialDays)
              : appLocalizations.vShareTrialGeneral)
          : '';
      return appLocalizations.vShareCopyGeneral(
          trial, invite, kVerstroSiteUrl);
    case ShareCopyStyle.brief:
      final trial =
          trialEnabled ? appLocalizations.vShareTrialShort : '';
      return appLocalizations.vShareCopyBrief(trial, invite, kVerstroSiteUrl);
    case ShareCopyStyle.developer:
      final trial =
          trialEnabled ? appLocalizations.vShareTrialShort : '';
      return appLocalizations.vShareCopyDev(trial, invite, kVerstroSiteUrl);
  }
}

// ============================================================
// 分享页
// ============================================================

class VerstroSharePage extends ConsumerStatefulWidget {
  const VerstroSharePage({super.key});

  @override
  ConsumerState<VerstroSharePage> createState() => _SharePageState();
}

class _SharePageState extends ConsumerState<VerstroSharePage> {
  final GlobalKey _posterKey = GlobalKey();
  ShareCopyStyle _style = ShareCopyStyle.general;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 预解码 logo 位图, 防止首次导出时 Image.asset 尚未加载渲染成空白。
    precacheImage(const AssetImage('assets/images/icon.png'), context);
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
    );
  }

  Future<void> _savePoster() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      // 等当前帧收尾, 确保 boundary 无待重绘内容再截取。
      await WidgetsBinding.instance.endOfFrame;
      final boundary = _posterKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        _toast(appLocalizations.vSharePosterNotReady);
        return;
      }
      final image = await boundary.toImage(pixelRatio: 3.0);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (data == null) {
        _toast(appLocalizations.vSharePosterGenFailed);
        return;
      }
      final path = await picker.saveFile(
          appLocalizations.vSharePosterFileName, data.buffer.asUint8List());
      _toast(path == null
          ? appLocalizations.vShareSaveCanceled
          : appLocalizations.vSharePosterSaved);
    } catch (_) {
      _toast(appLocalizations.vShareSaveFailed);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _toast(appLocalizations.vAgentShareTextCopied);
  }

  @override
  Widget build(BuildContext context) {
    final agent = ref.watch(agentProvider);
    // Riverpod 3: AsyncValue.value 即 data-or-null, 错误态不抛。
    final trial = ref.watch(trialStatusProvider).value;
    final trialEnabled = trial?.enabled ?? false;

    // 文案与海报共用同一份数据; 加载中/失败时降级为无码版(品牌+二维码仍完整)。
    final a = agent.value;
    final shareText = buildShareText(
      style: _style,
      code: a?.code ?? '',
      refereeRewardCents: a?.refereeRewardCents ?? 0,
      referrerRewardCents: a?.referrerRewardCents ?? 0,
      trialEnabled: trialEnabled,
      trialDays: trial?.days ?? 0,
    );

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vSharePageTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 海报预览 ──────────────────────────────────────────────────────
          Center(
            child: agent.isLoading && a == null
                ? const SizedBox(
                    width: 288,
                    height: 384,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _PosterPreview(
                    posterKey: _posterKey,
                    poster: SharePoster(
                      code: a?.code ?? '',
                      refereeRewardCents: a?.refereeRewardCents ?? 0,
                      referrerRewardCents: a?.referrerRewardCents ?? 0,
                      trialEnabled: trialEnabled,
                      trialDays: trial?.days ?? 0,
                      trialTrafficGb: trial?.trafficGb ?? 0,
                    ),
                  ),
          ),
          if (agent.hasError) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline,
                    size: 16, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 4),
                Text(appLocalizations.vShareCodeLoadFailed,
                    style: const TextStyle(fontSize: 12)),
                TextButton(
                  onPressed: () => ref.invalidate(agentProvider),
                  child: Text(appLocalizations.vAgentRetry),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 288,
              child: FilledButton.icon(
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_alt),
                label: Text(_saving
                    ? appLocalizations.vShareGenerating
                    : appLocalizations.vShareSaveImage),
                onPressed: _saving ? null : _savePoster,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── 分享文案 ──────────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appLocalizations.vShareCopyTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final s in ShareCopyStyle.values)
                        ChoiceChip(
                          label: Text(s.label),
                          selected: _style == s,
                          onSelected: (_) => setState(() => _style = s),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      shareText,
                      style: const TextStyle(fontSize: 13.5, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      icon: const Icon(Icons.copy, size: 18),
                      label: Text(appLocalizations.vShareCopyButton),
                      onPressed: () => _copyText(shareText),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// 海报预览容器: 阴影 + 圆角裁切仅作用于屏幕预览;
/// RepaintBoundary 在裁切之内、按 360×480 原始布局截取 → 导出图是无圆角全幅。
class _PosterPreview extends StatelessWidget {
  final GlobalKey posterKey;
  final SharePoster poster;

  const _PosterPreview({required this.posterKey, required this.poster});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 288,
          height: 384,
          child: FittedBox(
            child: RepaintBoundary(key: posterKey, child: poster),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 海报(纯渲染, 360×480 逻辑尺寸)
// ============================================================

class SharePoster extends StatelessWidget {
  final String code;
  final int refereeRewardCents;
  final int referrerRewardCents;
  final bool trialEnabled;
  final int trialDays;
  final int trialTrafficGb;

  const SharePoster({
    super.key,
    required this.code,
    required this.refereeRewardCents,
    required this.referrerRewardCents,
    required this.trialEnabled,
    required this.trialDays,
    required this.trialTrafficGb,
  });

  // 海报上的奖励行(受众视角, 与文案库奖励三分支同规则)。
  // 「首购后」与文案句同理不可省 —— 到账时机是首笔付费履约, 非注册瞬间。
  String get _rewardLine {
    if (refereeRewardCents > 0 && refereeRewardCents == referrerRewardCents) {
      return appLocalizations
          .vSharePosterRewardBoth(fmtUsdShort(refereeRewardCents));
    }
    if (refereeRewardCents > 0) {
      return appLocalizations
          .vSharePosterRewardReferee(fmtUsdShort(refereeRewardCents));
    }
    return appLocalizations.vSharePosterRewardNone;
  }

  String get _trialLine {
    final days = trialDays > 0
        ? appLocalizations.vSharePosterTrialDays(trialDays)
        : appLocalizations.vSharePosterTrialGeneric;
    final gb = trialTrafficGb > 0 ? ' · ${trialTrafficGb}GB' : '';
    return appLocalizations.vSharePosterTrialLine(days, gb);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 480,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_navy800, _navy900],
          stops: [0, 0.6],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // V 字水印: 品牌几何标 ghost 化, 加纵深不抢内容。
          Positioned(
            top: -36,
            right: -56,
            child: CustomPaint(
              size: const Size(260, 260),
              painter: _VMarkPainter(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _brandRow(),
                const SizedBox(height: 22),
                Expanded(child: _meridianSection()),
                const SizedBox(height: 14),
                _actionPanel(),
                const SizedBox(height: 9),
                Center(
                  child: Text(
                    appLocalizations.vSharePosterFooter,
                    style: const TextStyle(
                      color: Color(0xB39FB6CC), // mist 70%
                      fontSize: 9.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandRow() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.asset(
            'assets/images/icon.png',
            width: 38,
            height: 38,
            filterQuality: FilterQuality.medium,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verstro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              appLocalizations.vSharePosterTagline,
              style: const TextStyle(color: _mist, fontSize: 11, height: 1.1),
            ),
          ],
        ),
      ],
    );
  }

  /// 中段: 左缘「连接经线」(一条路由竖线, 卖点行是线上的节点) + 标题/卖点/试用。
  /// 内容包在 FittedBox(scaleDown) 里 —— 跨端字体度量有差异, 固定画板绝不允许
  /// 溢出, 放不下时整体微缩而非截断。
  Widget _meridianSection() {
    final features = [
      (
        appLocalizations.vSharePosterFeat1Label,
        appLocalizations.vSharePosterFeat1Desc
      ),
      (
        appLocalizations.vSharePosterFeat2Label,
        appLocalizations.vSharePosterFeat2Desc
      ),
      (
        appLocalizations.vSharePosterFeat3Label,
        appLocalizations.vSharePosterFeat3Desc
      ),
      (appLocalizations.vSharePosterFeat4Label, 'Android · iOS · Windows · macOS'),
    ];
    // 画板 360 - 左右 padding 24×2
    const contentWidth = 312.0;
    return Stack(
      children: [
        // 经线自上而下 aqua→teal 渐变: 路由通向底部行动面板, 颜色随之下沉。
        // 贯穿整个中段(可长于内容), 视觉上把品牌区与行动面板连成一条链路。
        Positioned(
          left: 5.25,
          top: 6,
          bottom: 6,
          child: Container(
            width: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _aqua.withValues(alpha: 0.3),
                  _teal.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: contentWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      appLocalizations.vSharePosterHeadline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      appLocalizations.vSharePosterSubline,
                      style: const TextStyle(
                          color: _mist, fontSize: 13.5, height: 1.2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final (label, desc) in features) ...[
                    _featureRow(label, desc),
                    const SizedBox(height: 11),
                  ],
                  if (trialEnabled) ...[
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: _trialPill(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureRow(String label, String desc) {
    return Row(
      children: [
        // 节点圆点: 落在经线正中(x=6), 与线宽共用同一坐标系。
        SizedBox(
          width: 12,
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _aqua,
                boxShadow: [
                  BoxShadow(
                    color: _aqua.withValues(alpha: 0.45),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: '   '),
                TextSpan(
                  text: desc,
                  style: const TextStyle(color: _mist, fontSize: 11.5),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _trialPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _aqua.withValues(alpha: 0.38)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 13, color: _aqua),
          const SizedBox(width: 5),
          Text(
            _trialLine,
            style: const TextStyle(
              color: _aqua,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 行动面板: 二维码(白底保扫码率) + 邀请码/奖励/域名。无码时降级为纯下载引导。
  Widget _actionPanel() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _navy700,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: QrImageView(
              data: kVerstroSiteUrl,
              version: QrVersions.auto,
              size: 82,
              gapless: false,
              padding: EdgeInsets.zero,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: code.isNotEmpty ? _invitePanel() : _downloadPanel(),
          ),
        ],
      ),
    );
  }

  Widget _invitePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.vAgentInviteCode,
          style: const TextStyle(color: _mist, fontSize: 10, letterSpacing: 3),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            code,
            style: const TextStyle(
              color: _aqua,
              fontSize: 21,
              fontWeight: FontWeight.w600,
              fontFamily: 'JetBrainsMono',
              letterSpacing: 2,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 5),
        // maxLines 2: 奖励行加「首购后」后接近列宽, 字体度量差异下允许软换行;
        // 文本列(~76px)矮于 QR(92px), 多一行不会撑高面板。
        Text(
          _rewardLine,
          maxLines: 2,
          style: const TextStyle(color: Colors.white, fontSize: 11.5, height: 1.3),
        ),
        const SizedBox(height: 7),
        // 中文提示走系统字体, URL 保持等宽(JetBrainsMono 无 CJK 字形)
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${appLocalizations.vSharePosterScanHint} · ',
                style: const TextStyle(color: _mist, fontSize: 10.5),
              ),
              const TextSpan(
                text: 'verstro.com',
                style: TextStyle(
                  color: _mist,
                  fontSize: 10.5,
                  fontFamily: 'JetBrainsMono',
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _downloadPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.vSharePosterGetVerstro,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          appLocalizations.vSharePosterScanSite,
          style: const TextStyle(color: _mist, fontSize: 11.5),
        ),
        const SizedBox(height: 8),
        const Text(
          'verstro.com',
          style: TextStyle(
            color: _mist,
            fontSize: 10.5,
            fontFamily: 'JetBrainsMono',
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// V 字品牌标水印: 转录 assets/images/verstro_logo.svg 的 path(1024 viewBox),
/// 按目标尺寸等比缩放。渐变不参与 —— 水印用单色低透明度。
class _VMarkPainter extends CustomPainter {
  final Color color;

  const _VMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 1024;
    final path = Path()
      ..moveTo(312 * s, 296 * s)
      ..lineTo(432 * s, 296 * s)
      ..lineTo(512 * s, 540 * s)
      ..lineTo(592 * s, 296 * s)
      ..lineTo(712 * s, 296 * s)
      ..lineTo(560 * s, 740 * s)
      ..quadraticBezierTo(512 * s, 772 * s, 464 * s, 740 * s)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_VMarkPainter oldDelegate) => color != oldDelegate.color;
}
