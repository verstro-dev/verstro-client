// 会员卡 Riverpod 状态与完整码内存保管。
//
// 完整激活码不进入 provider state、任何本地持久化、日志或崩溃上报；
// 它只存在私有 vault，App 进入后台、离开页面或 provider dispose 时清空。

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/membership_card_models.dart';
import 'auth_provider.dart';
import 'backend_api_provider.dart';

class MembershipCardSecretVault {
  final Map<String, String> _values = <String, String>{};

  void set(String cardId, String code) {
    if (cardId.isNotEmpty && code.isNotEmpty) _values[cardId] = code;
  }

  String? read(String cardId) => _values[cardId];
  bool canShare(String cardId) => _values.containsKey(cardId);
  void clear() => _values.clear();

  void handleLifecycle(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) clear();
  }

  Map<String, dynamic> toJson() => const <String, dynamic>{};
}

class MembershipCardState {
  const MembershipCardState({
    this.quote,
    this.order,
    this.redemptionPreview,
    this.busy = false,
    this.secretRevision = 0,
    this.error,
  });

  final MembershipCardQuote? quote;
  final MembershipCardOrder? order;
  final MembershipCardRedemptionPreview? redemptionPreview;
  final bool busy;
  final int secretRevision;
  final Object? error;

  MembershipCardState copyWith({
    Object? quote = _notSet,
    Object? order = _notSet,
    Object? redemptionPreview = _notSet,
    bool? busy,
    int? secretRevision,
    Object? error = _notSet,
  }) => MembershipCardState(
    quote: identical(quote, _notSet)
        ? this.quote
        : quote as MembershipCardQuote?,
    order: identical(order, _notSet)
        ? this.order
        : order as MembershipCardOrder?,
    redemptionPreview: identical(redemptionPreview, _notSet)
        ? this.redemptionPreview
        : redemptionPreview as MembershipCardRedemptionPreview?,
    busy: busy ?? this.busy,
    secretRevision: secretRevision ?? this.secretRevision,
    error: identical(error, _notSet) ? this.error : error,
  );
}

const Object _notSet = Object();

final membershipCardOrdersProvider = FutureProvider<List<MembershipCardOrder>>((
  ref,
) async {
  final auth = ref.watch(authNotifierProvider).value;
  if (auth == null || !auth.isLoggedIn) return <MembershipCardOrder>[];
  final api = await ref.read(backendApiProvider.future);
  return api.listMembershipCardOrders();
});

final membershipCardInventoryProvider =
    FutureProvider<List<MembershipCardInventoryItem>>((ref) async {
      final auth = ref.watch(authNotifierProvider).value;
      if (auth == null || !auth.isLoggedIn) {
        return <MembershipCardInventoryItem>[];
      }
      final api = await ref.read(backendApiProvider.future);
      return api.listMembershipCards();
    });

final membershipEntitlementTimelineProvider =
    FutureProvider<MembershipEntitlementTimeline>((ref) async {
      final auth = ref.watch(authNotifierProvider).value;
      if (auth == null || !auth.isLoggedIn) {
        return const MembershipEntitlementTimeline(current: [], pending: []);
      }
      final api = await ref.read(backendApiProvider.future);
      return api.getMembershipEntitlementTimeline();
    });

final membershipCardOrderStreamProvider = StreamProvider.autoDispose
    .family<MembershipCardOrder, int>((ref, orderId) async* {
      final api = await ref.read(backendApiProvider.future);
      while (true) {
        try {
          final order = await api.getMembershipCardOrder(orderId);
          yield order;
          if (order.isTerminal) return;
        } catch (_) {
          // 暂时网络失败不丢失付款页，下一轮继续拉取。
        }
        await Future<void>.delayed(const Duration(seconds: 5));
      }
    });

final membershipCardControllerProvider =
    NotifierProvider.autoDispose<MembershipCardController, MembershipCardState>(
      MembershipCardController.new,
    );

