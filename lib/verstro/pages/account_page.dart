// AccountPage — Verstro 用户账户主页 (阶段 2.3.4)
//
// 已登录 + 有效订阅 → 显示此页 (取代之前简化版 _ActiveSubscriptionScreen).
// 已登录无订阅 / 已过期 → 显示 PlanPickerPage.
//
// 三个 section:
// 1. 用户信息: email + 邮箱验证状态
// 2. 订阅状态: 套餐 / 到期 / 流量限额 + 续费/升级按钮 + 订阅 URL (alpha)
// 3. 订单历史: 列表 (最多 100 条, backend listOrders limit), 状态徽章. waiting
//    订单点击 → 跳回 UsdtInvoicePage 继续付款.
//
// Pull-to-refresh 重新拉 orders + subscription.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/views/settings.dart';

import '../api/api_models.dart';
import '../providers/auth_provider.dart';
import '../widgets/credit_balance_card.dart';
import '../widgets/agent_entry_card.dart';
import '../providers/agent_provider.dart';
import '../providers/credit_provider.dart';
import '../providers/devices_provider.dart';
import '../providers/orders_provider.dart';
import 'plan_picker_page.dart';
import 'usdt_invoice_page.dart';

class VerstroAccountPage extends ConsumerWidget {
  const VerstroAccountPage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(subscriptionProvider);
    ref.invalidate(ordersListProvider);
    ref.invalidate(devicesListProvider);
    ref.invalidate(creditProvider);
    ref.invalidate(agentProvider);
    await Future.wait<dynamic>([
      ref.read(subscriptionProvider.future),
      ref.read(ordersListProvider.future),
      ref.read(devicesListProvider.future),
      ref.read(creditProvider.future),
      ref.read(agentProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider).value;
    final user = authState?.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的账号'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: () => _refresh(ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '设置',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsView()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (user != null) _UserCard(user: user),
            const SizedBox(height: 16),
            const _SubscriptionCard(),
            const SizedBox(height: 16),
            const CreditBalanceCard(),
            const AgentEntryCard(),
            // 订单历史收进二级页, 入口行放在「我的设备」上面 (低频交易内容渐进披露)
            const _OrderHistoryEntry(),
            const SizedBox(height: 24),
            Text(
              '我的设备',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 2),
            Text(
              '超出设备上限时, 登录新设备会自动登出最早活跃的那台',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            const _DevicesList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 订单历史入口行 + 二级页
// ============================================================

class _OrderHistoryEntry extends StatelessWidget {
  const _OrderHistoryEntry();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long),
        title: const Text('订单历史'),
        subtitle: const Text('查看历史订单与付款记录'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const VerstroOrderHistoryPage()),
        ),
      ),
    );
  }
}

// 订单历史二级页: 复用账号页的 _OrdersList (含状态徽章 + waiting 单点击续付)。
class VerstroOrderHistoryPage extends ConsumerWidget {
  const VerstroOrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('订单历史')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(ordersListProvider);
          await ref.read(ordersListProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [_OrdersList()],
        ),
      ),
    );
  }
}

// ============================================================
// 用户信息卡
// ============================================================

class _UserCard extends StatelessWidget {
  final UserDto user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                user.email.isNotEmpty ? user.email[0].toUpperCase() : '?',
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        user.isEmailVerified
                            ? Icons.verified_outlined
                            : Icons.info_outline,
                        size: 14,
                        color: user.isEmailVerified
                            ? Colors.green.shade400
                            : scheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.isEmailVerified ? '邮箱已验证' : '邮箱未验证 (找回密码用)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: user.isEmailVerified
                                  ? Colors.green.shade400
                                  : scheme.error,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 订阅状态卡
// ============================================================

class _SubscriptionCard extends ConsumerWidget {
  const _SubscriptionCard();

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0';
    final gb = bytes / (1024 * 1024 * 1024);
    if (gb >= 1024) return '${(gb / 1024).toStringAsFixed(1)} TB';
    return '${gb.toStringAsFixed(0)} GB';
  }

  String _planLabel(String? id) {
    switch (id) {
      case 'monthly':
        return '月付';
      case 'quarterly':
        return '季付';
      case 'yearly':
        return '年付';
      default:
        return id ?? '-';
    }
  }

