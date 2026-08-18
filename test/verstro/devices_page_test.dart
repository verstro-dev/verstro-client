// 我的设备二级页 widget 测试 (账号页渐进披露批次):
// 设备列表从账号页内联区块收进二级页, 复用 _DevicesList。
// 覆盖: 说明文案 + 「已登记 X / N 台」 + 设备行/本机徽章 + 空列表态。

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/pages/account_page.dart';
import 'package:fl_clash/verstro/providers/devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

DeviceDto device(String id, {String name = '', String platform = 'android'}) =>
    DeviceDto(
      deviceId: id,
      deviceName: name,
      platform: platform,
      lastSeenAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

Future<void> pumpPage(WidgetTester tester, DevicesInfo info,
    {String currentId = 'dev-1'}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        devicesListProvider.overrideWith((ref) async => info),
        currentDeviceIdProvider.overrideWith((ref) async => currentId),
      ],
      child: const MaterialApp(home: VerstroDevicesPage()),
    ),
  );
  // FutureProvider 下一微任务出数据
  await tester.pump();
  await tester.pump();
}

void main() {
  setUpAll(() async {
    // i18n 批次后组件文案走 appLocalizations, 测试断言中文需先加载 zh_CN
    await AppLocalizations.load(const Locale('zh', 'CN'));
  });

  testWidgets('设备列表: 说明文案 + 已登记 X/N + 本机徽章', (tester) async {
    await pumpPage(
      tester,
      DevicesInfo(
        devices: [device('dev-1', name: '我的手机'), device('dev-2', name: '书房 Mac', platform: 'macos')],
        maxDevices: 3,
      ),
    );
    expect(find.text('超出设备上限时, 登录新设备会自动登出最早活跃的那台'), findsOneWidget);
    expect(find.text('已登记 2 / 3 台'), findsOneWidget);
    expect(find.text('我的手机'), findsOneWidget);
    expect(find.text('书房 Mac'), findsOneWidget);
    expect(find.text('本机'), findsOneWidget); // dev-1 = currentId
  });

  testWidgets('空列表: 显示暂无登记设备', (tester) async {
    await pumpPage(tester, const DevicesInfo(devices: [], maxDevices: 0));
    expect(find.text('暂无登记设备'), findsOneWidget);
  });
}
