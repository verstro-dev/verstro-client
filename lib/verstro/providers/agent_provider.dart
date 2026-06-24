// 我的代理视图/推广中心 provider (C2 推荐 + Task 1 分销扩展).
// 跟 auth 联动: 未登录返空(code=''); 卡在 code 为空时不渲染.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_models.dart';
import 'auth_provider.dart';
import 'backend_api_provider.dart';

/// 当前用户的代理视图. 未登录返空 AgentDto(卡不显). 登出自动清.
final agentProvider = FutureProvider<AgentDto>((ref) async {
  final auth = ref.watch(authNotifierProvider).value;
  if (auth == null || !auth.isLoggedIn) {
    return const AgentDto(
        code: '', directCount: 0, refereeRewardCents: 0, referrerRewardCents: 0,
        tier: 'promoter', pendingCents: 0, availableCents: 0, paidCents: 0,
        overrideAvailableCents: 0, subAgentCount: 0, canRecruit: false);
  }
  final api = await ref.read(backendApiProvider.future);
  return api.getAgent();
});

/// 当前代理的套餐价格范围+售价. 未登录返空列表. 登出自动清.
final agentPricesProvider = FutureProvider<AgentPricesDto>((ref) async {
  final auth = ref.watch(authNotifierProvider).value;
  if (auth == null || !auth.isLoggedIn) {
    return const AgentPricesDto(tier: 'promoter', prices: []);
  }
  final api = await ref.read(backendApiProvider.future);
  return api.getAgentPrices();
});