  // 活跃(未过期)套餐的去重名称, 保持 grants 的 FEFO 顺序(最早到期在前).
  // 多套餐并存时卡片标题不能只挂某一个套餐(原来挂 current_plan_id=最后购买的, 会和聚合的到期/上限自相矛盾).
  List<String> _activePlanNames(SubscriptionDto sub) {
    final seen = <String>{};
    final names = <String>[];
    for (final g in sub.grants) {
      if (g.status == 'expired' || g.planName.isEmpty) continue;
      if (seen.add(g.planName)) names.add(g.planName);
    }
    return names;
  }

  String _remainingDays(DateTime? expiresAt) {
    if (expiresAt == null) return '-';
    final diff = expiresAt.difference(DateTime.now());
    if (diff.isNegative) return '已过期';
    if (diff.inDays >= 1) return '${diff.inDays} 天后';
    if (diff.inHours >= 1) return '${diff.inHours} 小时后';
    return '${diff.inMinutes} 分钟后';
  }

  void _goRenew(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VerstroPlanPickerPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(subscriptionProvider);
    final scheme = Theme.of(context).colorScheme;

    return subAsync.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: scheme.error),
                  const SizedBox(width: 8),
                  Text('订阅状态查询失败',
                      style: TextStyle(color: scheme.error, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              Text('$e', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(subscriptionProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      data: (sub) {
        if (!sub.hasSubscription) {
          return Card(
            color: scheme.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: scheme.primary),
                      const SizedBox(width: 8),
                      Text('暂无订阅',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '购买套餐后即可使用 Verstro VPN.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('购买套餐'),
                    onPressed: () => _goRenew(context),
                  ),
                ],
              ),
            ),
          );
        }

        final expired = sub.isExpired;
        // 多套餐(≥2 活跃)时徽标/套餐行不挂单个套餐, 改成"多套餐"/拼接名, 与聚合的到期/上限/总剩余一致;
        // 单套餐或旧后端(无 grants)回退原来的 current_plan_id 标签.
        final planNames = _activePlanNames(sub);
        final badgeLabel = planNames.length >= 2
            ? '多套餐'
            : (planNames.isNotEmpty ? planNames.first : _planLabel(sub.currentPlanId));
        final planValue =
            planNames.isEmpty ? _planLabel(sub.currentPlanId) : planNames.join(' + ');
        return Card(
          elevation: expired ? 1 : 3,
          color: expired
              ? scheme.errorContainer.withValues(alpha: 0.35)
              : scheme.primaryContainer.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: expired ? scheme.error : scheme.primary,
              width: expired ? 1 : 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      expired ? Icons.error_outline : Icons.verified,
                      color: expired ? scheme.error : Colors.green.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      expired ? '订阅已过期' : '订阅有效中',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    _PlanBadge(planLabel: badgeLabel),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(label: '套餐', value: planValue),
                _InfoRow(
                  label: '到期时间',
                  value: sub.periodExpiresAt != null
                      ? sub.periodExpiresAt!.toLocal().toString().split('.')[0]
                      : '-',
                ),
                _InfoRow(
                  label: '剩余',
                  value: _remainingDays(sub.periodExpiresAt),
                  valueColor: expired ? scheme.error : null,
                ),
                _InfoRow(
                  label: '流量上限',
                  value: _formatBytes(sub.trafficLimitBytes),
                ),
                if (sub.grants.isNotEmpty)
                  _InfoRow(
                    label: '总剩余',
                    value: _formatBytes(sub.totalRemainingBytes),
                  ),
                const SizedBox(height: 12),
                // 流量进度条: 多套餐时 = 所有未过期套餐合计 (subscription.traffic_used/limit_bytes)
                _TrafficBar(used: sub.trafficUsedBytes, limit: sub.trafficLimitBytes),
                // 多套餐明细: 同时有 ≥2 个套餐桶时, 逐套餐列出各自用量/剩余/到期 (单套餐时上面进度条已足够)
                if (sub.grants.length >= 2) ...[
                  const SizedBox(height: 16),
                  _GrantsList(grants: sub.grants),
                ],
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(expired ? '重新购买' : '续费 / 升级套餐'),
                  onPressed: () => _goRenew(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// 订单列表
// ============================================================

class _OrdersList extends ConsumerWidget {
  const _OrdersList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListProvider);
    return ordersAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(Icons.error_outline,
                color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 8),
            Text('订单查询失败: $e',
                style: Theme.of(context).textTheme.bodySmall),
            TextButton(
              onPressed: () => ref.invalidate(ordersListProvider),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
      data: (orders) {
        if (orders.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                '暂无订单',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          );
        }
        return Column(
          children: orders.map((o) => _OrderTile(order: o)).toList(),
        );
      },
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderDto order;

  const _OrderTile({required this.order});

  String _planLabel(String id) {
    switch (id) {
      case 'monthly':
        return '月付 \$5';
      case 'quarterly':
        return '季付 \$13';
      case 'yearly':
        return '年付 \$45';
      default:
        return id;
    }
  }

  ({String label, Color color, IconData icon}) _statusBadge(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    switch (order.status) {
      case 'finished':
        return (label: '已支付', color: Colors.green.shade400, icon: Icons.check_circle);
      case 'waiting':
        final exp = order.expiresAt.isBefore(DateTime.now());
        if (exp) {
          return (label: '已超时', color: scheme.error, icon: Icons.access_time_filled);
        }
        return (label: '等待付款', color: scheme.primary, icon: Icons.hourglass_top);
      case 'expired':
        return (label: '已超时', color: scheme.error, icon: Icons.access_time_filled);
      case 'failed':
        return (label: '失败', color: scheme.error, icon: Icons.cancel);
      default:
        return (label: order.status, color: scheme.onSurfaceVariant, icon: Icons.info_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badge = _statusBadge(context);
    final canResume = order.status == 'waiting' &&
        order.expiresAt.isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: canResume
            ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VerstroUsdtInvoicePage(order: order),
                  ),
                )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(badge.icon, size: 18, color: badge.color),
                  const SizedBox(width: 6),
                  Text(
                    badge.label,
                    style: TextStyle(color: badge.color, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '#${order.id}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontFamily: 'monospace',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _planLabel(order.planId),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '\$${order.finalAmount} USDT',
                    style: const TextStyle(
                        fontFamily: 'monospace', fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.event,
                      size: 13, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    order.createdAt.toLocal().toString().split('.')[0],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  if (order.txid != null && order.txid!.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.link,
                        size: 13, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'tx: ${order.txid!.substring(0, order.txid!.length.clamp(0, 12))}...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontFamily: 'monospace',
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (canResume) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.touch_app, size: 13, color: scheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      '点击继续付款',
                      style: TextStyle(
                          color: scheme.primary, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 设备列表 (T4.2 / 见 docs/security/account-device-control.md)
// ============================================================

class _DevicesList extends ConsumerWidget {
  const _DevicesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(devicesListProvider);
    final currentId = ref.watch(currentDeviceIdProvider).value;
    final scheme = Theme.of(context).colorScheme;

    return devicesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      // 后端 devices 端点未部署 / 网络异常时 → 低调降级, 不打断账号页
      error: (e, _) => Card(
        child: ListTile(
          leading: Icon(Icons.devices_other, color: scheme.onSurfaceVariant),
          title: const Text('设备列表暂不可用'),
          subtitle:
              Text('稍后再试', style: Theme.of(context).textTheme.bodySmall),
          trailing: TextButton(
            onPressed: () => ref.invalidate(devicesListProvider),
            child: const Text('重试'),
          ),
        ),
      ),
      data: (devices) {
        if (devices.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '暂无登记设备',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
          );
        }
        return Column(
          children: devices
              .map((d) => _DeviceTile(
                    device: d,
                    isCurrent: currentId != null && d.deviceId == currentId,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _DeviceTile extends ConsumerWidget {
  final DeviceDto device;
  final bool isCurrent;

  const _DeviceTile({required this.device, required this.isCurrent});

  IconData _platformIcon(String p) {
    switch (p) {
      case 'ios':
        return Icons.phone_iphone;
      case 'android':
        return Icons.phone_android;
      case 'macos':
        return Icons.laptop_mac;
      case 'windows':
        return Icons.desktop_windows;
      case 'linux':
        return Icons.computer;
      default:
        return Icons.devices_other;
    }
  }

  String _relativeTime(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return '刚刚活跃';
    if (d.inMinutes < 60) return '${d.inMinutes} 分钟前活跃';
    if (d.inHours < 24) return '${d.inHours} 小时前活跃';
    return '${d.inDays} 天前活跃';
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final label = device.deviceName.isNotEmpty ? device.deviceName : device.platform;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('登出此设备?'),
        content: Text('"$label" 将被移除, 需重新登录才能继续使用 Verstro.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: const Text('登出')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await deleteDevice(ref, device.deviceId);
      ref.invalidate(devicesListProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('登出失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final name = device.deviceName.isNotEmpty ? device.deviceName : device.platform;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(_platformIcon(device.platform), color: scheme.primary),
        title: Row(
          children: [
            Flexible(
              child: Text(name.isNotEmpty ? name : '未知设备',
                  overflow: TextOverflow.ellipsis),
            ),
            if (isCurrent) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('本机',
                    style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        subtitle: Text(_relativeTime(device.lastSeenAt.toLocal()),
            style: Theme.of(context).textTheme.bodySmall),
        trailing: isCurrent
            ? null
            : IconButton(
                icon: const Icon(Icons.logout),
                tooltip: '登出此设备',
                onPressed: () => _confirmRemove(context, ref),
              ),
      ),
    );
  }
}

// ============================================================
// 子组件
// ============================================================

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                    fontWeight: valueColor != null ? FontWeight.w600 : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final String planLabel;

  const _PlanBadge({required this.planLabel});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        planLabel,
        style: TextStyle(
          color: scheme.onPrimary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// 流量进度条 — 实时显示已用 / 上限 (backend subscription.traffic_used_bytes).
///
/// used 来自订阅服务端当前计费周期统计; backend 查询失败时降级为 0.
/// 比例 ≥70% 橙色预警, ≥90% 红色 + 升级提示.
class _TrafficBar extends StatelessWidget {
  final int used;
  final int limit;

  const _TrafficBar({required this.used, required this.limit});

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0';
    final gb = bytes / (1024 * 1024 * 1024);
    if (gb >= 1024) return '${(gb / 1024).toStringAsFixed(2)} TB';
    if (gb >= 1) return '${gb.toStringAsFixed(1)} GB';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(0)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ratio = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;
    final nearLimit = ratio >= 0.9;
    final mid = ratio >= 0.7;
    final barColor = nearLimit
        ? scheme.error
        : mid
            ? Colors.orange.shade400
            : scheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.data_usage, size: 14, color: scheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              '流量使用',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const Spacer(),
            Text(
              '${_formatBytes(used)} / ${_formatBytes(limit)}',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
                color: nearLimit ? scheme.error : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: ratio,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
          backgroundColor: scheme.surfaceContainerHighest,
          color: barColor,
        ),
        if (nearLimit) ...[
          const SizedBox(height: 4),
          Text(
            '流量即将用尽, 建议升级套餐',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: scheme.error,
                ),
          ),
        ],
      ],
    );
  }
}

/// 多套餐流量明细 — 同时持有多个套餐桶时逐个列出 (修复"旧套餐流量被新套餐吞掉"后, 各套餐独立计量).
/// 消耗顺序 FEFO (最早过期先用), 由后端账本维护; 这里只做展示.
class _GrantsList extends StatelessWidget {
  final List<GrantDto> grants;

  const _GrantsList({required this.grants});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.list_alt, size: 14, color: scheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              '套餐明细',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ...grants.map((g) => _GrantTile(grant: g)),
      ],
    );
  }
}

/// 单个套餐桶展示行 — 套餐名 + 状态 + 各自进度条 + 已用/配额 + 到期日.
class _GrantTile extends StatelessWidget {
  final GrantDto grant;

  const _GrantTile({required this.grant});

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0';
    final gb = bytes / (1024 * 1024 * 1024);
    if (gb >= 1024) return '${(gb / 1024).toStringAsFixed(2)} TB';
    if (gb >= 1) return '${gb.toStringAsFixed(1)} GB';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(0)} MB';
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'active':
        return '活跃中';
      case 'exhausted':
        return '已用尽';
      case 'expired':
        return '已过期';
      default:
        return s;
    }
  }

  Color _statusColor(ColorScheme scheme, String s) {
    switch (s) {
      case 'active':
        return Colors.green.shade400;
      case 'exhausted':
        return Colors.orange.shade400;
      case 'expired':
        return scheme.error;
      default:
        return scheme.onSurfaceVariant;
    }
  }

  String _expiryLabel(DateTime? e) {
    if (e == null) return '';
    final d = e.toLocal();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dim = grant.status == 'expired';
    final ratio = grant.quotaBytes > 0
        ? (grant.consumedBytes / grant.quotaBytes).clamp(0.0, 1.0)
        : 0.0;
    final statusColor = _statusColor(scheme, grant.status);
    final expiry = _expiryLabel(grant.expiresAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                grant.planName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: dim ? scheme.onSurfaceVariant : null,
                    ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusLabel(grant.status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '剩余 ${_formatBytes(grant.remainingBytes)}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: ratio,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
            backgroundColor: scheme.surfaceContainerHighest,
            color: dim ? scheme.onSurfaceVariant : statusColor,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                '${_formatBytes(grant.consumedBytes)} / ${_formatBytes(grant.quotaBytes)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
              ),
              const Spacer(),
              if (expiry.isNotEmpty)
                Text(
                  '到期 $expiry',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
