import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exceptions.dart';
import '../api/api_models.dart';
import 'auth_provider.dart';
import 'backend_api_provider.dart';

class PromotionCatalogState {
  final bool supported;
  final List<PromotionSummaryDto> promotions;

  const PromotionCatalogState({
    required this.supported,
    required this.promotions,
  });
}

class MyPromotionsState {
  final bool supported;
  final MyPromotionsDto? data;

  const MyPromotionsState({required this.supported, this.data});
}

class PromotionQuoteState {
  final bool supported;
  final PromotionQuoteDto? quote;

  const PromotionQuoteState({required this.supported, this.quote});
}

class PromotionQuoteRequest {
  final String planId;
  final int planVersionId;
  final int basePriceCents;
  final String couponCode;

  const PromotionQuoteRequest({
    required this.planId,
    required this.planVersionId,
    required this.basePriceCents,
    this.couponCode = '',
  });

  @override
  bool operator ==(Object other) =>
      other is PromotionQuoteRequest &&
      other.planId == planId &&
      other.planVersionId == planVersionId &&
      other.basePriceCents == basePriceCents &&
      other.couponCode == couponCode;

  @override
  int get hashCode =>
      Object.hash(planId, planVersionId, basePriceCents, couponCode);
}

final activePromotionsProvider = FutureProvider<PromotionCatalogState>((
  ref,
) async {
  final auth = ref.watch(authNotifierProvider).value;
  if (auth == null || !auth.isLoggedIn) {
    return const PromotionCatalogState(supported: true, promotions: []);
  }
  final api = await ref.read(backendApiProvider.future);
  try {
    return PromotionCatalogState(
      supported: true,
      promotions: await api.listActivePromotions(),
    );
  } on NotFoundException {
    return const PromotionCatalogState(supported: false, promotions: []);
  }
});

final myPromotionsProvider = FutureProvider<MyPromotionsState>((ref) async {
  final auth = ref.watch(authNotifierProvider).value;
  if (auth == null || !auth.isLoggedIn) {
    return const MyPromotionsState(supported: true);
  }
  final api = await ref.read(backendApiProvider.future);
  try {
    return MyPromotionsState(
      supported: true,
      data: await api.listMyPromotions(),
    );
  } on NotFoundException {
    return const MyPromotionsState(supported: false);
  }
});

final promotionQuoteProvider = FutureProvider.autoDispose
    .family<PromotionQuoteState, PromotionQuoteRequest>((ref, request) async {
      final auth = ref.watch(authNotifierProvider).value;
      if (auth == null || !auth.isLoggedIn) {
        return const PromotionQuoteState(supported: true);
      }
      final api = await ref.read(backendApiProvider.future);
      final cancelToken = CancelToken();
      ref.onDispose(() => cancelToken.cancel('promotion quote disposed'));
      try {
        final quote = await api.quoteOrder(
          request.planId,
          couponCode: request.couponCode,
          expectedPlanVersionId: request.planVersionId,
          expectedBasePriceCents: request.basePriceCents,
          cancelToken: cancelToken,
        );
        if (quote.isExpired) {
          ref.invalidateSelf();
          return const PromotionQuoteState(supported: true);
        }
        return PromotionQuoteState(supported: true, quote: quote);
      } on NotFoundException {
        return const PromotionQuoteState(supported: false);
      }
    });
