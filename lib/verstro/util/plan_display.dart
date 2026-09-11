// plan_display.dart — 套餐名 id → 本地化展示
//
// 后端下发 plan.id (monthly/quarterly/yearly/premium-*/trial) + 中文 plan.name。
// 客户端按 id 查表映射到当前 locale 的本地化名; 未知 id (旧后端下线套餐 /
// 未来新增套餐) 回退后端下发的 name, 保证不会展示空白或崩溃。

import 'package:fl_clash/common/app_localizations.dart';

/// 后端套餐 id → 本地化显示名。未知 id 回退后端下发的 name（兼容旧后端/未来新套餐）。
String localizedPlanName(String id, String fallback) {
  final l = appLocalizations;
  switch (id) {
    case 'monthly':            return l.vAcctPlanStandardMonthly;
    case 'quarterly':          return l.vAcctPlanStandardQuarterly;
    case 'yearly':             return l.vAcctPlanStandardYearly;
    case 'premium-monthly':    return l.vAcctPlanPremiumMonthly;
    case 'premium-quarterly':  return l.vAcctPlanPremiumQuarterly;
    case 'premium-yearly':     return l.vAcctPlanPremiumYearly;
    case 'trial':              return l.vPlanNameTrial;
    default:                   return fallback;
  }
}
