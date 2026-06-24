// 用户 credit 钱包余额 Riverpod provider (C1, surface M1 credit).
// 跟 auth 联动: 未登录返空余额; 登出自动清. 卡仅在 balance>0 时渲染.
// 下单成功后调用方负责 ref.invalidate(creditProvider) 使余额反映 credit 占用.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_models.dart';
import 'auth_provider.dart';
import 'backend_api_provider.dart';

/// 当前用户 credit 余额. 未登录返 0 余额(卡不显). 登出自动清.
final creditProvider = FutureProvider<CreditDto>((ref) async {
  final auth = ref.watch(authNotifierProvider).value;
  if (auth == null || !auth.isLoggedIn) {
    return const CreditDto(balanceCents: 0, credits: <CreditItemDto>[]);
  }
  final api = await ref.read(backendApiProvider.future);
  return api.getCredit();
});
