// claim_display_test.dart — localizedClaim 单元测试
//
// 覆盖 resolution 枚举 → ClaimDisplay(kind, text) 的映射，包括:
// - credited_underpay 的 shortfall 分支 (Replay 折叠为无差额文案)
// - resolution 缺失时按 matched 布尔回退
// 断言不含后端 message ("后端中文不该出现")，验证 helper 确实丢弃后端 message。

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/util/claim_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ClaimTxResult r({bool matched = false, String? resolution, int credited = 0, int shortfall = 0, String? orderStatus}) =>
    ClaimTxResult(matched: matched, message: '后端中文不该出现', resolution: resolution,
        creditedCents: credited, shortfallCents: shortfall, orderStatus: orderStatus);

void main() {
  setUpAll(() async {
    await AppLocalizations.load(const Locale('zh', 'CN'));
  });

  test('matched → success, 本地化文案不含后端 message', () {
    final d = localizedClaim(r(matched: true, resolution: 'matched'));
    expect(d.kind, ClaimKind.success);
    expect(d.text, '已确认，订阅已开通。');
  });

  test('overpaid_matched 带 credited → 含金额', () {
    final d = localizedClaim(r(matched: true, resolution: 'overpaid_matched', credited: 200));
    expect(d.kind, ClaimKind.success);
    expect(d.text, contains('\$2.00'));
  });

  test('credited_underpay 带 shortfall → credited + 差额子句', () {
    final d = localizedClaim(r(resolution: 'credited_underpay', credited: 434, shortfall: 100));
    expect(d.kind, ClaimKind.credited);
    expect(d.text, contains('\$4.34'));
    expect(d.text, contains('\$1.00'));
  });

  test('credited_underpay 无 shortfall(Replay) → 折叠为无差额文案', () {
    final d = localizedClaim(r(resolution: 'credited_underpay', credited: 434, shortfall: 0));
    expect(d.kind, ClaimKind.credited);
    expect(d.text, '\$4.34 已存入账户余额。请重新下单——余额自动抵扣。');
  });

  test('resolution 空 + 非 matched → verify_failed generic(error)', () {
    final d = localizedClaim(r(matched: false, resolution: null));
    expect(d.kind, ClaimKind.error);
    expect(d.text, contains('无法验证'));
  });

  test('rejected_manual → error', () {
    final d = localizedClaim(r(resolution: 'rejected_manual'));
    expect(d.kind, ClaimKind.error);
    expect(d.text, contains('@VerstroSupportBot'));
  });

  test('resolution 空(老后端) + matched=true → success 兜底，同 matched 文案', () {
    final d = localizedClaim(r(matched: true, resolution: null));
    expect(d.kind, ClaimKind.success);
    expect(d.text, '已确认，订阅已开通。');
  });

  test('credited_expired → credited + 含金额', () {
    final d = localizedClaim(r(resolution: 'credited_expired', credited: 500));
    expect(d.kind, ClaimKind.credited);
    expect(d.text, contains('\$5.00'));
  });

  test('matched_other_order → error，含客服联系方式', () {
    final d = localizedClaim(r(resolution: 'matched_other_order'));
    expect(d.kind, ClaimKind.error);
    expect(d.text, contains('@VerstroSupportBot'));
  });

  test('already_processed → error，含客服联系方式', () {
    final d = localizedClaim(r(resolution: 'already_processed'));
    expect(d.kind, ClaimKind.error);
    expect(d.text, contains('@VerstroSupportBot'));
  });

  test('overpaid_matched 但 creditedCents==0 → 折叠为普通 success 文案(不含金额)', () {
    final d = localizedClaim(r(matched: true, resolution: 'overpaid_matched', credited: 0));
    expect(d.kind, ClaimKind.success);
    expect(d.text, '已确认，订阅已开通。');
    expect(d.text, isNot(contains('\$')));
  });
}
