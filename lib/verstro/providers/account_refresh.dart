import 'package:flutter_riverpod/flutter_riverpod.dart';
// 统一账户变更失效入口。接受 invalidate 回调，适配 WidgetRef 和 Notifier Ref。
import 'package:riverpod/misc.dart';
import 'account_entitlements_provider.dart';
import 'orders_provider.dart';
import 'credit_provider.dart';
import 'devices_provider.dart';
import 'membership_card_provider.dart';

void invalidateAccount(
  void Function(ProviderOrFamily, {bool asReload}) invalidate,
) {
  invalidate(accountEntitlementsProvider);
  invalidate(subscriptionProvider);
  invalidate(ordersListProvider);
  invalidate(creditProvider);
  invalidate(devicesListProvider);
  invalidate(membershipEntitlementTimelineProvider);
  invalidate(membershipCardInventoryProvider);
  invalidate(membershipCardOrdersProvider);
}

/// 二级页下拉与账户页采用相同快照边界；单项错误保留在对应 provider 上供重试。
Future<void> refreshAccount(WidgetRef ref) async {
  invalidateAccount(ref.invalidate);
  await Future.wait<dynamic>(
    [
      ref.read(accountEntitlementsProvider.future),
      ref.read(subscriptionProvider.future),
      ref.read(ordersListProvider.future),
      ref.read(creditProvider.future),
      ref.read(devicesListProvider.future),
    ].map(
      (future) => future.then<dynamic>(
        (value) => value,
        onError: (Object _, StackTrace _) => null,
      ),
    ),
  );
}
