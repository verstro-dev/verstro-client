// money.dart — USDT 金额展示层对账工具
//
// 将后端 USD 金额串（FormatCentsAsUSD，总是两位小数，如 "5.00"）
// 解析为 cents 整数，用整数避免浮点误差。
// 仅用于 invoice 防冲突尾数行的展示计算。

/// 把后端 USD 金额串（FormatCentsAsUSD，总是两位小数，如 "5.00"）解析为 cents 整数。
/// 仅用于展示层小额对账（invoice 防冲突尾数行），用整数避免浮点误差。
int usdToCents(String usd) {
  final parts = usd.trim().split('.');
  final dollars = int.tryParse(parts[0]) ?? 0;
  var frac = 0;
  if (parts.length > 1) {
    frac = int.tryParse('${parts[1]}00'.substring(0, 2)) ?? 0;
  }
  return dollars * 100 + frac;
}

/// cents 整数 → "X.YY" 串。
String centsToUsd(int cents) {
  final frac = (cents % 100).toString().padLeft(2, '0');
  return '${cents ~/ 100}.$frac';
}

/// 计算本单"防冲突尾数"(cents) = final 与折后小计(原价−券−credit)之差。
///
/// 后端 floor 钳制的是被上报的 coupon_discount(见 control-plane coupon.go),
/// CalcFinalAmountCents 无独立 floor, 故"原价−券−credit ≡ usdtBase"对任意 floor
/// 精确成立, 尾数 = final − usdtBase ∈ [0,99]¢。
/// 入参均为后端两位小数金额串("5.00"); 无券/无 credit 传 null。
int couponSuffixCents(
  String amount,
  String basePrice,
  String? couponDiscount,
  String? creditApplied,
) {
  final subtotalCents = usdToCents(basePrice) -
      usdToCents(couponDiscount ?? '0') -
      usdToCents(creditApplied ?? '0');
  return usdToCents(amount) - subtotalCents;
}
