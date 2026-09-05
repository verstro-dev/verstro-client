import 'package:dio/dio.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';
import 'package:fl_clash/verstro/pages/usdt_invoice_page.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:fl_clash/verstro/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

String hashOf(String character) => List.filled(64, character).join();

OrderDto order({
  String status = 'waiting',
  int receivedCents = 0,
  int remainingCents = 0,
  int paymentCount = 0,
  String? txid,
}) => OrderDto.fromJson({
  'id': 77,
  'plan_id': 'monthly',
  'base_price': '6.00',
  'final_amount': '6.07',
  'status': status,
  if (status == 'waiting' || status == 'partially_paid')
    'deposit_address': 'TXxxxxxxxxxxxxxxxxxxxxxxxxxxxEygM',
  'pay_currency': 'usdttrc20',
  if (receivedCents != 0) 'received_cents': receivedCents,
  if (remainingCents != 0) 'remaining_cents': remainingCents,
  if (paymentCount != 0) 'payment_count': paymentCount,
  'txid': ?txid,
  'created_at': DateTime.now()
      .subtract(const Duration(minutes: 1))
      .toUtc()
      .toIso8601String(),
  'expires_at': DateTime.now()
      .add(const Duration(hours: 1))
      .toUtc()
      .toIso8601String(),
  if (status == 'finished') 'paid_at': DateTime.now().toUtc().toIso8601String(),
});

ClaimTxResult claimResult({
  required String resolution,
  bool matched = false,
  int receivedCents = 0,
  int remainingCents = 0,
  int paymentCount = 0,
  int creditedCents = 0,
  int retryAfterSeconds = 0,
  String? orderStatus,
}) => ClaimTxResult.fromJson({
  'matched': matched,
  'message': '自由 message 不得决定 Widget 分支',
  'resolution': resolution,
  if (receivedCents != 0) 'received_cents': receivedCents,
  if (remainingCents != 0) 'remaining_cents': remainingCents,
  if (paymentCount != 0) 'payment_count': paymentCount,
  if (creditedCents != 0) 'credited_cents': creditedCents,
  if (retryAfterSeconds != 0) 'retry_after_seconds': retryAfterSeconds,
  'order_status': ?orderStatus,
});

class _ClaimStep {
  const _ClaimStep(this.result, {this.nextOrder});

  final ClaimTxResult result;
  final OrderDto? nextOrder;
}

class _FakeBackendApi extends BackendApi {
  _FakeBackendApi(
    TokenStorage token, {
    required OrderDto initialOrder,
    required List<_ClaimStep> claimSteps,
  }) : _order = initialOrder,
       _claimSteps = List<_ClaimStep>.of(claimSteps),
       super(baseUrl: 'https://billing.example.test', token: token, dio: Dio());

  OrderDto _order;
  final List<_ClaimStep> _claimSteps;
  final claimedHashes = <String>[];
  int getOrderCalls = 0;

  @override
  Future<OrderDto> getOrder(int orderId) async {
    getOrderCalls++;
    return _order;
  }

  @override
  Future<ClaimTxResult> claimTx(int orderId, String txHash) async {
    claimedHashes.add(txHash);
    if (_claimSteps.isEmpty) {
      throw StateError('unexpected claim call');
    }
    final step = _claimSteps.removeAt(0);
    if (step.nextOrder != null) _order = step.nextOrder!;
    return step.result;
  }
}

class _MutableClock {
  _MutableClock(this.value);

  DateTime value;

  DateTime now() => value;

  void advance(Duration duration) {
    value = value.add(duration);
  }
}

const _subscription = SubscriptionDto(
  hasSubscription: true,
  subscriptionUrl: 'https://api.example.test/sub/token',
  currentPlanId: 'monthly',
  periodStartedAt: null,
  periodExpiresAt: null,
  trafficLimitBytes: 1,
  trafficUsedBytes: 0,
  isExpired: false,
);

