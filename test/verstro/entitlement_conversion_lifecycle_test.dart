import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/pages/entitlement_conversion_page.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'support/test_auth.dart';
import 'package:dio/dio.dart';
import 'package:fl_clash/verstro/api/account_entitlement_models.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_entitlements_test.dart' as fixtures;

Map<String, dynamic> conversionResource({
  String status = 'reconfirm_required',
}) => {
  'id': '00000000-0000-0000-0000-000000000011',
  'status': status,
  'revision': 3,
  'quote': fixtures.quote(),
  'payment_order_id': 123,
  'payment_order': null,
  'expires_at': '2026-09-10T00:00:00Z',
  'can_confirm': true,
  'can_cancel': true,
  'reason': 'payment_received',
  'result_grant_ids': <int>[],
};

class ConversionTestAPI extends fixtures.EntitlementsAPI {
  ConversionTestAPI(super.token);
  int creates = 0, confirms = 0, requotes = 0, reads = 0;
  bool failFirstCreate = false;
  bool recoveryCandidates = false, admissionClosed = false;
  final quoteRequests = <Map<String, dynamic>>[];
  final createRequests = <Map<String, dynamic>>[];
  final requoteRequests = <Map<String, dynamic>>[];
  Future<EntitlementConversion> Function(String id)? readOverride;
  final keys = <String>[];
  Map<String, dynamic> current = conversionResource();
  @override
  Future<EntitlementConversionQuote> quoteEntitlementConversion({
    required String targetTier,
    String? couponCode,
    bool useCredit = true,
    int recoverFromOrderId = 0,
  }) async {
    quoteRequests.add({
      'recover_from_order_id': recoverFromOrderId,
      'use_credit': useCredit,
      'coupon_code': couponCode,
    });
    final raw = fixtures.quote();
    if (recoveryCandidates) {
      raw['promotion'] = {'credit_allowed': false};
      raw['amounts'] = {
        'conversion_value_cents': 0,
        'account_credit_cents': 0,
        'carried_funding_cents': recoverFromOrderId > 0 ? 1036 : 0,
        'carried_from_order_id': recoverFromOrderId,
        'due_cents': recoverFromOrderId > 0 ? 64 : 1100,
      };
    }
    if (recoveryCandidates) {
      raw['recoverable_payments'] = [
        {'order_id': 96, 'available_cents': 1036},
        {'order_id': 97, 'available_cents': 200},
      ];
    }
    raw['expires_at'] = DateTime.now()
        .toUtc()
        .add(const Duration(minutes: 5))
        .toIso8601String();
    raw['capability'] = {
      'quote_supported': true,
      'execute_supported': !admissionClosed,
      'reason': admissionClosed ? 'conversion_admission_closed' : '',
    };
    return EntitlementConversionQuote.fromJson(raw);
  }

  @override
  Future<EntitlementConversion> createEntitlementConversion({
    required Map<String, dynamic> request,
    required EntitlementConversionQuote quote,
    required String idempotencyKey,
  }) async {
    creates++;
    createRequests.add(Map<String, dynamic>.from(request));
    keys.add(idempotencyKey);
    if (failFirstCreate && creates == 1) throw TimeoutException('synthetic');
    current = {...current, 'quote': quote.toJson()};
    return EntitlementConversion.fromJson(current);
  }

  @override
  Future<EntitlementConversion> getEntitlementConversion(String id) async {
    reads++;
    if (readOverride != null) return readOverride!(id);
    return EntitlementConversion.fromJson(current);
  }

  @override
  Future<EntitlementConversion> requoteEntitlementConversion(
    String id, {
    required Map<String, dynamic> request,
  }) async {
    requotes++;
    requoteRequests.add(Map<String, dynamic>.from(request));
    current = {
      ...current,
      'revision': 4,
      'quote': (await quoteEntitlementConversion(
        targetTier: 'premium',
      )).toJson(),
      'can_confirm': true,
      'reason': 'quote_acceptance_required',
    };
    return EntitlementConversion.fromJson(current);
  }

