// 设备管理 Riverpod provider (T4.2 account 页"我的设备")
//
// - devicesListProvider: 当前用户已登记设备 (跟 auth 联动, 登出清空)
// - currentDeviceIdProvider: 本机 device_id (用于列表里标"本机")
// - deleteDevice: 一次性事件, 登出某设备

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_models.dart';
import '../api/device_identity.dart';
import 'auth_provider.dart';
import 'backend_api_provider.dart';

/// 当前用户已登记设备列表. 未登录返回空, 登出自动清.
final devicesListProvider = FutureProvider<List<DeviceDto>>((ref) async {
  final auth = ref.watch(authNotifierProvider).value;
  if (auth == null || !auth.isLoggedIn) return <DeviceDto>[];
  final api = await ref.read(backendApiProvider.future);
  return api.listDevices();
});

/// 本机 device_id, 用于在列表里标记"本机"(不可移除).
final currentDeviceIdProvider = FutureProvider<String>((ref) async {
  final prefs = await ref.read(sharedPreferencesProvider.future);
  return DeviceIdentity(prefs).getOrCreateDeviceId();
});

/// 一次性事件: 登出指定设备 (account 页"移除"按钮). 调用方负责 invalidate(devicesListProvider).
Future<void> deleteDevice(WidgetRef ref, String deviceId) async {
  final api = await ref.read(backendApiProvider.future);
  await api.deleteDevice(deviceId);
}
