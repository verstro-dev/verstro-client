// claim_display_test.dart — claim-tx 结构化结果展示测试

import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/util/claim_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ClaimTxResult claim({
  bool matched = false,
  String? resolution,
  int credited = 0,
  int shortfall = 0,
  int received = 0,
  int remaining = 0,
  int paymentCount = 0,
  int retryAfterSeconds = 0,
  String? actualRecipientMasked,
  String? orderStatus,
  String message = '后端中文不该出现：哈希或地址错误，完整地址=TFullSecretAddress',
}) => ClaimTxResult.fromJson({
  'matched': matched,
  'message': message,
  'resolution': ?resolution,
  if (credited != 0) 'credited_cents': credited,
  if (shortfall != 0) 'shortfall_cents': shortfall,
  if (received != 0) 'received_cents': received,
  if (remaining != 0) 'remaining_cents': remaining,
  if (paymentCount != 0) 'payment_count': paymentCount,
  if (retryAfterSeconds != 0) 'retry_after_seconds': retryAfterSeconds,
  'actual_recipient_masked': ?actualRecipientMasked,
  'order_status': ?orderStatus,
});

void main() {
  setUpAll(() async {
    await AppLocalizations.load(const Locale('zh', 'CN'));
  });

  test('matched → success，不消费后端 message', () {
    final d = localizedClaim(claim(matched: true, resolution: 'matched'));
    expect(d.kind.name, 'success');
    expect(d.text, '已确认，订阅已开通。');
    expect(d.text, isNot(contains('后端中文不该出现')));
  });

  test('matched 兼容枚举在多笔付款时也显示拆分完成', () {
    final d = localizedClaim(
      claim(matched: true, resolution: 'matched', paymentCount: 2),
    );

    expect(d.kind.name, 'success');
    expect(d.text, contains('2'));
    expect(d.text, contains('笔付款'));
    expect(d.text, contains('订阅已开通'));
  });

  test('overpaid_matched 带 credited 显示超额余额', () {
    final d = localizedClaim(
      claim(matched: true, resolution: 'overpaid_matched', credited: 200),
    );
    expect(d.kind.name, 'success');
    expect(d.text, contains(r'$2.00'));
  });

  test('pending_confirmation 只提示等待并保留后端重试秒数', () {
    final d = localizedClaim(
      claim(resolution: 'pending_confirmation', retryAfterSeconds: 30),
    );
    final details = d;

    expect(d.kind.name, 'pending');
    expect(d.text, contains('等待'));
    expect(d.text, isNot(contains('哈希或地址错误')));
    expect(d.text, isNot(contains('TFullSecretAddress')));
    expect(details.retryAfterSeconds, 30);
  });

  test('wrong_recipient 只显示 actual_recipient_masked', () {
    final d = localizedClaim(
      claim(resolution: 'wrong_recipient', actualRecipientMasked: 'TA12…Z9xy'),
    );

    expect(d.kind.name, 'wrongRecipient');
    expect(d.text, contains('TA12…Z9xy'));
    expect(d.text, isNot(contains('TFullSecretAddress')));
    expect(d.text, isNot(contains('后端中文不该出现')));
  });

  test('partially_paid 显示累计、剩余和笔数并允许继续提交', () {
    final d = localizedClaim(
      claim(
        resolution: 'partially_paid',
        received: 400,
        remaining: 207,
        paymentCount: 1,
        orderStatus: 'partially_paid',
      ),
    );
    final details = d;

    expect(d.kind.name, 'partial');
    expect(d.text, contains(r'$4.00'));
    expect(d.text, contains(r'$2.07'));
    expect(d.text, contains('1'));
    expect(details.continueSubmission, isTrue);
    expect(details.refreshOrder, isTrue);
  });

  test('split_payment_completed 显示成功和超额 Credit', () {
    final d = localizedClaim(
      claim(
        matched: true,
        resolution: 'split_payment_completed',
        received: 607,
        paymentCount: 2,
        credited: 50,
        orderStatus: 'finished',
      ),
    );
    final details = d;

    expect(d.kind.name, 'success');
    expect(d.text, contains('2'));
    expect(d.text, contains('订阅已开通'));
    expect(d.text, contains(r'$0.50'));
    expect(details.refreshOrder, isTrue);
  });

  test('provider_unavailable 按 retry_after_seconds 建立重试门', () {
    final d = localizedClaim(
      claim(resolution: 'provider_unavailable', retryAfterSeconds: 20),
    );
    final details = d;
    expect(d.kind.name, 'error');
    expect(d.text, contains('查询服务'));
    expect(details.retryAfterSeconds, 20);
  });

  test('unsupported_transfer 和 not_found 不折叠为泛化地址错误', () {
    final unsupported = localizedClaim(
      claim(resolution: 'unsupported_transfer'),
    );
    final notFound = localizedClaim(claim(resolution: 'not_found'));
    expect(unsupported.text, contains('USDT TRC20'));
    expect(notFound.text, contains('尚未找到'));
    expect(unsupported.text, isNot(contains('后端中文不该出现')));
    expect(notFound.text, isNot(contains('后端中文不该出现')));
  });

  test('credited_underpay 带 shortfall 显示入账与差额', () {
    final d = localizedClaim(
      claim(resolution: 'credited_underpay', credited: 434, shortfall: 100),
    );
    expect(d.kind.name, 'credited');
    expect(d.text, contains(r'$4.34'));
    expect(d.text, contains(r'$1.00'));
  });

  test('credited_underpay 无 shortfall 的 Replay 折叠为无差额文案', () {
    final d = localizedClaim(
      claim(resolution: 'credited_underpay', credited: 434),
    );
    expect(d.kind.name, 'credited');
    expect(d.text, r'$4.34 已存入账户余额。请重新下单——余额自动抵扣。');
  });

  test('resolution 空且非 matched 仍兼容旧响应 generic error', () {
    final d = localizedClaim(claim());
    expect(d.kind.name, 'error');
    expect(d.text, contains('无法验证'));
  });

  test('resolution 空且 matched=true 仍兼容旧响应 success', () {
    final d = localizedClaim(claim(matched: true));
    expect(d.kind.name, 'success');
    expect(d.text, '已确认，订阅已开通。');
  });

  test('credited_expired 且订单仍 expired 显示入余额与重新下单', () {
    final d = localizedClaim(
      claim(
        resolution: 'credited_expired',
        credited: 500,
        orderStatus: 'expired',
      ),
    );
    expect(d.kind.name, 'credited');
    expect(d.text, contains(r'$5.00'));
    expect(d.text, contains('重新下单'));
  });

  test('credited_expired 且订单已 finished 映射为成功与额外 Credit', () {
    final d = localizedClaim(
      claim(
        resolution: 'credited_expired',
        credited: 500,
        orderStatus: 'finished',
      ),
    );

    expect(d.kind.name, 'success');
    expect(d.refreshOrder, isTrue);
    expect(d.text, contains('订阅已开通'));
    expect(d.text, contains(r'$5.00'));
    expect(d.text, isNot(contains('过期')));
    expect(d.text, isNot(contains('重新下单')));
  });

  test('rejected_manual 引导到私下邮箱而不是公开群 Bot', () {
    final d = localizedClaim(claim(resolution: 'rejected_manual'));
    expect(d.kind.name, 'error');
    expect(d.text, contains('feedback@verstro.com'));
    expect(d.text, isNot(contains('VerstroSupportBot')));
  });

  test('overpaid_matched 但 creditedCents==0 折叠为普通 success', () {
    final d = localizedClaim(
      claim(matched: true, resolution: 'overpaid_matched'),
    );
    expect(d.kind.name, 'success');
    expect(d.text, '已确认，订阅已开通。');
    expect(d.text, isNot(contains(r'$')));
  });
}