  @override
  Future<EntitlementConversion> confirmEntitlementConversion(
    String id, {
    required int revision,
    required String quoteToken,
  }) async {
    confirms++;
    current = {
      ...current,
      'status': 'pending_sync',
      'revision': 5,
      'can_confirm': false,
      'can_cancel': false,
    };
    return EntitlementConversion.fromJson(current);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('新预览显示原到账款且显式选择废弃旧报价并保留候选', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await AppLocalizations.load(const Locale('en'));
    final api = ConversionTestAPI(
      TokenStorage(await SharedPreferences.getInstance()),
    )..recoveryCandidates = true;
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(TestAuth.new),
        backendApiProvider.overrideWith((ref) async => api),
      ],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
    await container.read(authNotifierProvider.future);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: EntitlementConversionPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('conversion-quote')));
    await tester.pumpAndSettle();
    final selector = find.byKey(const ValueKey('conversion-recovery'));
    expect(selector, findsOneWidget);
    final dropdown = tester.widget<DropdownButtonFormField<int>>(selector);
    expect(dropdown.initialValue, 0);
    dropdown.onChanged!(96);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
    expect(
      tester
          .widget<DropdownButton<int>>(
            find.descendant(
              of: selector,
              matching: find.byType(DropdownButton<int>),
            ),
          )
          .items!
          .length,
      3,
    );
    expect(api.creates, 0);
    await tester.pumpWidget(const SizedBox());
  });

  for (final closed in [false, true]) {
    testWidgets('原款选取消重新报价和余额独立、账号隔离，接纳关闭=$closed', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await AppLocalizations.load(const Locale('en'));
      final api =
          ConversionTestAPI(TokenStorage(await SharedPreferences.getInstance()))
            ..recoveryCandidates = true
            ..admissionClosed = closed;
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(TestAuth.new),
          backendApiProvider.overrideWith((ref) async => api),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);
      await tester.binding.setSurfaceSize(const Size(800, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: EntitlementConversionPage()),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> load() async {
        await tester.tap(find.byKey(const ValueKey('conversion-quote')));
        await tester.pumpAndSettle();
      }

      await load();
      expect(api.quoteRequests.single['recover_from_order_id'], 0);
      final selector = find.byKey(const ValueKey('conversion-recovery'));
      tester.widget<DropdownButtonFormField<int>>(selector).onChanged!(96);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
      expect(api.quoteRequests.length, 1);
      await load();
      expect(api.quoteRequests.last['recover_from_order_id'], 96);
      expect(
        find.textContaining('${AppLocalizations.current.vConvCarry}: #96'),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('conversion-create')),
        closed ? findsNothing : findsOneWidget,
      );
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged!(
        false,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
      await load();
      expect(api.quoteRequests.last['recover_from_order_id'], 96);
      expect(api.quoteRequests.last['use_credit'], false);
      tester.widget<DropdownButtonFormField<int>>(selector).onChanged!(97);
      await tester.pumpAndSettle();
      tester.widget<DropdownButtonFormField<int>>(selector).onChanged!(0);
      await tester.pumpAndSettle();
      await load();
      expect(api.quoteRequests.last['recover_from_order_id'], 0);
      expect(
        find.textContaining('${AppLocalizations.current.vConvCarry}: #96'),
        findsNothing,
      );
      tester.widget<DropdownButtonFormField<int>>(selector).onChanged!(96);
      await tester.pumpAndSettle();
      (container.read(authNotifierProvider.notifier) as TestAuth).switchUser(2);
      await tester.pumpAndSettle();
      expect(selector, findsNothing);
      await load();
      expect(api.quoteRequests.last['recover_from_order_id'], 0);
      expect(api.creates, 0);
      await tester.pumpWidget(const SizedBox());
    });
  }
  for (final named in [false, true]) {
    testWidgets('原款恢复未知创建与具名草稿保留来源，具名=$named', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await AppLocalizations.load(const Locale('en'));
      final prefs = await SharedPreferences.getInstance();
      final api = ConversionTestAPI(TokenStorage(prefs))
        ..recoveryCandidates = true;
      final q = await api.quoteEntitlementConversion(
        targetTier: 'premium',
        recoverFromOrderId: 96,
      );
      final request = {
        'target_tier': 'premium',
        'use_credit': false,
        'coupon_code': 'ORIGINAL',
        'recover_from_order_id': 96,
      };
      final saved = named
          ? {
              'id': api.current['id'],
              'request': request,
              'accepted_request': request,
              'accepted_quote_token': q.quoteToken,
              'dirty': false,
            }
          : {
              'key': 'unknown-original-key',
              'request': request,
              'quote': q.toJson(),
            };
      await prefs.setString(
        'verstro_conversion_attempt_v1_1',
        jsonEncode(saved),
      );
      api.current = {...api.current, 'quote': q.toJson()};
      api.quoteRequests.clear();
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(TestAuth.new),
          backendApiProvider.overrideWith((ref) async => api),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);
      await tester.binding.setSurfaceSize(const Size(800, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: EntitlementConversionPage(
              conversionId: named ? api.current['id'] as String : null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('conversion-recovery')), findsNothing);
      expect(api.creates, 0);
      expect(api.quoteRequests, isEmpty);
      expect(
        find.textContaining('${AppLocalizations.current.vConvCarry}: #96'),
        findsOneWidget,
      );
      if (named) {
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged!(
          true,
        );
        await tester.pumpAndSettle();
        expect(
          (jsonDecode(prefs.getString('verstro_conversion_attempt_v1_1')!)
              as Map)['request']['recover_from_order_id'],
          96,
        );
        await tester.tap(find.byKey(const ValueKey('conversion-requote')));
        await tester.pumpAndSettle();
        expect(
          api.requoteRequests.single.containsKey('recover_from_order_id'),
          false,
        );
      } else {
        await tester.tap(find.byKey(const ValueKey('conversion-create')));
        await tester.pumpAndSettle();
        expect(api.keys.single, 'unknown-original-key');
        expect(api.createRequests.single, request);
      }
      expect(api.confirms, 0);
      await tester.pumpWidget(const SizedBox());
    });
  }
  for (final status in [
    'expired',
    'cancelled',
    'completed',
    'awaiting_payment',
  ]) {
    testWidgets('升级入口仅在服务端确认终态后脱离旧资源 $status', (tester) async {
      const cid = '00000000-0000-0000-0000-000000000011';
      const key = 'verstro_conversion_attempt_v1_1';
      final saved = jsonEncode({
        'id': cid,
        'request': {'target_tier': 'premium', 'use_credit': false},
      });
      SharedPreferences.setMockInitialValues({key: saved, 'unrelated': 'keep'});
      await AppLocalizations.load(const Locale('en'));
      final prefs = await SharedPreferences.getInstance();
      final api = ConversionTestAPI(TokenStorage(prefs));
      api.current = {
        ...api.current,
        'status': status,
        'can_confirm': false,
        'can_cancel': status == 'awaiting_payment',
      };
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(TestAuth.new),
          backendApiProvider.overrideWith((ref) async => api),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: EntitlementConversionPage()),
        ),
      );
      await tester.pumpAndSettle();
      if (status == 'awaiting_payment') {
        expect(
          find.byKey(const ValueKey('conversion-refresh')),
          findsOneWidget,
        );
        expect(prefs.getString(key), saved);
      } else {
        expect(find.byKey(const ValueKey('conversion-quote')), findsOneWidget);
        expect(find.byKey(const ValueKey('conversion-refresh')), findsNothing);
        expect(prefs.getString(key), isNull);
      }
      expect(prefs.getString('unrelated'), 'keep');
      expect(api.reads, 1);
      expect(api.creates + api.confirms + api.requotes, 0);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('历史过期换购保留可查且首屏提供新升级入口', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await AppLocalizations.load(const Locale('en'));
    final api = ConversionTestAPI(
      TokenStorage(await SharedPreferences.getInstance()),
    );
    api.current = {
      ...api.current,
      'status': 'expired',
      'can_confirm': false,
      'can_cancel': false,
    };
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(TestAuth.new),
        backendApiProvider.overrideWith((ref) async => api),
      ],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
    await container.read(authNotifierProvider.future);
    await tester.binding.setSurfaceSize(const Size(480, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: EntitlementConversionPage(
            conversionId: api.current['id'] as String,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('conversion-refresh')), findsOneWidget);
    final start = find.byKey(const ValueKey('conversion-new-preview'));
    expect(start.hitTestable(), findsOneWidget);
    await tester.tap(start);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('conversion-quote')), findsOneWidget);
    expect(api.creates + api.confirms + api.requotes, 0);
    await tester.pumpWidget(const SizedBox());
  });
  for (final outcome in ['GET失败', '同账号草稿替换', '账号切换']) {
    testWidgets('草稿恢复安全负例：$outcome', (tester) async {
      const cid = '00000000-0000-0000-0000-000000000011';
      const otherId = '00000000-0000-0000-0000-000000000022';
      const key = 'verstro_conversion_attempt_v1_1';
      const otherKey = 'verstro_conversion_attempt_v1_2';
      final original = jsonEncode({
        'id': cid,
        'request': {'target_tier': 'premium', 'use_credit': false},
      });
      final replacement = jsonEncode({
        'id': otherId,
        'request': {'target_tier': 'premium', 'use_credit': true},
      });
      SharedPreferences.setMockInitialValues({
        key: original,
        otherKey: replacement,
        'unrelated': 'keep',
      });
      await AppLocalizations.load(const Locale('en'));
      final prefs = await SharedPreferences.getInstance();
      final pending = Completer<EntitlementConversion>();
      final api = ConversionTestAPI(TokenStorage(prefs));
      api.readOverride = (id) async {
        if (id == cid) return pending.future;
        expect(id, otherId);
        return EntitlementConversion.fromJson({
          ...conversionResource(status: 'awaiting_payment'),
          'id': otherId,
          'can_confirm': false,
        });
      };
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(TestAuth.new),
          backendApiProvider.overrideWith((ref) async => api),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: EntitlementConversionPage()),
        ),
      );
      // GET 未返回时不等待持续动画；先证明请求确实在途。
      await tester.pump();
      expect(api.reads, 1);
      expect(pending.isCompleted, false);
      expect(prefs.getString(key), original);
      // 首次 build 可能仍显示禁用的只读报价按钮，绝不能启用或创建。
      final loadingQuote = find.byKey(const ValueKey('conversion-quote'));
      for (final button in tester.widgetList<FilledButton>(loadingQuote)) {
        expect(button.onPressed, isNull);
      }
      expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
      expect(
        find.byKey(const ValueKey('conversion-new-preview')),
        findsNothing,
      );
      if (outcome == '同账号草稿替换') {
        expect(await prefs.setString(key, replacement), true);
      } else if (outcome == '账号切换') {
        (container.read(authNotifierProvider.notifier) as TestAuth).switchUser(
          2,
        );
        await tester.pump();
        await tester.pump();
        expect(api.reads, 2);
      }
      if (outcome == 'GET失败') {
        pending.completeError(TimeoutException('synthetic GET failure'));
      } else {
        pending.complete(
          EntitlementConversion.fromJson({
            ...conversionResource(status: 'expired'),
            'can_confirm': false,
            'can_cancel': false,
          }),
        );
      }
      await tester.pumpAndSettle();
      expect(
        prefs.getString(key),
        outcome == '同账号草稿替换' ? replacement : original,
      );
      expect(prefs.getString(otherKey), replacement);
      expect(prefs.getString('unrelated'), 'keep');
      expect(api.creates + api.confirms + api.requotes, 0);
      expect(find.byKey(const ValueKey('conversion-quote')), findsNothing);
      expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
      expect(find.byKey(const ValueKey('conversion-refresh')), findsOneWidget);
      if (outcome == '账号切换') {
        expect(find.textContaining(otherId), findsOneWidget);
        expect(find.textContaining(cid), findsNothing);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
  for (final unknownCreate in [false, true]) {
    testWidgets('历史终态新预览保护另一草稿：未知创建=$unknownCreate', (tester) async {
      const key = 'verstro_conversion_attempt_v1_1';
      final saved = jsonEncode(
        unknownCreate
            ? {
                'key': 'original-unknown-create-key',
                'request': {'target_tier': 'premium', 'use_credit': false},
                'quote': fixtures.quote(),
              }
            : {
                'id': '00000000-0000-0000-0000-000000000022',
                'request': {'target_tier': 'premium', 'use_credit': false},
              },
      );
      SharedPreferences.setMockInitialValues({key: saved, 'unrelated': 'keep'});
      await AppLocalizations.load(const Locale('en'));
      final prefs = await SharedPreferences.getInstance();
      final api = ConversionTestAPI(TokenStorage(prefs));
      api.current = {
        ...conversionResource(status: 'expired'),
        'can_confirm': false,
        'can_cancel': false,
      };
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(TestAuth.new),
          backendApiProvider.overrideWith((ref) async => api),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);
      await tester.binding.setSurfaceSize(const Size(480, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: EntitlementConversionPage(
              conversionId: api.current['id'] as String,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(prefs.getString(key), saved);
      final start = find.byKey(const ValueKey('conversion-new-preview'));
      expect(start.hitTestable(), findsOneWidget);
      await tester.tap(start);
      await tester.pumpAndSettle();
      expect(prefs.getString(key), saved);
      expect(prefs.getString('unrelated'), 'keep');
      expect(api.reads, 1);
      expect(api.creates + api.confirms + api.requotes, 0);
      expect(find.byKey(const ValueKey('conversion-quote')), findsNothing);
      expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
      expect(find.byKey(const ValueKey('conversion-refresh')), findsOneWidget);
      expect(find.textContaining(api.current['id'] as String), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('明确点击才创建，超时重试同一幂等键且不自动确认', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await AppLocalizations.load(const Locale('en'));
    final api =
        ConversionTestAPI(TokenStorage(await SharedPreferences.getInstance()))
          ..failFirstCreate = true
          ..recoveryCandidates = true;
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(TestAuth.new),
        backendApiProvider.overrideWith((ref) async => api),
      ],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
    await container.read(authNotifierProvider.future);
    await tester.binding.setSurfaceSize(const Size(800, 2200));
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
    expect(api.creates, 0);
    // 从可见候选实际点击选源，而非预置恢复草稿。
    await tester.tap(find.byKey(const ValueKey('conversion-recovery')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('#96 · 10.36 USDT').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('conversion-create')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('conversion-quote')));
    await tester.pumpAndSettle();
    final create = find.byKey(const ValueKey('conversion-create'));
    expect(create, findsOneWidget);
    await tester.ensureVisible(create);
    await tester.tap(create);
    await tester.pumpAndSettle();
    expect(api.creates, 1);
    expect(api.createRequests.single['recover_from_order_id'], 96);
    final saved =
        jsonDecode(
              (await SharedPreferences.getInstance()).getString(
                'verstro_conversion_attempt_v1_1',
              )!,
            )
            as Map;
    expect(saved['request']['recover_from_order_id'], 96);
    expect(saved['quote']['recoverable_payments'], [
      {'order_id': 96, 'available_cents': 1036},
      {'order_id': 97, 'available_cents': 200},
    ]);
    expect(api.confirms, 0);
    await tester.tap(create);
    await tester.pumpAndSettle();
    expect(api.creates, 2);
    expect(api.createRequests[0], api.createRequests[1]);
    expect(api.keys.toSet().length, 1);
    expect(api.confirms, 0);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('恢复资源重报价不会自动确认，新报价需再次明确接受', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await AppLocalizations.load(const Locale('en'));
    final api = ConversionTestAPI(
      TokenStorage(await SharedPreferences.getInstance()),
    );
    api.current = {
      ...api.current,
      'can_confirm': false,
      'reason': 'economic_terms_changed',
    };
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(TestAuth.new),
        backendApiProvider.overrideWith((ref) async => api),
      ],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
    await container.read(authNotifierProvider.future);
    await tester.binding.setSurfaceSize(const Size(800, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: EntitlementConversionPage(
            conversionId: api.current['id'] as String,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(api.reads, 1);
    expect(api.creates, 0);
    final requote = find.byKey(const ValueKey('conversion-requote'));
    await tester.ensureVisible(requote);
    await tester.tap(requote);
    await tester.pumpAndSettle();
    expect(api.requotes, 1);
    expect(api.confirms, 0);
    final confirm = find.byKey(const ValueKey('conversion-confirm'));
    await tester.ensureVisible(confirm);
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(api.confirms, 1);
    expect(find.byKey(const ValueKey('conversion-cancel')), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('修改输入后轮询不可恢复旧报价确认，指定ID不受坏缓存影响', (tester) async {
    SharedPreferences.setMockInitialValues({
      'verstro_conversion_attempt_v1_1': 'broken',
    });
    await AppLocalizations.load(const Locale('en'));
    final api = ConversionTestAPI(
      TokenStorage(await SharedPreferences.getInstance()),
    );
    api.current['quote'] = (await api.quoteEntitlementConversion(
      targetTier: 'premium',
    )).toJson();
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(TestAuth.new),
        backendApiProvider.overrideWith((ref) async => api),
      ],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
    await container.read(authNotifierProvider.future);
    await tester.binding.setSurfaceSize(const Size(800, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: EntitlementConversionPage(
            conversionId: api.current['id'] as String,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(api.reads, 1);
    await tester.enterText(find.byType(TextField), 'NEW');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('conversion-confirm')),
    );
    expect(button.onPressed, isNull);
    expect(api.confirms, 0);
    await tester.pumpWidget(const SizedBox());
    for (final explicit in [false, true]) {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: EntitlementConversionPage(
              conversionId: explicit ? api.current['id'] as String : null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'NEW',
      );
      expect(
        tester
            .widget<FilledButton>(
              find.byKey(const ValueKey('conversion-confirm')),
            )
            .onPressed,
        isNull,
        reason: 'reopening must not authorize edited draft against old quote',
      );
      await tester.pumpWidget(const SizedBox());
    }
  });
  test('carry必须整数且指向原付款单，不得遗漏金额或超出净价', () {
    final bad = fixtures.quote();
    bad['amounts'] = {
      ...bad['amounts'] as Map<String, dynamic>,
      'carried_funding_cents': 1.5,
    };
    expect(() => EntitlementConversionQuote.fromJson(bad), throwsA(anything));
    bad['amounts']['carried_funding_cents'] = 1;
    expect(() => EntitlementConversionQuote.fromJson(bad), throwsA(anything));
  });
  test('换购资源缺修订或未知状态不伪装可确认成功', () {
    final resource = EntitlementConversion.fromJson(conversionResource());
    expect(resource.revision, 3);
    expect(resource.paymentOrderId, 123);
    expect(resource.isTerminal, isFalse);
    expect(
      () => EntitlementConversion.fromJson(
        {...conversionResource()}..remove('revision'),
      ),
      throwsA(anything),
    );
    expect(
      () => EntitlementConversion.fromJson(
        conversionResource(status: 'invented'),
      ),
      throwsFormatException,
    );
    expect(
      () => EntitlementConversion.fromJson({
        ...conversionResource(),
        'can_confirm': 'true',
      }),
      throwsA(anything),
    );
  });
  test('提交的完整签名报价保留原字段，调用方修改不能篡改快照', () {
    final raw = fixtures.quote();
    final expected = jsonDecode(jsonEncode(raw));
    final parsed = EntitlementConversionQuote.fromJson(raw);
    (raw['amounts'] as Map)['due_cents'] = 0;
    expect(parsed.toJson(), expected);
  });
  test('资金读取独立保存换购占用，不能重计可购买余额', () {
    final funds = CreditDto.fromJson({
      'balance_cents': 100,
      'conversion_held_cents': 300,
      'credits': [],
    });
    expect(funds.purchaseBalanceCents, 100);
    expect(funds.conversionHeldCents, 300);
    expect(
      () => CreditDto.fromJson({
        'balance_cents': 100,
        'conversion_held_cents': -1,
      }),
      throwsFormatException,
    );
  });
  test('换购API发送真实资源路径、严格revision及稳定幂等键，不调用普通下单', () async {
    SharedPreferences.setMockInitialValues({});
    final dio = Dio();
    final requests = <RequestOptions>[];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: conversionResource(),
            ),
          );
        },
      ),
    );
    final api = BackendApi(
      baseUrl: 'https://example.test',
      token: TokenStorage(await SharedPreferences.getInstance()),
      dio: dio,
    );
    const request = {'target_tier': 'premium', 'use_credit': false};
    final resource = await api.createEntitlementConversion(
      request: request,
      quote: EntitlementConversionQuote.fromJson(fixtures.quote()),
      idempotencyKey: 'synthetic-conversion-key',
    );
    await api.getEntitlementConversion(resource.id);
    await api.requoteEntitlementConversion(resource.id, request: request);
    await api.confirmEntitlementConversion(
      resource.id,
      revision: 3,
      quoteToken: 'synthetic',
    );
    await api.cancelEntitlementConversion(resource.id, revision: 3);
    expect(requests.map((r) => r.method), [
      'POST',
      'GET',
      'POST',
      'POST',
      'POST',
    ]);
    expect(
      requests.every((r) => r.path.contains('/entitlement-conversions')),
      isTrue,
    );
    expect(
      requests.first.headers['Idempotency-Key'],
      'synthetic-conversion-key',
    );
    expect(requests[3].data, {'revision': 3, 'quote_token': 'synthetic'});
    expect(requests[4].data, {'revision': 3});
    expect(
      requests.every((r) => r.headers['Cache-Control'] == 'no-store'),
      isTrue,
    );
  });
}
