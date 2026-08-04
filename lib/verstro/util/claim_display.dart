// claim_display.dart — claim-tx resolution → 本地化展示
//
// 后端 POST /v1/orders/{id}/claim-tx 返回 resolution 枚举 + 结构化 cents 字段 +
// 中文 message（见 api_models.dart ClaimTxResult）。本 helper 按 resolution 本地化
// 展示文案，不再消费后端 message（旧行为：直接展示 message，见该类过时注释）。
//
// Replay 折叠: 后端在 credited_* 分支区分「此前已处理(Replay)」与「首次」两种措辞，
// 但客户端拿不到 Replay 标志，故每个 resolution 只用一套模板；credited_underpay
// 按 shortfallCents 是否 >0 分支（Replay 场景 shortfall 已清零，回退到无差额文案）。

import 'package:fl_clash/common/app_localizations.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/util/money.dart';

enum ClaimKind { success, credited, error }

class ClaimDisplay {
  final ClaimKind kind;
  final String text;
  const ClaimDisplay(this.kind, this.text);
}

String _usd(int cents) => '\$${centsToUsd(cents)}';

/// claim 结果 resolution + 结构化字段 → 本地化文案。
/// 不使用后端 message；Replay 变体折叠为同一模板（客户端无 Replay 标志）。
ClaimDisplay localizedClaim(ClaimTxResult r) {
  final l = appLocalizations;
  switch (r.resolution) {
    case 'matched':
      return ClaimDisplay(ClaimKind.success, l.vClaimActivated);
    case 'overpaid_matched':
      return ClaimDisplay(ClaimKind.success,
          r.creditedCents > 0 ? l.vClaimActivatedOverpay(_usd(r.creditedCents)) : l.vClaimActivated);
    case 'credited_underpay':
      return ClaimDisplay(ClaimKind.credited,
          r.shortfallCents > 0
              ? l.vClaimCreditedUnderpay(_usd(r.creditedCents), _usd(r.shortfallCents))
              : l.vClaimCreditedNoShortfall(_usd(r.creditedCents)));
    case 'credited_expired':
      return ClaimDisplay(ClaimKind.credited, l.vClaimCreditedExpired(_usd(r.creditedCents)));
    case 'matched_other_order':
      return ClaimDisplay(ClaimKind.error, l.vClaimMatchedOtherOrder);
    case 'already_processed':
      return ClaimDisplay(ClaimKind.error, l.vClaimAlreadyProcessed);
    case 'rejected_manual':
      return ClaimDisplay(ClaimKind.error, l.vClaimRejectedManual);
    default:
      // 老后端 matched=true 无 resolution → 成功; 其余(含 verify-fail 无码) → generic error
      if (r.resolution == null && r.matched) {
        return ClaimDisplay(ClaimKind.success, l.vClaimActivated);
      }
      return ClaimDisplay(ClaimKind.error, l.vClaimVerifyFailed);
  }
}
