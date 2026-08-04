// 试用资格 provider (C4, surface M4 试用). 跟 auth 联动; 未登录返 enabled:false(卡不显).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_models.dart';
import 'auth_provider.dart';
import 'backend_api_provider.dart';

/// 当前用户试用资格(后端独有的 enabled/claimed + 参数). 未登录返 enabled:false.
final trialStatusProvider = FutureProvider<TrialStatusDto>((ref) async {
  final auth = ref.watch(authNotifierProvider).value;
  if (auth == null || !auth.isLoggedIn) {
    return const TrialStatusDto(enabled: false, claimed: false, days: 0, trafficGb: 0);
  }
  final api = await ref.read(backendApiProvider.future);
  return api.getTrialStatus();
});
