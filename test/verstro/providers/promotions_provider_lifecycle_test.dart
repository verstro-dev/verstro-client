import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fl_clash/verstro/api/api_models.dart';
import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/verstro/providers/backend_api_provider.dart';
import 'package:fl_clash/verstro/providers/promotions_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _LoggedInAuthNotifier extends AuthNotifier {
  @override
  Future<AuthState> build() async => AuthState(
    user: UserDto(
      id: 7,
      email: 'buyer@example.com',
      emailVerifiedAt: DateTime.utc(2026, 9, 4),
      createdAt: DateTime.utc(2026, 9, 1),
    ),
  );
}

class _DelayedQuoteApi extends BackendApi {
  _DelayedQuoteApi(TokenStorage token)
    : super(baseUrl: 'https://billing.example.test', token: token, dio: Dio());

  final _quote = Completer<PromotionQuoteDto>();

  @override
  Future<PromotionQuoteDto> quoteOrder(
    String planId, {
    String? couponCode,
    required int expectedPlanVersionId,
    required int expectedBasePriceCents,
    CancelToken? cancelToken,
  }) {
    cancelToken?.whenCancel.then((_) {
      if (!_quote.isCompleted) {
        _quote.completeError(StateError('报价请求在返回前被取消'));
      }
    });
    return _quote.future;
  }

  void completeQuote() {
    if (_quote.isCompleted) return;
    _quote.complete(
      PromotionQuoteDto(
        campaignId: 11,
        revisionId: 12,
        application: 'automatic',
        basePriceCents: 600,
        discountCents: 300,
        priceAfterDiscountCents: 300,
        quoteToken: 'signed-quote-token',
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 5)),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('命令式读取报价时在 Future 完成前不会被 autoDispose 取消', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final api = _DelayedQuoteApi(TokenStorage(prefs));
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(_LoggedInAuthNotifier.new),
        backendApiProvider.overrideWith((ref) async => api),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authNotifierProvider.future);

    final quoteFuture = container.read(
      promotionQuoteProvider(
        const PromotionQuoteRequest(
          planId: 'monthly',
          planVersionId: 21,
          basePriceCents: 600,
        ),
      ).future,
    );

    // autoDispose 会在没有监听者的完整事件循环后清理；页面正是用 read 发起请求。
    await Future<void>.delayed(Duration.zero);
    api.completeQuote();

    final state = await quoteFuture;
    expect(state.quote?.quoteToken, 'signed-quote-token');
  });
}
