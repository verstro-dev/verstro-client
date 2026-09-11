import '../support/test_auth.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:fl_clash/verstro/providers/credit_provider.dart';
import 'package:fl_clash/verstro/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestApi extends BackendApi {
  TestApi(TokenStorage superToken)
    : super(baseUrl: 'https://example.test', token: superToken, dio: Dio());
  int reads = 0;
  Future<CreditDto> Function()? fetch;
  @override
  Future<CreditDto> getCredit() {
    reads++;
    return fetch?.call() ??
        Future.value(const CreditDto(balanceCents: 250, credits: []));
  }

  @override
  Future<ClaimTxResult> claimTx(int orderId, String txHash) async =>
      ClaimTxResult.fromJson({
        'resolution': 'split_payment_partial',
        'credited_cents': 0,
      });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TestApi api;
  late ProviderContainer container;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    api = TestApi(TokenStorage(await SharedPreferences.getInstance()));
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
  test('认证加载时不沿用旧账号余额', () async {
    final sub = container.listen(creditProvider, (_, _) {});
    addTearDown(sub.close);
    expect((await container.read(creditProvider.future)).balanceCents, 250);
    (container.read(authNotifierProvider.notifier) as TestAuth).loading();
    await container.pump();
    expect((await container.read(creditProvider.future)).balanceCents, 0);
    expect(api.reads, 1);
  });
  test('切换账号丢弃旧请求，登出清空', () async {
    final sub = container.listen(creditProvider, (_, _) {});
    addTearDown(sub.close);
    final old = Completer<CreditDto>();
    api.fetch = () => old.future;
    container.read(creditProvider);
    await container.pump();
    api.fetch = () async => const CreditDto(balanceCents: 900, credits: []);
    (container.read(authNotifierProvider.notifier) as TestAuth).switchUser(2);
    await container.pump();
    expect((await container.read(creditProvider.future)).balanceCents, 900);
    old.complete(const CreditDto(balanceCents: 777, credits: []));
    await container.pump();
    expect(container.read(creditProvider).value?.balanceCents, 900);
    (container.read(authNotifierProvider.notifier) as TestAuth).logoutForTest();
    await container.pump();
    expect((await container.read(creditProvider.future)).balanceCents, 0);
  });
  test('余额请求失败保持错误状态', () async {
    api.fetch = () async => throw StateError('offline');
    await expectLater(container.read(creditProvider.future), throwsStateError);
    expect(container.read(creditProvider).hasError, isTrue);
  });
  testWidgets('提交哈希部分到账且 credited=0 也刷新余额', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              ref.watch(creditProvider);
              return TextButton(
                onPressed: () async {
                  await claimTx(ref, 501, 'hash');
                },
                child: const Text('claim'),
              );
            },
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(api.reads, 1);
    await tester.tap(find.text('claim'));
    await tester.pump();
    await tester.pump();
    expect(api.reads, 2);
  });
}
