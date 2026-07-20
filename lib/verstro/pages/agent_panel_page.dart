// 推广中心页 (Task 3 — 邀请码/分享 + 佣金钱包 + 提现)
// 设价区 (Task 4 — reseller/master 套餐售价设置, 夹 [floorCents, listCents]) 在本文件.
//
// 路由: AgentEntryCard (plan_picker / account_page) → Navigator.push
// 数据: agentProvider (Task 1 扩后 AgentDto) / agentPricesProvider (AgentPricesDto)
// 提现: 二次确认 + TRC20 客户端校验 + requestPayout → SnackBar
// 设价: reseller/master tier 时显示; 每套餐独立夹 [floorCents, listCents]

import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_exceptions.dart';
import '../api/api_models.dart';
import '../providers/agent_provider.dart';
import '../providers/backend_api_provider.dart';
import 'share_page.dart';

class VerstroAgentPanelPage extends ConsumerStatefulWidget {
  const VerstroAgentPanelPage({super.key});

  @override
  ConsumerState<VerstroAgentPanelPage> createState() =>
      _AgentPanelPageState();
}

class _AgentPanelPageState extends ConsumerState<VerstroAgentPanelPage> {
  bool _payoutBusy = false;

  // 提现/设价弹窗 controller 提为 State 字段, 避免 await showDialog 返回后
  // 退出动画期间 AnimatedBuilder 向已 dispose 的 controller addListener 崩溃
  final TextEditingController _payoutAddrCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();

