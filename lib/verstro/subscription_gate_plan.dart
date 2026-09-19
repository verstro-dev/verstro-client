enum SubscriptionGateView { loading, error, planPicker, application }

/// 已登录后的订阅门禁该渲染哪一层。已有有效快照时，刷新失败或重载不得卸载应用。
SubscriptionGateView planSubscriptionGate({
  required bool hasData,
  required bool hasError,
  required bool isLoading,
  required bool hasSubscription,
  required bool isExpired,
}) {
  if (hasData && hasSubscription && !isExpired) {
    return SubscriptionGateView.application;
  }
  if (hasData) {
    return SubscriptionGateView.planPicker;
  }
  if (hasError) {
    return SubscriptionGateView.error;
  }
  return SubscriptionGateView.loading;
}