Future<_FakeBackendApi> _pumpInvoice(
  WidgetTester tester, {
  required OrderDto initialOrder,
  required List<_ClaimStep> claimSteps,
  DateTime Function()? now,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final api = _FakeBackendApi(
    TokenStorage(prefs),
    initialOrder: initialOrder,
    claimSteps: claimSteps,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        backendApiProvider.overrideWith((ref) async => api),
        orderDetailStreamProvider.overrideWith((ref, orderId) async* {
          yield await api.getOrder(orderId);
        }),
        subscriptionProvider.overrideWith((ref) async => _subscription),
      ],
      child: MaterialApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        home: VerstroUsdtInvoicePage(
          order: initialOrder,
          now: now ?? DateTime.now,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  return api;
}

Future<void> openClaimDialog(WidgetTester tester) async {
  final open = find.text('我已付款 (输入 tx hash 立即验证)');
  await tester.ensureVisible(open);
  await tester.pump();
  await tester.tap(open);
  await tester.pumpAndSettle();
  expect(find.byType(AlertDialog), findsOneWidget);
}

Future<void> openExpiredClaimDialog(WidgetTester tester) async {
  final open = find.text('我已付款（提交交易号）');
  await tester.tap(open);
  await tester.pumpAndSettle();
  expect(find.byType(AlertDialog), findsOneWidget);
}

Future<void> submitHash(WidgetTester tester, String hash) async {
  await tester.enterText(find.byType(TextField), hash);
  await tester.tap(find.widgetWithText(FilledButton, '提交验证'));
  await tester.pump();
  await tester.pump();
}

List<String> captureClipboardWrites() {
  final values = <String>[];
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'Clipboard.setData') {
      final args = call.arguments as Map<Object?, Object?>;
      values.add(args['text']! as String);
    }
    return null;
  });
  addTearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );
  return values;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('partial 主金额与复制内容都使用 remaining_cents', (tester) async {
    final copied = captureClipboardWrites();
    await _pumpInvoice(
      tester,
      initialOrder: order(
        status: 'partially_paid',
        receivedCents: 400,
        remainingCents: 207,
        paymentCount: 1,
      ),
      claimSteps: const [],
    );

    expect(find.text('2.07'), findsOneWidget);
    expect(find.text('6.07'), findsNothing);

    await tester.tap(find.byTooltip('复制金额'));
    await tester.pump();

    expect(copied, ['2.07']);
  });

  testWidgets('非 partial 主金额与复制内容仍使用 final_amount', (tester) async {
    final copied = captureClipboardWrites();
    await _pumpInvoice(tester, initialOrder: order(), claimSteps: const []);

    expect(find.text('6.07'), findsOneWidget);

    await tester.tap(find.byTooltip('复制金额'));
    await tester.pump();

    expect(copied, ['6.07']);
  });

  testWidgets('partial 不进入终态，刷新累计事实后仍可继续提交 TXID', (tester) async {
    final partialOrder = order(
      status: 'partially_paid',
      receivedCents: 400,
      remainingCents: 207,
      paymentCount: 1,
    );
    final api = await _pumpInvoice(
      tester,
      initialOrder: order(),
      claimSteps: [
        _ClaimStep(
          claimResult(
            resolution: 'partially_paid',
            receivedCents: 400,
            remainingCents: 207,
            paymentCount: 1,
            orderStatus: 'partially_paid',
          ),
          nextOrder: partialOrder,
        ),
        _ClaimStep(
          claimResult(
            resolution: 'partially_paid',
            receivedCents: 500,
            remainingCents: 107,
            paymentCount: 2,
            orderStatus: 'partially_paid',
          ),
          nextOrder: order(
            status: 'partially_paid',
            receivedCents: 500,
            remainingCents: 107,
            paymentCount: 2,
          ),
        ),
      ],
    );
    await openClaimDialog(tester);

    await submitHash(tester, hashOf('a'));

    expect(find.textContaining(r'$4.00'), findsWidgets);
    expect(find.textContaining(r'$2.07'), findsWidgets);
    expect(find.widgetWithText(FilledButton, '继续提交补款 TXID'), findsOneWidget);
    expect(find.text('付款已确认'), findsNothing);

    await tester.enterText(find.byType(TextField), hashOf('b'));
    await tester.tap(find.widgetWithText(FilledButton, '继续提交补款 TXID'));
    await tester.pump();
    await tester.pump();
    expect(api.claimedHashes, [hashOf('a'), hashOf('b')]);
    expect(api.getOrderCalls, greaterThan(1));
  });

  testWidgets('pending 使用 retry_after_seconds 倒计时且归零后恢复按钮', (tester) async {
    final clock = _MutableClock(DateTime.now());
    await _pumpInvoice(
      tester,
      initialOrder: order(),
      now: clock.now,
      claimSteps: [
        _ClaimStep(
          claimResult(resolution: 'pending_confirmation', retryAfterSeconds: 3),
        ),
      ],
    );
    await openClaimDialog(tester);

    await submitHash(tester, hashOf('c'));

    expect(find.text('交易尚未完成链上确认，请等待确认后重试；无需重复付款。'), findsOneWidget);
    var button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '3 秒后可重试'),
    );
    expect(button.onPressed, isNull);

    clock.advance(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '1 秒后可重试'),
    );
    expect(button.onPressed, isNull);

    clock.advance(const Duration(milliseconds: 999));
    await tester.pump(const Duration(seconds: 1));
    button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '1 秒后可重试'),
    );
    expect(button.onPressed, isNull);

    clock.advance(const Duration(milliseconds: 1));
    await tester.pump(const Duration(seconds: 1));
    button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '提交验证'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('pending deadline 在取消并重开弹窗后继续生效且页面销毁会清理计时器', (tester) async {
    final clock = _MutableClock(DateTime.now());
    await _pumpInvoice(
      tester,
      initialOrder: order(),
      now: clock.now,
      claimSteps: [
        _ClaimStep(
          claimResult(
            resolution: 'pending_confirmation',
            retryAfterSeconds: 10,
          ),
        ),
      ],
    );
    await openClaimDialog(tester);
    await submitHash(tester, hashOf('e'));

    clock.advance(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('7 秒后可重试'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, '取消'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    clock.advance(const Duration(seconds: 6, milliseconds: 999));
    await tester.pump(const Duration(seconds: 1));
    await openClaimDialog(tester);

    expect(find.text('1 秒后可重试'), findsOneWidget);
    final retryButton = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('1 秒后可重试'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(retryButton.onPressed, isNull);

    clock.advance(const Duration(milliseconds: 1));
    await tester.pump(const Duration(seconds: 1));
    final submitButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '提交验证'),
    );
    expect(submitButton.onPressed, isNotNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 10));
    expect(tester.takeException(), isNull);
  });

  testWidgets('拆分付款完成后刷新订单进入成功屏并显示超额余额', (tester) async {
    final api = await _pumpInvoice(
      tester,
      initialOrder: order(),
      claimSteps: [
        _ClaimStep(
          claimResult(
            resolution: 'split_payment_completed',
            matched: true,
            receivedCents: 607,
            paymentCount: 2,
            creditedCents: 50,
            orderStatus: 'finished',
          ),
          nextOrder: order(
            status: 'finished',
            receivedCents: 607,
            paymentCount: 2,
            txid: hashOf('d'),
          ),
        ),
      ],
    );
    await openClaimDialog(tester);

    await submitHash(tester, hashOf('d'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('付款已确认'), findsOneWidget);
    expect(find.textContaining(r'$0.50'), findsOneWidget);
    expect(api.getOrderCalls, greaterThan(1));
  });

  testWidgets('credited_expired 且订单已 finished 进入成功刷新路径而非过期重买', (tester) async {
    final api = await _pumpInvoice(
      tester,
      initialOrder: order(status: 'expired'),
      claimSteps: [
        _ClaimStep(
          claimResult(
            resolution: 'credited_expired',
            creditedCents: 50,
            orderStatus: 'finished',
          ),
          nextOrder: order(status: 'finished', txid: hashOf('f')),
        ),
      ],
    );
    await openExpiredClaimDialog(tester);

    await submitHash(tester, hashOf('f'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('付款已确认'), findsOneWidget);
    expect(find.textContaining(r'$0.50'), findsOneWidget);
    expect(find.textContaining('重新下单'), findsNothing);
    expect(api.getOrderCalls, greaterThan(1));
  });

  testWidgets('付款页支持按钮打开公开群并显示群隐私警示', (tester) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    final launched = <String>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      final args = call.arguments as Map<Object?, Object?>;
      if (call.method == 'canLaunch') return true;
      if (call.method == 'launch') {
        launched.add(args['url']! as String);
        return true;
      }
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

    await _pumpInvoice(tester, initialOrder: order(), claimSteps: const []);

    expect(find.textContaining('公开群隐私提醒'), findsOneWidget);
    expect(
      find.textContaining('敏感资料可私下发送至 feedback@verstro.com'),
      findsOneWidget,
    );
    final support = find.byIcon(Icons.support_agent);
    await tester.ensureVisible(support);
    await tester.pump();
    await tester.tap(support);
    await tester.pump();
    await tester.pump();

    expect(launched, ['https://t.me/verstro_chat']);

    final feedback = find.text('feedback@verstro.com');
    await tester.ensureVisible(feedback);
    await tester.pump();
    await tester.tap(feedback);
    await tester.pump();
    await tester.pump();

    expect(launched, [
      'https://t.me/verstro_chat',
      'mailto:feedback@verstro.com',
    ]);
  });
}
