// 推广中心页 (Task 3 — 邀请码/分享 + 佣金钱包 + 提现)
// 设价区 (Task 4 — reseller/master 套餐售价设置, 夹 [floorCents, listCents]) 在本文件.
//
// 路由: AgentEntryCard (plan_picker / account_page) → Navigator.push
// 数据: agentProvider (Task 1 扩后 AgentDto) / agentPricesProvider (AgentPricesDto)
// 提现: 二次确认 + TRC20 客户端校验 + requestPayout → SnackBar
// 设价: reseller/master tier 时显示; 每套餐独立夹 [floorCents, listCents]

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../api/api_models.dart';
import '../providers/agent_provider.dart';
import '../providers/backend_api_provider.dart';

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
        return '总代';
      case 'reseller':
        return '代理';
      default:
        return '推广员';
    }
  }

  // ── 提现流程 ──────────────────────────────────────────────────────────────
  Future<void> _payout(int availableCents) async {
    _payoutAddrCtrl.clear(); // 每次打开弹窗前重置
    String? err;

    // Step 1: 输入 TRC20 地址 (带客户端校验)
    final dest = await showDialog<String>(
      context: context,
      barrierDismissible: false, // 堵 barrier-pop(避免带焦点点外部关闭触发 _dependents 断言)
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('提现到 TRC20 地址'),
          content: TextField(
            controller: _payoutAddrCtrl,
            decoration: InputDecoration(
              labelText: 'TRC20 地址 (T 开头, 34 位)',
              errorText: err,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(ctx).unfocus(); // 关弹窗前释放焦点, 避免 TextField 焦点 teardown 崩溃
                Navigator.pop(ctx);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (!_isTrc20(_payoutAddrCtrl.text)) {
                  setLocal(() => err = '请输入有效 TRC20 地址');
                  return;
                }
                FocusScope.of(ctx).unfocus(); // 同上: pop 前先释放焦点
                Navigator.pop(ctx, _payoutAddrCtrl.text.trim());
              },
              child: const Text('下一步'),
            ),
          ],
        ),
      ),
    );
    if (dest == null || !mounted) return;

    // Step 2: 二次确认 (显金额 + 地址)
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认提现'),
        content: Text(
          '提现 ${_usd(availableCents)} 到\n$dest\n\n确认后将发起链上转账，地址不可改，请核对。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('再想想'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('确认提现'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    // Step 3: 调 API 提交
    setState(() => _payoutBusy = true);
    try {
      final api = await ref.read(backendApiProvider.future);
      final amt = await api.requestPayout(dest);
      if (!mounted) return;
      ref.invalidate(agentProvider);
      _toast('提现申请已提交 (${_usd(amt)})');
    } on BackendException catch (e) {
      _toast(e.message);
    } catch (e) {
      _toast('提现失败，请重试');
    } finally {
      if (mounted) setState(() => _payoutBusy = false);
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
          title: Text('设 ${p.planId} 售价'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('可用区间 ${_usd(p.floorCents)} ~ ${_usd(p.listCents)} (只许折扣)'),
              const SizedBox(height: 8),
              TextField(
                controller: _priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: '售价 (USD)',
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
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final v = double.tryParse(_priceCtrl.text.trim());
                if (v == null) {
                  setLocal(() => err = '请输入数字');
                  return;
                }
                final cents = (v * 100).round();
                if (cents < p.floorCents || cents > p.listCents) {
                  setLocal(() =>
                      err = '须在 ${_usd(p.floorCents)} ~ ${_usd(p.listCents)} 之间');
                  return;
                }
                FocusScope.of(ctx).unfocus();
                Navigator.pop(ctx, v);
              },
              child: const Text('保存'),
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
      _toast('已设 ${p.planId} 售价 \$${result.toStringAsFixed(2)}');
    } on BackendException catch (e) {
      _toast(e.message);
    } catch (e) {
      _toast('设价失败，请重试');
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('推广中心')),
      body: ref.watch(agentProvider).when(
            data: (a) => _buildBody(context, a),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('加载失败'),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(agentProvider),
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildBody(BuildContext context, AgentDto a) {
    final scheme = Theme.of(context).colorScheme;
    final shareText =
        '用我的邀请码 ${a.code} 注册 Verstro，首次购买你也有奖励！下载：https://get.verstro.com';

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
                  Text('邀请码', style: Theme.of(context).textTheme.titleMedium),
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
                    tooltip: '复制邀请码',
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copy(a.code, '已复制邀请码'),
                  ),
                ]),
                const SizedBox(height: 8),
                // 复制分享文案按钮
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: const Text('复制分享文案'),
                    onPressed: () => _copy(shareText, '分享文案已复制'),
                  ),
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
                Text('佣金钱包', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                // 可提现金额 — 主色大字
                Text(
                  '可提现 ${_usd(a.availableCents)}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text('待成熟 ${_usd(a.pendingCents)}',
                    style: Theme.of(context).textTheme.bodyMedium),
                Text('已提现 ${_usd(a.paidCents)}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text('已邀请 ${a.directCount} 人',
                    style: Theme.of(context).textTheme.bodySmall),
                // 下线信息 (reseller/master 有 sub agent)
                if (a.subAgentCount > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '下线 ${a.subAgentCount} 人 · override 可提 ${_usd(a.overrideAvailableCents)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── 提现区 ──────────────────────────────────────────────────────────
        if (a.availableCents >= 1000) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _payoutBusy ? null : () => _payout(a.availableCents),
              child: _payoutBusy
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('提现到 TRC20'),
            ),
          ),
        ] else ...[
          Center(
            child: Text(
              '满 \$10 可提现 (当前 ${_usd(a.availableCents)})',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSurface.withValues(alpha: 0.5)),
            ),
          ),
        ],

        // ── 设价区 (Task 4 — 仅 reseller/master 显示) ──────────────────────
        if (a.tier == 'reseller' || a.tier == 'master') ...[
          const SizedBox(height: 20),
          Text('套餐定价', style: Theme.of(context).textTheme.titleMedium),
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
                  '套餐 ${p.planId}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              TextButton(
                onPressed: () => _setPrice(p),
                child: const Text('改价'),
              ),
            ]),
            Text(
              '平台价 ${_usd(p.listCents)} · 你的拿货价 ${_usd(p.floorCents)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              p.customCents != null
                  ? '你的售价 ${_usd(p.customCents!)} · 每单赚 ${_usd(earns!)}'
                  : '未设 (按平台价 ${_usd(p.listCents)} 收)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