class MembershipCardController extends Notifier<MembershipCardState>
    with WidgetsBindingObserver {
  final MembershipCardSecretVault _secrets = MembershipCardSecretVault();

  @override
  MembershipCardState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _secrets.clear();
    });
    return const MembershipCardState();
  }

  String? revealedCode(String cardId) => _secrets.read(cardId);
  bool canShare(String cardId) => _secrets.canShare(cardId);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final hadSecrets = this.state.secretRevision;
    _secrets.handleLifecycle(state);
    if (state != AppLifecycleState.resumed) {
      this.state = this.state.copyWith(secretRevision: hadSecrets + 1);
    }
  }

  void clearSecrets() {
    _secrets.clear();
    state = state.copyWith(secretRevision: state.secretRevision + 1);
  }

  Future<MembershipCardQuote?> quote(
    List<MembershipCardCartItem> items, {
    required bool useCashBackedCredit,
  }) async {
    state = state.copyWith(busy: true, error: null, quote: null);
    try {
      final api = await ref.read(backendApiProvider.future);
      final quote = await api.quoteMembershipCards(
        items,
        useCashBackedCredit: useCashBackedCredit,
      );
      state = state.copyWith(busy: false, quote: quote);
      return quote;
    } catch (error) {
      state = state.copyWith(busy: false, error: error);
      return null;
    }
  }

  Future<MembershipCardOrder?> createOrder(
    List<MembershipCardCartItem> items, {
    required bool useCashBackedCredit,
  }) async {
    final quote = state.quote;
    if (quote == null) return null;
    state = state.copyWith(busy: true, error: null);
    try {
      final api = await ref.read(backendApiProvider.future);
      final result = await api.createMembershipCardOrder(
        items,
        useCashBackedCredit: useCashBackedCredit,
        expectedQuoteHash: quote.quoteHash,
        idempotencyKey: _newIdempotencyKey('card-order'),
      );
      state = state.copyWith(busy: false, order: result.order, quote: null);
      return result.order;
    } catch (error) {
      state = state.copyWith(busy: false, error: error);
      return null;
    }
  }

  Future<String?> revealCard({
    required String cardId,
    required String grantToken,
  }) async {
    state = state.copyWith(busy: true, error: null);
    try {
      final api = await ref.read(backendApiProvider.future);
      final result = await api.revealMembershipCard(cardId, grantToken);
      _secrets.set(cardId, result.code);
      state = state.copyWith(
        busy: false,
        secretRevision: state.secretRevision + 1,
      );
      return result.code;
    } catch (error) {
      state = state.copyWith(busy: false, error: error);
      return null;
    }
  }

  Future<MembershipCardRedemptionPreview?> previewRedemption(
    String code,
  ) async {
    state = state.copyWith(busy: true, error: null, redemptionPreview: null);
    try {
      final api = await ref.read(backendApiProvider.future);
      final preview = await api.previewMembershipCardRedemption(code);
      state = state.copyWith(busy: false, redemptionPreview: preview);
      return preview;
    } catch (error) {
      state = state.copyWith(busy: false, error: error);
      return null;
    }
  }

  Future<MembershipCardRedemptionResult?> confirmRedemption() async {
    final preview = state.redemptionPreview;
    if (preview == null) return null;
    state = state.copyWith(busy: true, error: null);
    try {
      final api = await ref.read(backendApiProvider.future);
      final result = await api.confirmMembershipCardRedemption(
        preview.previewToken,
        idempotencyKey: _newIdempotencyKey('card-redeem'),
      );
      state = state.copyWith(busy: false, redemptionPreview: null);
      ref.invalidate(membershipEntitlementTimelineProvider);
      ref.invalidate(membershipCardInventoryProvider);
      return result;
    } catch (error) {
      state = state.copyWith(busy: false, error: error);
      return null;
    }
  }
}

String _newIdempotencyKey(String prefix) {
  final random = Random.secure();
  final value = List<int>.generate(
    20,
    (_) => random.nextInt(256),
  ).map((value) => value.toRadixString(16).padLeft(2, '0')).join();
  return '$prefix-$value';
}
