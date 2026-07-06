// 套餐 / 订单 / 订阅 相关 Riverpod provider
//
// - plansProvider: 拉 backend 套餐列表 (一次性, keepAlive)
// - subscriptionProvider: 当前用户订阅 (auto refresh on user 变化)
// - orderDetailStreamProvider: 订单状态 5s 轮询 (UsdtInvoicePage 用)
//
// 阶段 2.3.2-2.3.3 用. 后续 2.3.4 AccountPage 会加 ordersListProvider.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_models.dart';
import 'auth_provider.dart';
import 'backend_api_provider.dart';

/// 3 档套餐 (backend 硬编码, 客户端拉一次缓存)
final plansProvider = FutureProvider<List<PlanDto>>((ref) async {
  final api = await ref.read(backendApiProvider.future);
  return api.listPlans();
});

/// 当前用户订阅. 依赖 authNotifierProvider, 用户切换会自动重拉.
final subscriptionProvider = FutureProvider<SubscriptionDto>((ref) async {
  // 让 subscription 跟 auth state 联动: 登出 / 登录后自动 refresh
  final authAsync = ref.watch(authNotifierProvider);
  final auth = authAsync.value;
  if (auth == null || !auth.isLoggedIn) {
    return const SubscriptionDto(
      hasSubscription: false,
      subscriptionUrl: null,
      currentPlanId: null,
      periodStartedAt: null,
      periodExpiresAt: null,
      trafficLimitBytes: 0,
      trafficUsedBytes: 0,
      isExpired: false,
    );
  }
  final api = await ref.read(backendApiProvider.future);
  return api.getSubscription();
});

/// 用户全部订单 (最近 N 条), AccountPage 用. 跟 auth 联动, 登出清.
final ordersListProvider = FutureProvider<List<OrderDto>>((ref) async {
  final authAsync = ref.watch(authNotifierProvider);
  final auth = authAsync.value;
  if (auth == null || !auth.isLoggedIn) return <OrderDto>[];
  final api = await ref.read(backendApiProvider.future);
  return api.listOrders();
});

/// 订单 5s 轮询 stream (UsdtInvoicePage watch).
///
/// autoDispose: 用户离开 UsdtInvoicePage 自动停止轮询, 防泄漏.
/// family: 多个订单 page 同时存在时各自轮询自己的 id.
///
/// 轮询逻辑:
/// - 每 5s 查 GET /v1/orders/{id}
/// - status='finished' / 'expired' / 'failed' → emit + 停止轮询
/// - 网络错误不停, 下个 5s 再试
final orderDetailStreamProvider =
    StreamProvider.autoDispose.family<OrderDto, int>((ref, orderId) async* {
  final api = await ref.read(backendApiProvider.future);
  const interval = Duration(seconds: 5);
  while (true) {
    try {
      final order = await api.getOrder(orderId);
      yield order;
      if (order.isFinished || order.isExpired || order.status == 'failed') {
        return; // 终态, 停止轮询
      }
    } catch (e) {
      // 网络错 / timeout 等: 不停轮询, 下个 interval 再试
      // (避免 transient error 让 UI 永远卡)
    }
    await Future.delayed(interval);
  }
});

/// 一次性事件 helper: 创建订单. UI 直接调, 不存 state.
/// couponCode 非空时透传到 backend, backend 计算折扣后回填 OrderDto.couponDiscount/creditApplied.
Future<OrderDto> createOrder(WidgetRef ref, String planId, {String? couponCode}) async {
  final api = await ref.read(backendApiProvider.future);
  return api.createOrder(planId, couponCode: couponCode);
}

/// 一次性事件: 用户主动 claim tx hash. 立即触发 backend 验证.
Future<ClaimTxResult> claimTx(WidgetRef ref, int orderId, String txHash) async {
  final api = await ref.read(backendApiProvider.future);
  return api.claimTx(orderId, txHash);
}
