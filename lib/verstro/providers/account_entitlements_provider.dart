import '../api/api_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/account_entitlement_models.dart';
import 'auth_provider.dart';
import 'backend_api_provider.dart';

final accountEntitlementsProvider =
    AsyncNotifierProvider<AccountEntitlementsNotifier, AccountEntitlements?>(
      AccountEntitlementsNotifier.new,
      retry: (_, _) => null,
    );

class AccountEntitlementsNotifier extends AsyncNotifier<AccountEntitlements?> {
  @override
  Future<AccountEntitlements?> build() async {
    final auth = ref.watch(authNotifierProvider);
    if (auth.isLoading || auth.hasError || auth.value?.isLoggedIn != true) {
      return null;
    }
    final api = await ref.read(backendApiProvider.future);
    return api.getAccountEntitlements();
  }

  Future<void> loadMore() async {
    final snapshot = state.value;
    if (snapshot == null ||
        snapshot.loadingMore ||
        snapshot.historyChanged ||
        snapshot.nextHistoryCursor == null) {
      return;
    }
    final loading = snapshot.withHistory(loadingMore: true);
    state = AsyncData(loading);
    try {
      final api = await ref.read(backendApiProvider.future);
      final page = await api.getAccountEntitlements(
        historyCursor: snapshot.nextHistoryCursor,
      );
      if (ref.mounted && identical(state.value, loading)) {
        state = AsyncData(snapshot.append(page));
      }
    } catch (error) {
      if (ref.mounted && identical(state.value, loading)) {
        state = AsyncData(
          snapshot.withHistory(
            historyError: true,
            historyChanged:
                error is EntitlementHistoryChanged ||
                error is BackendException &&
                    error.code == 'entitlement_history_changed',
          ),
        );
      }
    }
  }
}
