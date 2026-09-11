// AccountPage — Verstro 用户账户主页 (阶段 2.3.4)
//
// 已登录 + 有效订阅 → 显示此页 (取代之前简化版 _ActiveSubscriptionScreen).
// 已登录无订阅 / 已过期 → 显示 PlanPickerPage.
//
// 页面结构 (可扫视概览, 低频管理内容渐进披露收二级页):
// 1. 用户信息: email + 邮箱验证状态
// 2. 订阅状态: 套餐 / 到期 / 流量限额 + 续费/升级按钮 + 订阅 URL (alpha)
// 3. 账户余额卡 + 推广中心入口卡
// 4. 订单历史入口卡 → 二级页 (列表最多 100 条, waiting 订单点击续付)
// 5. 我的设备入口卡 (副标题「已登记 X / N 台」) → 二级页 (设备行 + 登出)
//
// Pull-to-refresh 重新拉 subscription/orders/devices/credit/agent.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/views/settings.dart';

import '../api/api_models.dart';
import '../widgets/account_entitlements_card.dart';
import '../providers/account_entitlements_provider.dart';
import '../providers/account_refresh.dart';
import '../providers/auth_provider.dart';
import '../widgets/credit_balance_card.dart';
import '../widgets/email_verify_form.dart';
import '../widgets/agent_entry_card.dart';
import '../providers/agent_provider.dart';
import '../providers/credit_provider.dart';
import '../providers/devices_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/promotions_provider.dart';
import '../util/money.dart';
import '../util/plan_display.dart';
import 'membership_cards/membership_cards_page.dart';
import 'my_promotions_page.dart';
import 'plan_picker_page.dart';
import 'usdt_invoice_page.dart';

class VerstroAccountPage extends ConsumerWidget {
  const VerstroAccountPage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    invalidateAccount(ref.invalidate);
    ref.invalidate(ordersListProvider);
    ref.invalidate(devicesListProvider);
    ref.invalidate(creditProvider);
    ref.invalidate(agentProvider);
    ref.invalidate(myPromotionsProvider);
    await Future.wait<dynamic>(
      [
        ref.read(accountEntitlementsProvider.future),
        ref.read(subscriptionProvider.future),
        ref.read(ordersListProvider.future),
        ref.read(devicesListProvider.future),
        ref.read(creditProvider.future),
        ref.read(agentProvider.future),
        ref.read(myPromotionsProvider.future),
      ].map(
        (future) => future.then<dynamic>(
          (value) => value,
          onError: (Object _, StackTrace _) => null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider).value;
    final user = authState?.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.vAcctPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: appLocalizations.vAcctRefresh,
            onPressed: () => _refresh(ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: appLocalizations.settings,
            onPressed: () async {
              await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsView()));
              if (context.mounted) invalidateAccount(ref.invalidate);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            if (user != null) _UserCard(user: user),
            // 邮箱未验证: 内联 6 位验证码表单 (plan 1-2 阶段D, App 内验证)
            if (user != null && !user.isEmailVerified) ...[
              const SizedBox(height: 16),
              _EmailVerifyCard(email: user.email),
            ],
            const SizedBox(height: 16),
            const AccountEntitlementsCard(),
            const SizedBox(height: 16),
            const _SubscriptionCard(),
            const SizedBox(height: 16),
            const CreditBalanceCard(alwaysShow: true),
            const AgentEntryCard(),
            const _MembershipCardEntry(),
            const _MyPromotionsEntry(),
            // 订单历史/我的设备均收进二级页 (低频管理内容渐进披露, 账号页保持可扫视)
            const _OrderHistoryEntry(),
            const _DevicesEntry(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MyPromotionsEntry extends ConsumerWidget {
  const _MyPromotionsEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPromotionsProvider).value;
    if (state != null && !state.supported) return const SizedBox.shrink();
    final data = state?.data;
    final count =
        (data?.automatic
                .where((item) => item.availability == 'available')
                .length ??
            0) +
        (data?.grants.where((item) => item.redeemable).length ?? 0);
    final subtitle = count > 0
        ? '${appLocalizations.vPromotionAvailable}: $count'
        : appLocalizations.vPromotionMyEntrySubtitle;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.local_offer_outlined),
        title: Text(appLocalizations.vPromotionMyEntryTitle),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const VerstroMyPromotionsPage(),
            ),
          );
          if (context.mounted) invalidateAccount(ref.invalidate);
        },
      ),
    );
  }
}

class _MembershipCardEntry extends ConsumerWidget {
  const _MembershipCardEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.card_giftcard_outlined),
        title: Text(appLocalizations.vCardEntryTitle),
        subtitle: Text(appLocalizations.vCardEntrySubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const MembershipCardsPage(),
            ),
          );
          if (context.mounted) invalidateAccount(ref.invalidate);
        },
      ),
    );
  }
}