  @override
  void dispose() {
    _payoutAddrCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  // 金额 cents → "$X.XX" 显示
  static String _usd(int c) => '\$${(c / 100).toStringAsFixed(2)}';

  // 复制到剪贴板 + SnackBar 提示
  void _copy(String text, String toast) {
    Clipboard.setData(ClipboardData(text: text));
    _toast(toast);
  }

  // mounted 守护的 SnackBar
  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
    );
  }

  // TRC20 地址客户端预校验: T 开头 + Base58 字符共 34 位
  bool _isTrc20(String s) =>
      RegExp(r'^T[1-9A-HJ-NP-Za-km-z]{33}$').hasMatch(s.trim());

  // tier → 中文显示名
  static String _tierLabel(String tier) {
    switch (tier) {
      case 'master':
        return appLocalizations.vAgentTierMaster;
      case 'reseller':
        return appLocalizations.vAgentTierReseller;
      default:
        return appLocalizations.vAgentTierPromoter;
    }
  }

  // ── 提现流程 ──────────────────────────────────────────────────────────────
  // minCents 用于 below_min_payout 错误映射的文案 (动态门槛, 旧后端 fallback $10)
  Future<void> _payout(int availableCents, int minCents) async {
    _payoutAddrCtrl.clear(); // 每次打开弹窗前重置
    String? err;

    // Step 1: 输入 TRC20 地址 (带客户端校验)
    final dest = await showDialog<String>(
      context: context,
      barrierDismissible: false, // 堵 barrier-pop(避免带焦点点外部关闭触发 _dependents 断言)
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(appLocalizations.vAgentPayoutDialogTitle),
          content: TextField(
            controller: _payoutAddrCtrl,
            decoration: InputDecoration(
              labelText: appLocalizations.vAgentPayoutAddrLabel,
              errorText: err,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(ctx).unfocus(); // 关弹窗前释放焦点, 避免 TextField 焦点 teardown 崩溃
                Navigator.pop(ctx);
              },
              child: Text(appLocalizations.cancel),
            ),
            TextButton(
              onPressed: () {
                if (!_isTrc20(_payoutAddrCtrl.text)) {
                  setLocal(() => err = appLocalizations.vAgentPayoutAddrInvalid);
                  return;
                }
                FocusScope.of(ctx).unfocus(); // 同上: pop 前先释放焦点
                Navigator.pop(ctx, _payoutAddrCtrl.text.trim());
              },
              child: Text(appLocalizations.vAgentNextStep),
            ),
          ],
        ),
      ),
    );
    if (dest == null || !mounted) return;

    // Step 2: 二次确认 (显金额 + 地址; 人工打款口径, 不再说"发起链上转账")
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appLocalizations.vAgentPayoutConfirm),
        content: Text(
          appLocalizations.vAgentPayoutConfirmContent(
            _usd(availableCents),
            dest,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(appLocalizations.vAgentPayoutThinkAgain),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(appLocalizations.vAgentPayoutConfirm),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    // Step 3: 调 API 提交
    setState(() => _payoutBusy = true);
    try {
      final api = await ref.read(backendApiProvider.future);
      await api.requestPayout(dest);
      if (!mounted) return;
      ref.invalidate(agentProvider);
      _toast(appLocalizations.vAgentPayoutSubmitted);
    } on BackendException catch (e) {
      // 错误 code → 中文人话映射; 未知 code 直出后端 message
      if (e.code == 'below_min_payout') {
        _toast(appLocalizations.vAgentPayoutBelowMin(_usd(minCents)));
      } else if (e.code == 'payout_in_progress') {
        _toast(appLocalizations.vAgentPayoutInProgress);
      } else if (e.code == 'invalid_dest') {
        _toast(appLocalizations.vAgentPayoutInvalidDest);
      } else {
        _toast(e.message.isNotEmpty
            ? e.message
            : appLocalizations.vAgentPayoutFailed);
      }
    } catch (e) {
      _toast(appLocalizations.vAgentPayoutFailed);
    } finally {
      if (mounted) setState(() => _payoutBusy = false);
    }
  }

  // TronScan 交易详情页 (payout txid 可核验)
  Future<void> _openTronScan(String txid) async {
    final uri = Uri.parse('https://tronscan.org/#/transaction/$txid');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _toast(appLocalizations.vAgentOpenBrowserFailed);
    }
  }

  // ── 设价流程 (Task 4) ─────────────────────────────────────────────────────
  Future<void> _setPrice(AgentPlanPriceDto p) async {
    // 每次打开弹窗前重置为当前套餐价格
    _priceCtrl.text = ((p.customCents ?? p.listCents) / 100).toStringAsFixed(2);
    String? err;

    final result = await showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(appLocalizations.vAgentSetPriceTitle(p.planId)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(appLocalizations.vAgentPriceRangeHint(
                  _usd(p.floorCents), _usd(p.listCents))),
              const SizedBox(height: 8),
              TextField(
                controller: _priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: appLocalizations.vAgentPriceLabel,
                  errorText: err,
                  prefixText: '\$',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(ctx).unfocus();
                Navigator.pop(ctx);
              },
              child: Text(appLocalizations.cancel),
            ),
            TextButton(
              onPressed: () {
                final v = double.tryParse(_priceCtrl.text.trim());
                if (v == null) {
                  setLocal(() => err = appLocalizations.vAgentPriceNotNumber);
                  return;
                }
                final cents = (v * 100).round();
                if (cents < p.floorCents || cents > p.listCents) {
                  setLocal(() => err = appLocalizations.vAgentPriceOutOfRange(
                      _usd(p.floorCents), _usd(p.listCents)));
                  return;
                }
                FocusScope.of(ctx).unfocus();
                Navigator.pop(ctx, v);
              },
              child: Text(appLocalizations.save),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;

    try {
      final api = await ref.read(backendApiProvider.future);
      await api.setAgentPrice(p.planId, (result * 100).round());
      if (!mounted) return;
      ref.invalidate(agentPricesProvider);
      _toast(appLocalizations.vAgentPriceSetSuccess(
          p.planId, '\$${result.toStringAsFixed(2)}'));
    } on BackendException catch (e) {
      _toast(e.message);
    } catch (e) {
      _toast(appLocalizations.vAgentPriceSetFailed);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vAgentPanelTitle)),
      body: ref.watch(agentProvider).when(
            data: (a) => _buildBody(context, a),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(appLocalizations.vAgentLoadFailed),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(agentProvider),
                    child: Text(appLocalizations.vAgentRetry),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildBody(BuildContext context, AgentDto a) {
    final scheme = Theme.of(context).colorScheme;
    // 提现门槛动态化: 后端 min_payout_cents 优先, 旧后端 (0) 回退 $10
    final minCents = a.minPayoutCents > 0 ? a.minPayoutCents : 1000;
    // 落地域名统一 verstro.com(文案库口径), 勿再用 get.* 副本域名。
    final shareText =
        appLocalizations.vAgentShareText(a.code, kVerstroSiteUrl);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── 邀请码区 ────────────────────────────────────────────────────────
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行 + tier 徽章
                Row(children: [
                  Icon(Icons.card_giftcard, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(appLocalizations.vAgentInviteCode,
                      style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  Chip(
                    label: Text(_tierLabel(a.tier)),
                    visualDensity: VisualDensity.compact,
                  ),
                ]),
                const SizedBox(height: 12),
                // 邀请码 (等宽可选)
                Row(children: [
                  Expanded(
                    child: SelectableText(
                      a.code,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                    ),
                  ),
                  IconButton(
                    tooltip: appLocalizations.vAgentCopyInviteCode,
                    icon: const Icon(Icons.copy),
                    onPressed: () =>
                        _copy(a.code, appLocalizations.vAgentInviteCodeCopied),
                  ),
                ]),
                const SizedBox(height: 8),
                // 复制分享文案 + 分享海报(海报页含图片保存与多风格文案)
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: Text(appLocalizations.vAgentCopyShareText),
                      onPressed: () => _copy(
                          shareText, appLocalizations.vAgentShareTextCopied),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: Text(appLocalizations.vAgentSharePoster),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VerstroSharePage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── 佣金钱包区 ──────────────────────────────────────────────────────
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appLocalizations.vAgentWalletTitle,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                // 可提现金额 — 主色大字
                Text(
                  appLocalizations.vAgentAvailable(_usd(a.availableCents)),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                // 钱包四态: 可提现(上面主数字) / 待成熟 / 处理中(>0 才显) / 已打款
                Text(appLocalizations.vAgentPending(_usd(a.pendingCents)),
                    style: Theme.of(context).textTheme.bodyMedium),
                if (a.processingCents > 0)
                  Text(
                      appLocalizations
                          .vAgentProcessing(_usd(a.processingCents)),
                      style: Theme.of(context).textTheme.bodyMedium),
                Text(appLocalizations.vAgentPaid(_usd(a.paidCents)),
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(appLocalizations.vAgentInvitedCount(a.directCount),
                    style: Theme.of(context).textTheme.bodySmall),
                // 下线信息 (reseller/master 有 sub agent)
                if (a.subAgentCount > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    appLocalizations.vAgentSubAgentLine(
                        a.subAgentCount, _usd(a.overrideAvailableCents)),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── 提现区 ──────────────────────────────────────────────────────────
        // 前置守卫: 已有一笔在途 (requested) 时不允许再次发起
        if (a.processingCents > 0) ...[
          Center(
            child: Text(
              appLocalizations.vAgentPayoutGuardProcessing,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSurface.withValues(alpha: 0.5)),
            ),
          ),
        ] else if (a.availableCents >= minCents) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed:
                  _payoutBusy ? null : () => _payout(a.availableCents, minCents),
              child: _payoutBusy
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(appLocalizations.vAgentPayoutButton),
            ),
          ),
        ] else ...[
          Center(
            child: Text(
              appLocalizations.vAgentPayoutThreshold(
                  _usd(minCents), _usd(a.availableCents)),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSurface.withValues(alpha: 0.5)),
            ),
          ),
        ],

        // ── 提现记录区 (最近 10 条, 后端已截) ──────────────────────────────
        if (a.payouts.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(appLocalizations.vAgentPayoutHistory,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...a.payouts.map((p) => _buildPayoutTile(context, p)),
        ],

        // ── 设价区 (Task 4 — 仅 reseller/master 显示) ──────────────────────
        if (a.tier == 'reseller' || a.tier == 'master') ...[
          const SizedBox(height: 20),
          Text(appLocalizations.vAgentPlanPricing,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ref.watch(agentPricesProvider).maybeWhen(
            data: (prices) => Column(
              children: prices.prices.map((p) => _buildPriceCard(context, p)).toList(),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }

  // ── 设价区单卡 ────────────────────────────────────────────────────────────
  Widget _buildPriceCard(BuildContext context, AgentPlanPriceDto p) {
    final earns = p.customCents != null ? p.customCents! - p.floorCents : null;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(
                  appLocalizations.vAgentPlanTitle(p.planId),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              TextButton(
                onPressed: () => _setPrice(p),
                child: Text(appLocalizations.vAgentChangePrice),
              ),
            ]),
            Text(
              appLocalizations.vAgentPlatformFloorLine(
                  _usd(p.listCents), _usd(p.floorCents)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              p.customCents != null
                  ? appLocalizations.vAgentYourPriceLine(
                      _usd(p.customCents!), _usd(earns!))
                  : appLocalizations.vAgentPriceUnset(_usd(p.listCents)),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  // ── 提现记录 ─────────────────────────────────────────────────────────────

  // TRC20 地址打码: 前 6 + … + 后 4
  static String _maskDest(String s) =>
      s.length <= 10 ? s : '${s.substring(0, 6)}…${s.substring(s.length - 4)}';

  // txid 缩写: 前 8 + … + 后 8
  static String _shortTxid(String s) =>
      s.length <= 16 ? s : '${s.substring(0, 8)}…${s.substring(s.length - 8)}';

  // yyyy-MM-dd (本地时区)
  static String _dateLabel(DateTime? t) {
    if (t == null) return '';
    final d = t.toLocal();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  // payout status → 徽章文案/颜色: requested 橙 / sent 绿 / failed 灰
  static ({String label, Color color}) _payoutStatusBadge(
      ColorScheme scheme, String status) {
    switch (status) {
      case 'sent':
        return (
          label: appLocalizations.vAgentStatusSent,
          color: Colors.green.shade400
        );
      case 'failed':
        return (
          label: appLocalizations.vAgentStatusRefunded,
          color: scheme.onSurfaceVariant
        );
      default: // requested
        return (
          label: appLocalizations.vAgentStatusProcessing,
          color: Colors.orange.shade400
        );
    }
  }

  // 单条提现记录卡: 金额 + 状态徽章 + 日期 + 打码地址;
  // sent 加 txid 行 (复制 + TronScan 核验); failed 加退回说明.
  Widget _buildPayoutTile(BuildContext context, AgentPayoutDto p) {
    final scheme = Theme.of(context).colorScheme;
    final badge = _payoutStatusBadge(scheme, p.status);
    final date = _dateLabel(p.createdAt);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _usd(p.amountCents),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: badge.color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge.label,
                    style: TextStyle(
                      color: badge.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (date.isNotEmpty)
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              appLocalizations.vAgentDestLine(_maskDest(p.dest)),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
            ),
            if (p.status == 'sent' && (p.txid?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'tx: ${_shortTxid(p.txid!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontFamily: 'monospace',
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: appLocalizations.vAgentCopyTxid,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.copy, size: 14),
                    onPressed: () =>
                        _copy(p.txid!, appLocalizations.vAgentTxidCopied),
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => _openTronScan(p.txid!),
                    child: Text(appLocalizations.vAgentViewOnTronScan,
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
            if (p.status == 'failed') ...[
              const SizedBox(height: 2),
              Text(
                appLocalizations.vAgentPayoutRefundedDesc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
