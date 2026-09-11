import 'package:fl_clash/verstro/api/api_exceptions.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/account_entitlement_models.dart';
import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';
import 'package:fl_clash/verstro/pages/entitlement_conversion_page.dart';
import 'package:fl_clash/verstro/pages/account_page.dart';
import 'package:fl_clash/verstro/providers/account_entitlements_provider.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:fl_clash/verstro/widgets/account_entitlements_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'support/test_auth.dart';

Map<String, dynamic> grant(int id, String status) => {
  'grant_id': id,
  'source_kind': 'order',
  'source_order_id': id + 100,
  'plan_id': 'monthly',
  'plan_name': '标准·月付',
  'squad_tier': 'standard',
  'status': status,
  'starts_at': '2026-09-09T00:00:00Z',
  'active_until': '2026-10-09T00:00:00Z',
  'remaining_service_seconds': 2592000,
  'quota_bytes': 1024,
  'consumed_bytes': 0,
  'remaining_bytes': 1024,
  'is_estimated': status != 'active',
};
Map<String, dynamic> snapshot({
  String revision = 'one',
  List<Map<String, dynamic>>? history,
  String? cursor = 'opaque',
}) => {
  'as_of': '2026-09-09T00:00:00Z',
  'revision': revision,
  'history_revision': 'history-fixture',
  'current_service': {
    'status': 'active',
    'plan_id': 'premium-monthly',
    'squad_tier': 'premium',
    'remaining_bytes': 77,
    'max_devices': 8,
    'manual_node_selection': true,
  },
  'current': [grant(1, 'active')],
  'pending': [grant(2, 'scheduled'), grant(3, 'paused')],
  'history': history ?? [grant(4, 'expired')],
  'next_history_cursor': cursor,
  'conversion_capability': {
    'quote_supported': true,
    'execute_supported': false,
    'reason': 'cutoff_unsupported',
  },
};
Map<String, dynamic> quote({bool target = true}) => {
  'as_of': '2026-09-09T00:00:00Z',
  'expires_at': '2026-09-09T00:05:00Z',
  'revision': 'r',
  'quote_token': 'synthetic',
  'sources': [
    {
      'entitlement_id': 1,
      'source_kind': 'card',
      'source_id': 'synthetic',
      'plan_id': 'monthly',
      'status': 'active',
      'eligible': false,
      'exclusion_reason': 'unknown_funding',
      'purchase_value_cents': 0,
      'remaining_seconds': 30,
      'remaining_bytes': 100,
      'total_seconds': 60,
      'total_bytes': 200,
      'residual_value': '0',
      'residual_value_usdt_display': '0.0000',
    },
  ],
  'conversion_value_cents': 0,
  'target': target
      ? {
          'plan_id': 'premium-monthly',
          'plan_version_id': 3,
          'quantity': 2,
          'duration_days': 60,
          'traffic_bytes': 1024,
          'base_price_cents': 1200,
          'discount_cents': 100,
          'price_after_discount_cents': 1100,
        }
      : null,
  'amounts': {
    'conversion_value_cents': 0,
    'account_credit_cents': 0,
    'due_cents': 1100,
  },
  'before': {'remaining_seconds': 0, 'remaining_bytes': 0},
  'after': target
      ? {'duration_days': 60, 'traffic_bytes': 1024, 'activation': 'queued'}
      : null,
  'capability': {
    'quote_supported': true,
    'execute_supported': false,
    'reason': 'cutoff_unsupported',
  },
};

class EntitlementsAPI extends BackendApi {
  EntitlementsAPI(TokenStorage token)
    : super(baseUrl: 'https://example.test', token: token, dio: Dio());
  Future<AccountEntitlements> Function(String?)? fetch;
  final cursors = <String?>[];
  int quoteCalls = 0;
  bool nullTarget = false;
  String recommendationReason = '';
  String capabilityReason = 'cutoff_unsupported';
  @override
  Future<AccountEntitlements> getAccountEntitlements({
    String? historyCursor,
  }) async {
    cursors.add(historyCursor);
    return fetch != null
        ? await fetch!(historyCursor)
        : AccountEntitlements.fromJson(snapshot());
  }