// ============================================================
// 订单历史入口行 + 二级页
// ============================================================

class _OrderHistoryEntry extends ConsumerWidget {
  const _OrderHistoryEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long),
        title: Text(appLocalizations.vAcctOrderHistory),
        subtitle: Text(appLocalizations.vAcctOrderHistorySubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VerstroOrderHistoryPage()),
          );
          if (context.mounted) invalidateAccount(ref.invalidate);
        },
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
      appBar: AppBar(title: Text(appLocalizations.vAcctOrderHistory)),
      body: RefreshIndicator(
        onRefresh: () => refreshAccount(ref),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [_OrdersList()],
        ),
      ),
    );
  }
}

// ============================================================
// 我的设备入口卡 + 二级页
// ============================================================

// 入口卡副标题动态显示「已登记 X / N 台」(唯一有扫视价值的状态信号);
// 加载中/接口失败降级为通用文案, 不阻塞账号页。
class _DevicesEntry extends ConsumerWidget {
  const _DevicesEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(devicesListProvider);
    final subtitle = devicesAsync.maybeWhen(
      data: (info) => info.maxDevices > 0
          ? appLocalizations.vAcctDevicesRegistered(
              info.devices.length,
              info.maxDevices,
            )
          : appLocalizations.vAcctDevicesRegisteredNoMax(info.devices.length),
      orElse: () => appLocalizations.vAcctDevicesEntrySubtitle,
    );
    return Card(
      child: ListTile(
        leading: const Icon(Icons.devices),
        title: Text(appLocalizations.vAcctMyDevices),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const VerstroDevicesPage()));
          if (context.mounted) invalidateAccount(ref.invalidate);
        },
      ),
    );
  }
}

