import 'package:fl_clash/verstro/subscription_gate_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('planSubscriptionGate', () {
    test('已有有效订阅快照后刷新失败仍显示应用，不卸门禁', () {
      final view = planSubscriptionGate(
        hasData: true,
        hasError: true,
        isLoading: false,
        hasSubscription: true,
        isExpired: false,
      );
      expect(view, SubscriptionGateView.application);
    });

    test('已有有效订阅快照后重载仍显示应用，不回闪启动页', () {
      final view = planSubscriptionGate(
        hasData: true,
        hasError: false,
        isLoading: true,
        hasSubscription: true,
        isExpired: false,
      );
      expect(view, SubscriptionGateView.application);
    });

    test('尚无快照且查询失败才显示错误页', () {
      final view = planSubscriptionGate(
        hasData: false,
        hasError: true,
        isLoading: false,
        hasSubscription: false,
        isExpired: false,
      );
      expect(view, SubscriptionGateView.error);
    });

    test('尚无快照且加载中显示启动页', () {
      final view = planSubscriptionGate(
        hasData: false,
        hasError: false,
        isLoading: true,
        hasSubscription: false,
        isExpired: false,
      );
      expect(view, SubscriptionGateView.loading);
    });

    test('已有过期订阅快照仍进选套餐', () {
      final view = planSubscriptionGate(
        hasData: true,
        hasError: false,
        isLoading: false,
        hasSubscription: true,
        isExpired: true,
      );
      expect(view, SubscriptionGateView.planPicker);
    });
  });
}