  @override
  Future<EntitlementConversionQuote> quoteEntitlementConversion({
    required String targetTier,
    String? couponCode,
    bool useCredit = true,
    int recoverFromOrderId = 0,
  }) async {
    expect(targetTier, 'premium');
    quoteCalls++;
    return EntitlementConversionQuote.fromJson({
      ...quote(target: !nullTarget),
      'capability': {
        'quote_supported': true,
        'execute_supported': false,
        'reason': capabilityReason,
      },
      'recommendation_reason': recommendationReason,
    });
  }
}

void main() {
  test('恢复付款候选旧服务器兼容、完整回传且拒绝负数零ID及重复来源', () {
    expect(
      EntitlementConversionQuote.fromJson(quote()).recoverablePayments,
      isEmpty,
    );
    final raw = {
      ...quote(),
      'recoverable_payments': [
        {'order_id': 96, 'available_cents': 1036},
      ],
    };
    final parsed = EntitlementConversionQuote.fromJson(raw);
    expect(parsed.recoverablePayments.single['order_id'], 96);
    expect(parsed.toJson(), raw);
    for (final candidates in [
      [
        {'order_id': 0, 'available_cents': 100},
      ],
      [
        {'order_id': 96, 'available_cents': -1},
      ],
      [
        {'order_id': 96, 'available_cents': 0},
      ],
      [
        {'order_id': 96, 'available_cents': 100},
        {'order_id': 96, 'available_cents': 200},
      ],
    ]) {
      expect(
        () => EntitlementConversionQuote.fromJson({
          ...quote(),
          'recoverable_payments': candidates,
        }),
        throwsFormatException,
      );
    }
  });
  test('历史缺少修订不能拼接或破坏已加载记录', () {
    final initial = AccountEntitlements.fromJson({
      ...snapshot(),
      'history_revision': 'h',
    });
    for (final revision in [null, '', ' ']) {
      expect(
        () => initial.append(
          AccountEntitlements.fromJson({
            ...snapshot(history: [grant(9, 'expired')]),
            'history_revision': revision,
          }),
        ),
        throwsA(anything),
      );
      expect(initial.history.map((e) => e.grantId), [4]);
    }
  });
  TestWidgetsFlutterBinding.ensureInitialized();
  late EntitlementsAPI api;
  late ProviderContainer container;
  setUpAll(() async => AppLocalizations.load(const Locale('en')));
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    api = EntitlementsAPI(TokenStorage(await SharedPreferences.getInstance()));
    container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(TestAuth.new),
        backendApiProvider.overrideWith((ref) async => api),
      ],
      retry: (_, _) => null,
    );
    await container.read(authNotifierProvider.future);
  });
  tearDown(() => container.dispose());

  test('金额缺字段必须拒绝报价，不伪造零待付', () {
    final invalid = quote();
    (invalid['amounts'] as Map).remove('due_cents');
    expect(
      () => EntitlementConversionQuote.fromJson(invalid),
      throwsFormatException,
    );
  });
  test('后端409保留历史但拒绝重复旧游标请求', () async {
    final sub = container.listen(accountEntitlementsProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(accountEntitlementsProvider.future);
    api.fetch = (_) async =>
        throw const ConflictException('entitlement_history_changed', '');
    await container.read(accountEntitlementsProvider.notifier).loadMore();
    expect(
      container.read(accountEntitlementsProvider).value!.historyChanged,
      isTrue,
    );
    expect(
      container.read(accountEntitlementsProvider).value!.history.length,
      1,
    );
    final reads = api.cursors.length;
    await container.read(accountEntitlementsProvider.notifier).loadMore();
    expect(api.cursors.length, reads);
  });
  test('暂停原服务日期与预计接续日期保持分离', () {
    final item = AccountEntitlement.fromJson({
      ...grant(9, 'paused'),
      'starts_at': '2026-08-01T00:00:00Z',
      'active_until': '2026-08-30T00:00:00Z',
      'estimated_starts_at': '2026-10-09T00:00:00Z',
      'estimated_ends_at': '2026-11-08T00:00:00Z',
    });
    expect(item.activeUntil.month, 8);
    expect(item.estimatedEndsAt!.month, 11);
    expect(item.isEstimated, isTrue);
  });
  test('API请求真实使用新路径、无缓存和不透明游标；报价不发送客户端金额', () async {
    final dio = Dio();
    final requests = <RequestOptions>[];
    final backend = BackendApi(
      baseUrl: 'https://example.test',
      token: TokenStorage(await SharedPreferences.getInstance()),
      dio: dio,
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: options.path.contains('/quote') ? quote() : snapshot(),
            ),
          );
        },
      ),
    );
    await backend.getAccountEntitlements(historyCursor: 'opaque+/=');
    await backend.quoteEntitlementConversion(
      targetTier: 'premium',
      couponCode: '  SAVE  ',
      useCredit: false,
    );
    expect(
      Uri.parse(requests.first.path).queryParameters['history_cursor'],
      'opaque+/=',
    );
    expect(requests.first.headers['Cache-Control'], 'no-store');
    expect(requests.last.path, '/v1/entitlement-conversions/quote');
    expect(requests.last.data, {
      'target_tier': 'premium',
      'coupon_code': 'SAVE',
      'use_credit': false,
    });
  });
  test('报价API显式来源传整数、取消默认省略且不发送客户端可用金额', () async {
    SharedPreferences.setMockInitialValues({});
    final dio = Dio();
    final requests = <RequestOptions>[];
    final api = BackendApi(
      baseUrl: 'https://example.test',
      token: TokenStorage(await SharedPreferences.getInstance()),
      dio: dio,
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.resolve(
            Response(requestOptions: options, statusCode: 200, data: quote()),
          );
        },
      ),
    );
    await api.quoteEntitlementConversion(
      targetTier: 'premium',
      recoverFromOrderId: 96,
      useCredit: false,
      couponCode: ' SAVE ',
    );
    expect(requests.last.data, {
      'target_tier': 'premium',
      'recover_from_order_id': 96,
      'use_credit': false,
      'coupon_code': 'SAVE',
    });
    await api.quoteEntitlementConversion(targetTier: 'premium');
    expect(
      (requests.last.data as Map).containsKey('recover_from_order_id'),
      false,
    );
  });
  test('成功页历史revision不同也拒绝拼接，而当前revision变化仍可接受', () {
    final a = AccountEntitlements.fromJson({
      ...snapshot(),
      'history_revision': 'history-a',
    });
    final b = AccountEntitlements.fromJson({
      ...snapshot(revision: 'two'),
      'history_revision': 'history-b',
    });
    expect(() => a.append(b), throwsA(isA<EntitlementHistoryChanged>()));
  });
  testWidgets('预计接续序号保留服务端C先于原日期更早的暂停A', (tester) async {
    final c = {
      ...grant(30, 'scheduled'),
      'plan_id': 'premium-monthly',
      'plan_name': '专业C',
      'squad_tier': 'premium',
      'starts_at': '2026-10-09T00:00:00Z',
      'active_until': '2026-11-08T00:00:00Z',
      'estimated_starts_at': '2026-10-09T00:00:00Z',
      'estimated_ends_at': '2026-11-08T00:00:00Z',
    };
    final a = {
      ...grant(10, 'paused'),
      'plan_name': '标准A',
      'starts_at': '2026-08-01T00:00:00Z',
      'active_until': '2026-09-09T00:00:00Z',
      'estimated_starts_at': '2026-11-08T00:00:00Z',
      'estimated_ends_at': '2026-12-08T00:00:00Z',
    };
    // 源日期 A 更早，但服务端的预计接续数组明确为 C→A，客户端不得重新按源日期排序。
    expect(
      DateTime.parse(
        a['starts_at'] as String,
      ).isBefore(DateTime.parse(c['starts_at'] as String)),
      isTrue,
    );
    api.fetch = (_) async => AccountEntitlements.fromJson({
      ...snapshot(history: [], cursor: null),
      'pending': [c, a],
    });
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: AccountEntitlementsCard()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pending-summary')));
    await tester.pumpAndSettle();
    final cRow = find.byKey(const ValueKey('entitlement-30'));
    final aRow = find.byKey(const ValueKey('entitlement-10'));
    expect(cRow, findsOneWidget);
    expect(aRow, findsOneWidget);
    final cTitle = tester
        .widget<Text>(
          find.descendant(of: cRow, matching: find.byType(Text)).first,
        )
        .data!;
    final aTitle = tester
        .widget<Text>(
          find.descendant(of: aRow, matching: find.byType(Text)).first,
        )
        .data!;
    expect(cTitle, matches(RegExp(r'^1\. .*#30$')));
    expect(aTitle, matches(RegExp(r'^2\. .*#10$')));
    expect(tester.getTopLeft(cRow).dy, lessThan(tester.getTopLeft(aRow).dy));
  });
  testWidgets('历史退款显示权益收回，不声称全部现金已退款', (tester) async {
    api.fetch = (_) async => AccountEntitlements.fromJson(
      snapshot(
        history: [
          {...grant(4, 'exhausted'), 'history_reason': 'refunded'},
          {...grant(5, 'exhausted'), 'history_reason': 'exhausted'},
        ],
        cursor: null,
      ),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: EntitlementHistoryList()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Recovered by refund'), findsOneWidget);
    expect(
      find.text(
        'The remaining entitlement was recovered; this does not mean all cash was refunded.',
      ),
      findsOneWidget,
    );
    expect(find.text('Exhausted'), findsOneWidget);
  });
  testWidgets('权益历史保留 order card conversion 周期来源和服务区间', (tester) async {
    final order = grant(41, 'expired');
    final card = {
      ...grant(42, 'expired'),
      'source_kind': 'card',
      'source_order_id': null,
      'source_card_id': 'CARD-42',
    };
    final conversion = {
      ...grant(43, 'converted'),
      'source_kind': 'conversion',
      'source_order_id': null,
      'source_conversion_id': 'conv-43',
      'source_conversion_period_id': 7,
    };
    api.fetch = (_) async => AccountEntitlements.fromJson(
      snapshot(history: [order, card, conversion], cursor: null),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: EntitlementHistoryList()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Order #141'), findsOneWidget);
    expect(find.textContaining('Membership card CARD-42'), findsOneWidget);
    expect(find.textContaining('conv-43 · #7'), findsOneWidget);
    expect(find.textContaining('Service period:'), findsNWidgets(3));
  });
  testWidgets('双 tab 切到权益记录后分页失败保留记录并可重试', (tester) async {
    var fail = true;
    api.fetch = (cursor) async {
      if (cursor == null) return AccountEntitlements.fromJson(snapshot());
      if (fail) throw StateError('offline');
      return AccountEntitlements.fromJson(
        snapshot(history: [grant(5, 'expired')], cursor: null),
      );
    };
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: VerstroOrderHistoryPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Entitlements'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entitlement-4')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('entitlements-more')));
    await tester.pumpAndSettle();
    expect(find.text('Could not load history. Retry.'), findsOneWidget);
    expect(find.byKey(const ValueKey('entitlement-4')), findsOneWidget);
    fail = false;
    await tester.tap(find.text('Retry').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entitlement-5')), findsOneWidget);
    expect(find.text('Entitlements'), findsOneWidget);
  });
  test('完整DTO保留同名多笔、各自状态与来源；失败不能解析为空', () {
    final data = AccountEntitlements.fromJson(snapshot());
    expect(data.pending.map((e) => e.grantId), [2, 3]);
    expect(data.pending.map((e) => e.status), ['scheduled', 'paused']);
    expect(data.currentService.remainingBytes, 77);
    expect(data.paymentState(102), 'queued');
    expect(data.paymentState(101), 'active');
    expect(data.paymentState(999), 'sync_pending');
    expect(() => AccountEntitlements.fromJson({}), throwsA(anything));
  });
  test('历史按稳定编号追加并允许当前服务修订变化，不按套餐名去重', () {
    final initial = AccountEntitlements.fromJson(snapshot());
    final page = AccountEntitlements.fromJson(
      snapshot(
        revision: 'two',
        history: [grant(4, 'expired'), grant(5, 'expired')],
        cursor: null,
      ),
    );
    final merged = initial.append(page);
    expect(merged.history.map((e) => e.grantId), [4, 5]);
    expect(merged.revision, 'two');
    expect(merged.nextHistoryCursor, isNull);
  });
  test('缺history_revision坏页保留provider历史并可重试', () async {
    final sub = container.listen(accountEntitlementsProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(accountEntitlementsProvider.future);
    api.fetch = (_) async => AccountEntitlements.fromJson({
      ...snapshot(history: [grant(99, 'expired')]),
      'history_revision': '',
    });
    await container.read(accountEntitlementsProvider.notifier).loadMore();
    final state = container.read(accountEntitlementsProvider).value!;
    expect(state.history.map((e) => e.grantId), [4]);
    expect(state.historyError, isTrue);
    expect(state.historyChanged, isFalse);
  });
  test('分页失败保留当前、待生效和已加载历史；可重试', () async {
    final sub = container.listen(accountEntitlementsProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(accountEntitlementsProvider.future);
    api.fetch = (_) async => throw StateError('history changed');
    await container.read(accountEntitlementsProvider.notifier).loadMore();
    expect(
      container.read(accountEntitlementsProvider).value!.historyError,
      isTrue,
    );
    expect(
      container.read(accountEntitlementsProvider).value!.history.single.grantId,
      4,
    );
    api.fetch = (_) async => AccountEntitlements.fromJson(
      snapshot(history: [grant(5, 'expired')], cursor: null),
    );
    await container.read(accountEntitlementsProvider.notifier).loadMore();
    expect(
      container.read(accountEntitlementsProvider).value!.history.length,
      2,
    );
    expect(api.cursors, [null, 'opaque', 'opaque']);
  });
  test('账号切换或退出后迟到分页不得带入新账号', () async {
    final sub = container.listen(accountEntitlementsProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(accountEntitlementsProvider.future);
    final pending = Completer<AccountEntitlements>();
    api.fetch = (_) => pending.future;
    final more = container
        .read(accountEntitlementsProvider.notifier)
        .loadMore();
    await container.pump();
    (container.read(authNotifierProvider.notifier) as TestAuth).logoutForTest();
    await container.pump();
    pending.complete(
      AccountEntitlements.fromJson(
        snapshot(history: [grant(99, 'expired')], cursor: null),
      ),
    );
    await more;
    expect(await container.read(accountEntitlementsProvider.future), isNull);
  });
  testWidgets('常驻卡渲染同名暂停权益和加载错误重试', (tester) async {
    api.fetch = (_) async => throw StateError('offline');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: AccountEntitlementsCard()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('My plan entitlements'), findsOneWidget);
    expect(find.text('Could not load entitlements. Retry'), findsOneWidget);
    api.fetch = (_) async => AccountEntitlements.fromJson(snapshot());
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pending-summary')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entitlement-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('entitlement-3')), findsOneWidget);
    expect(find.text('Paused'), findsOneWidget);
    expect(find.textContaining('Standard · Monthly'), findsWidgets);
  });
  testWidgets('首屏只显示当前服务摘要，明细与有记录的排期按需展开', (tester) async {
    api.fetch = (_) async => AccountEntitlements.fromJson(snapshot());
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: AccountEntitlementsCard()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entitlement-1')), findsNothing);
    expect(find.byKey(const ValueKey('entitlement-2')), findsNothing);
    expect(find.byKey(const ValueKey('entitlement-4')), findsNothing);
    expect(find.byKey(const ValueKey('current-details')), findsOneWidget);
    expect(find.byKey(const ValueKey('pending-summary')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('pending-summary')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entitlement-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('entitlement-3')), findsOneWidget);
  });

  testWidgets('空排期不显示标题、空态或预计说明', (tester) async {
    api.fetch = (_) async => AccountEntitlements.fromJson({
      ...snapshot(history: [], cursor: null),
      'pending': <Map<String, dynamic>>[],
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: AccountEntitlementsCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Scheduled or paused'), findsNothing);
    expect(find.text('No records'), findsNothing);
    expect(find.textContaining('Estimated order and dates'), findsNothing);
    expect(find.text('Past entitlements'), findsNothing);
  });

  testWidgets('专业当前无标准候选时不显示新折价升级入口', (tester) async {
    api.fetch = (_) async => AccountEntitlements.fromJson({
      ...snapshot(history: [], cursor: null),
      'current': [
        {
          ...grant(1, 'active'),
          'plan_id': 'premium-monthly',
          'squad_tier': 'premium',
        },
      ],
      'pending': <Map<String, dynamic>>[],
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: AccountEntitlementsCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('conversion-preview')), findsNothing);
    expect(find.byKey(const ValueKey('renew-premium')), findsOneWidget);
  });

  testWidgets('标准升专业与专业中标准候选的 CTA 语义分开', (tester) async {
    Future<void> pump(Map<String, dynamic> raw) async {
      api.fetch = (_) async => AccountEntitlements.fromJson(raw);
      container.invalidate(accountEntitlementsProvider);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: AccountEntitlementsCard()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pump({
      ...snapshot(history: [], cursor: null),
      'current_service': {
        ...snapshot()['current_service'] as Map<String, dynamic>,
        'squad_tier': 'standard',
      },
    });
    expect(find.text('Upgrade to Pro'), findsOneWidget);
    await pump(snapshot(history: [], cursor: null));
    expect(
      find.text('Convert Standard entitlement to Pro renewal'),
      findsOneWidget,
    );
  });

  testWidgets('320 宽且文字放大 1.5 时摘要与折叠入口无溢出', (tester) async {
    api.fetch = (_) async => AccountEntitlements.fromJson(snapshot());
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: Scaffold(
              body: SingleChildScrollView(child: AccountEntitlementsCard()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('current-details')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entitlement-1')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('pending-summary')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('pending-summary')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('entitlement-2')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('renew-premium')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('renew-premium')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('换账号的等待帧不保留旧账号换购恢复入口', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('verstro_conversion_attempt_v1_1', '{}');
    await prefs.remove('verstro_conversion_attempt_v1_2');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: AccountEntitlementsCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('conversion-recovery-entry')),
      findsOneWidget,
    );
    (container.read(authNotifierProvider.notifier) as TestAuth).switchUser(2);
    await tester.pump();
    expect(
      find.byKey(const ValueKey('conversion-recovery-entry')),
      findsNothing,
    );
  });
  testWidgets('只读升级报价显示真实能力门且无普通购买后备；输入变化清空旧报价', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: EntitlementConversionPage()),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    // 持久恢复先核验登录及用户作用域缓存，按钮就绪后再点击。
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('conversion-quote')));
    await tester.pumpAndSettle();
    expect(api.quoteCalls, 1);
    expect(find.textContaining('cutoff_unsupported'), findsOneWidget);
    expect(find.textContaining('unknown_funding'), findsOneWidget);
    expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
    await tester.enterText(find.byType(TextField), 'NEW');
    await tester.pump();
    expect(find.textContaining('cutoff_unsupported'), findsNothing);
  });
  testWidgets('换购运维关闭不应误报计量不足且不能确认购买', (tester) async {
    api.capabilityReason = 'conversion_admission_closed';
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: EntitlementConversionPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('conversion-quote')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('New conversions are temporarily closed.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Reliable final metering is unavailable.'),
      findsNothing,
    );
    expect(find.textContaining('conversion_admission_closed'), findsOneWidget);
    expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
    expect(api.quoteCalls, 1);
  });
  testWidgets('所有目标套餐不可售不应显示折价覆盖不足', (tester) async {
    api.nullTarget = true;
    api.recommendationReason = 'no_available_plans';
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: EntitlementConversionPage()),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    // 持久恢复先核验登录及用户作用域缓存，按钮就绪后再点击。
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('conversion-quote')));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'No target plans are currently available for purchase. Try again later.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('No eligible plan covers the full conversion value'),
      findsNothing,
    );
  });
  testWidgets('无合法目标after为空仍可显示来源排除说明', (tester) async {
    api.nullTarget = true;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: EntitlementConversionPage()),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    // 持久恢复先核验登录及用户作用域缓存，按钮就绪后再点击。
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('conversion-quote')));
    await tester.pumpAndSettle();
    expect(find.textContaining('unknown_funding'), findsOneWidget);
    expect(
      find.text('No eligible plan covers the full conversion value'),
      findsOneWidget,
    );
  });
}