// 我的设备二级页: 复用 _DevicesList (设备行 + 本机徽章 + 登出按钮)。
class VerstroDevicesPage extends ConsumerWidget {
  const VerstroDevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vAcctMyDevices)),
      body: RefreshIndicator(
        onRefresh: () => refreshAccount(ref),
        child: ListView(
          // 设备数少时内容不满屏, 保持可下拉刷新
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              appLocalizations.vAcctDevicesLimitHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            const _DevicesList(),
          ],
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
                        user.isEmailVerified
                            ? appLocalizations.vAcctEmailVerified
                            : appLocalizations.vAcctEmailUnverified,
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
// 邮箱验证码卡 (plan 1-2 阶段D, App 内验证)
// ============================================================

class _EmailVerifyCard extends StatelessWidget {
  final String email;
  const _EmailVerifyCard({required this.email});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.mark_email_unread_outlined,
                  color: scheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  appLocalizations.vAcctVerifyEmailTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              appLocalizations.vAcctVerifyCodeSentDesc(email),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            VerstroEmailVerifyForm(email: email),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 订阅状态卡
// ============================================================

// 当前权限与流量仅由 /entitlements 展示；旧 /subscription 仅用于导入链接。
class _SubscriptionCard extends ConsumerWidget {
  const _SubscriptionCard();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider).value;
    if (sub == null || sub.isExpired || sub.subscriptionUrl == null) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(appLocalizations.vAcctSubscriptionUrlLabel),
            SelectableText(sub.subscriptionUrl!, maxLines: 2),
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: Text(appLocalizations.vAcctCopySubscriptionUrl),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: sub.subscriptionUrl!));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(appLocalizations.vAcctSubscriptionUrlCopied),
                  ),
                );
              },
            ),
            Text(appLocalizations.vAcctSubscriptionUrlDesc),
          ],
        ),
      ),
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
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 8),
            Text(
              appLocalizations.vAcctOrdersQueryFailed(e),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextButton(
              onPressed: () => ref.invalidate(ordersListProvider),
              child: Text(appLocalizations.vAcctRetry),
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
                appLocalizations.vAcctNoOrders,
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

  // 套餐名走本地化；价格必须使用订单自己的 basePrice 快照，而不是当前价目表。
  // 这样调价前后的历史订单都能显示各自真实成交基价。
  String _planLabel(String id, String basePrice) {
    final name = localizedPlanName(id, id);
    return basePrice.isEmpty ? name : '$name \$$basePrice';
  }

  ({String label, Color color, IconData icon}) _statusBadge(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    switch (order.status) {
      case 'finished':
        return (
          label: appLocalizations.vAcctOrderPaid,
          color: Colors.green.shade400,
          icon: Icons.check_circle,
        );
      case 'waiting':
        final exp = order.expiresAt.isBefore(DateTime.now());
        if (exp) {
          return (
            label: appLocalizations.vAcctExpired,
            color: scheme.error,
            icon: Icons.access_time_filled,
          );
        }
        return (
          label: appLocalizations.vAcctOrderWaiting,
          color: scheme.primary,
          icon: Icons.hourglass_top,
        );
      case 'partially_paid':
        final exp = order.expiresAt.isBefore(DateTime.now());
        if (exp) {
          return (
            label: appLocalizations.vAcctExpired,
            color: scheme.error,
            icon: Icons.access_time_filled,
          );
        }
        return (
          label: appLocalizations.vClaimPartiallyPaid(
            '\$${centsToUsd(order.receivedCents)}',
            order.paymentCount,
            '\$${centsToUsd(order.remainingCents)}',
          ),
          color: scheme.primary,
          icon: Icons.pie_chart_outline,
        );
      case 'expired':
        return (
          label: appLocalizations.vAcctExpired,
          color: scheme.error,
          icon: Icons.access_time_filled,
        );
      case 'failed':
        return (
          label: appLocalizations.vAcctOrderFailed,
          color: scheme.error,
          icon: Icons.cancel,
        );
      default:
        return (
          label: order.status,
          color: scheme.onSurfaceVariant,
          icon: Icons.info_outline,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badge = _statusBadge(context);
    final canResume =
        (order.isWaiting || order.isPartiallyPaid) &&
        order.expiresAt.isAfter(DateTime.now());
    // 已过期 (含 waiting / partially_paid 已过期): 可点跳选套餐页重新下单
    final canReorder =
        !canResume &&
        (order.isExpired || order.isWaiting || order.isPartiallyPaid);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: order.isConversion || canResume
            ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VerstroUsdtInvoicePage(order: order),
                ),
              )
            : canReorder
            ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VerstroPlanPickerPage(),
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
                  Expanded(
                    child: Text(
                      badge.label,
                      style: TextStyle(
                        color: badge.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                      _planLabel(order.planId, order.basePrice),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '\$${order.finalAmount} USDT',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.event, size: 13, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    order.createdAt.toLocal().toString().split('.')[0],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  if (order.txid != null && order.txid!.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.link, size: 13, color: scheme.onSurfaceVariant),
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
                      appLocalizations.vAcctTapToContinuePayment,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (canReorder) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.refresh, size: 13, color: scheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      appLocalizations.vAcctTapToReorder,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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
          title: Text(appLocalizations.vAcctDevicesUnavailable),
          subtitle: Text(
            appLocalizations.vAcctTryLater,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: TextButton(
            onPressed: () => ref.invalidate(devicesListProvider),
            child: Text(appLocalizations.vAcctRetry),
          ),
        ),
      ),
      data: (info) {
        final devices = info.devices;
        if (devices.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                appLocalizations.vAcctNoDevices,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        return Column(
          children: [
            // 当前套餐设备上限 (plan 1-2 阶段C): 已登记 X / N 台
            if (info.maxDevices > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.devices,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appLocalizations.vAcctDevicesRegistered(
                        devices.length,
                        info.maxDevices,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ...devices.map(
              (d) => _DeviceTile(
                device: d,
                isCurrent: currentId != null && d.deviceId == currentId,
              ),
            ),
          ],
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
    if (d.inMinutes < 1) return appLocalizations.vAcctActiveJustNow;
    if (d.inMinutes < 60) {
      return appLocalizations.vAcctActiveMinutesAgo(d.inMinutes);
    }
    if (d.inHours < 24) return appLocalizations.vAcctActiveHoursAgo(d.inHours);
    return appLocalizations.vAcctActiveDaysAgo(d.inDays);
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final label = device.deviceName.isNotEmpty
        ? device.deviceName
        : device.platform;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appLocalizations.vAcctLogoutDeviceTitle),
        content: Text(appLocalizations.vAcctLogoutDeviceContent(label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(appLocalizations.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(appLocalizations.vAcctLogout),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await deleteDevice(ref, device.deviceId);
      ref.invalidate(devicesListProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLocalizations.vAcctLogoutFailed(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final name = device.deviceName.isNotEmpty
        ? device.deviceName
        : device.platform;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(_platformIcon(device.platform), color: scheme.primary),
        title: Row(
          children: [
            Flexible(
              child: Text(
                name.isNotEmpty ? name : appLocalizations.vAcctUnknownDevice,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isCurrent) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appLocalizations.vAcctThisDevice,
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          _relativeTime(device.lastSeenAt.toLocal()),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: isCurrent
            ? null
            : IconButton(
                icon: const Icon(Icons.logout),
                tooltip: appLocalizations.vAcctLogoutDevice,
                onPressed: () => _confirmRemove(context, ref),
              ),
      ),
    );
  }
}
