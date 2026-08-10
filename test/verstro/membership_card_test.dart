import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/verstro/api/membership_card_models.dart';
import 'package:fl_clash/verstro/providers/membership_card_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('JSON 报价保留服务端 tier、9/10 分类和 cash-backed 拆分', () {
    final quote = MembershipCardQuote.fromJson(<String, dynamic>{
      'card_class': 'wholesale_inventory',
      'buyer_tier': 'retail',
      'cost_bps': 7000,
      'card_count': 10,
      'item_count': 1,
      'list_total_cents': 5000,
      'goods_total_cents': 3500,
      'cash_backed_credit_available_cents': 1000,
      'cash_backed_credit_applied_cents': 700,
      'cash_due_cents': 2800,
      'plan_release_version': 5,
      'membership_card_config_release_id': 6,
      'membership_card_config_version': 7,
      'commerce_config_version': 8,
      'quote_hash': List.filled(64, 'a').join(),
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'plan_version_id': 11,
          'plan_id': 'monthly',
          'plan_name': '标准月卡',
          'duration_days': 30,
          'traffic_limit_bytes': 1000000000,
          'max_devices': 3,
          'squad_tier': 'standard',
          'manual_node_selection': false,
          'quantity': 10,
          'list_unit_cents': 500,
          'sale_unit_cents': 350,
          'line_list_total_cents': 5000,
          'line_total_cents': 3500,
        },
      ],
    });

    expect(quote.buyerTier, 'retail');
    expect(quote.cardClass, MembershipCardClass.wholesaleInventory);
    expect(quote.cardCount, 10);
    expect(quote.costBps, 7000);
    expect(quote.goodsTotalCents, 3500);
    expect(quote.cashBackedCreditAppliedCents, 700);
    expect(quote.cashDueCents, 2800);
    expect(quote.pricingCopyKey, 'vCardPriceBulkRetail');
    expect(quote.purchaseWarningKeys, <String>['vCardWarningWholesaleSelf']);
  });

  test('错误码映射覆盖销售/批发关闭与兑换/reveal 错误', () {
    expect(
      membershipCardErrorKey('card_sales_disabled'),
      'vCardUnavailableSales',
    );
    expect(
      membershipCardErrorKey('card_bulk_purchase_disabled'),
      'vCardUnavailableBulk',
    );
    expect(
      membershipCardErrorKey(
        'membership_card_wholesale_self_redemption_forbidden',
      ),
      'vCardErrWholesaleSelf',
    );
    expect(
      membershipCardErrorKey('card_reveal_grant_expired'),
      'vCardErrRevealExpired',
    );
  });

  test('reveal secret 只存内存，进入后台或离开页面即清除', () {
    final vault = MembershipCardSecretVault();
    vault.set('card-1', 'VC1-SECRET');
    expect(vault.read('card-1'), 'VC1-SECRET');
    expect(vault.canShare('card-1'), isTrue);

    vault.handleLifecycle(AppLifecycleState.paused);
    expect(vault.read('card-1'), isNull);
    expect(vault.canShare('card-1'), isFalse);

    vault.set('card-2', 'VC1-SECRET-2');
    vault.clear();
    expect(jsonEncode(vault), isNot(contains('VC1-SECRET')));
  });

  test('兑换 confirm body 只包含 preview_token，不重传 code', () {
    final body = buildMembershipCardConfirmBody(<String, dynamic>{
      'preview_token': 'preview-1',
      'code': 'VC1-SECRET',
    });
    expect(body, <String, dynamic>{'preview_token': 'preview-1'});
    expect(jsonEncode(body), isNot(contains('VC1-SECRET')));
  });

  test('权益时间线保留 active/scheduled/paused/activation_pending 服务端状态', () {
    final timeline = MembershipEntitlementTimeline.fromJson(<String, dynamic>{
      'current': <Map<String, dynamic>>[_grant(1, 'active')],
      'pending': <Map<String, dynamic>>[
        _grant(2, 'scheduled'),
        _grant(3, 'paused'),
        _grant(4, 'activation_pending'),
      ],
    });
    expect(timeline.current.map((item) => item.status), <String>['active']);
    expect(timeline.pending.map((item) => item.status), <String>[
      'scheduled',
      'paused',
      'activation_pending',
    ]);
  });

  test('App 不引入 IAP，不用 SharedPreferences/日志保存完整码，share 只能显式触发', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final provider = File(
      'lib/verstro/providers/membership_card_provider.dart',
    ).readAsStringSync();
    final pages = Directory('lib/verstro/pages/membership_cards')
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => file.readAsStringSync())
        .join('\n');

    expect(pubspec, isNot(contains('in_app_purchase')));
    expect(provider, isNot(contains('SharedPreferences')));
    expect(provider, isNot(contains('print(')));
    expect(provider, isNot(contains('debugPrint(')));
    expect(pages, contains('vCardShareExplicit'));
    expect(pages, isNot(contains('shareTextAutomatically')));
  });
}

Map<String, dynamic> _grant(int id, String status) => <String, dynamic>{
  'grant_id': id,
  'source_kind': 'card',
  'source_card_id': '11111111-1111-4111-8111-111111111111',
  'plan_id': 'monthly',
  'plan_name': '标准月卡',
  'squad_tier': 'standard',
  'status': status,
  'starts_at': '2026-08-04T00:00:00Z',
  'active_until': '2026-09-03T00:00:00Z',
  'remaining_service_seconds': 2592000,
  'quota_bytes': 1000000000,
  'consumed_bytes': 0,
};
