import 'package:fl_clash/common/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../api/api_exceptions.dart';
import '../../api/membership_card_models.dart';
import '../../providers/backend_api_provider.dart';
import '../../providers/membership_card_provider.dart';

class MembershipCardOrderPage extends ConsumerWidget {
  const MembershipCardOrderPage({super.key, required this.order});

  final MembershipCardOrder order;

  Future<void> _copy(BuildContext context, String value, String message) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _claim(
    BuildContext context,
    WidgetRef ref,
    MembershipCardOrder current,
  ) async {
    final controller = TextEditingController();
    String? error;
    var busy = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(appLocalizations.vCardClaimTitle),
          content: TextField(
            controller: controller,
            enabled: !busy,
            autofocus: true,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: appLocalizations.vCardTxHash,
              errorText: error,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: busy ? null : () => Navigator.pop(dialogContext),
              child: Text(appLocalizations.cancel),
            ),
            FilledButton(
              onPressed: busy
                  ? null
                  : () async {
                      final hash = controller.text.trim().toLowerCase();
                      if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(hash)) {
                        setState(
                          () => error = appLocalizations.vErrInvalidTxHash,
                        );
                        return;
                      }
                      setState(() {
                        busy = true;
                        error = null;
                      });
                      try {
                        final api = await ref.read(backendApiProvider.future);
                        await api.claimMembershipCardTx(current.id, hash);
                        ref.invalidate(
                          membershipCardOrderStreamProvider(current.id),
                        );
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      } on BackendException catch (exception) {
                        setState(() {
                          busy = false;
                          error = exception.message;
                        });
                      }
                    },
              child: busy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(appLocalizations.vCardClaimSubmit),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOrder = ref.watch(membershipCardOrderStreamProvider(order.id));
    final current = asyncOrder.value ?? order;
    if (current.isIssued) {
      return Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.vCardOrderTitle(current.id)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.card_giftcard,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  appLocalizations.vCardIssuedTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizations.vCardIssuedDescription(current.cardCount),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(membershipCardInventoryProvider);
                    ref.invalidate(membershipCardOrdersProvider);
                    Navigator.pop(context);
                  },
                  child: Text(appLocalizations.vCardViewInventory),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.vCardOrderTitle(current.id))),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          appLocalizations.vCardOrderState(
                            _status(current.paymentState),
                            _status(current.issuanceState),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _money(current.finalAmountCents),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'USDT-TRC20',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        if (current.depositAddress.isNotEmpty) ...<Widget>[
                          Center(
                            child: QrImageView(
                              data: current.depositAddress,
                              size: 180,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SelectableText(
                            current.depositAddress,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              OutlinedButton.icon(
                                onPressed: () => _copy(
                                  context,
                                  (current.finalAmountCents / 100)
                                      .toStringAsFixed(2),
                                  appLocalizations.vPayAmountCopied,
                                ),
                                icon: const Icon(Icons.copy),
                                label: Text(appLocalizations.vCardCopyAmount),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _copy(
                                  context,
                                  current.depositAddress,
                                  appLocalizations.vPayAddressCopied,
                                ),
                                icon: const Icon(Icons.copy),
                                label: Text(appLocalizations.vCardCopyAddress),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(appLocalizations.vCardPaymentWarning),
                  ),
                ),
                const SizedBox(height: 12),
                if (current.paymentState == 'waiting')
                  FilledButton.icon(
                    onPressed: () => _claim(context, ref, current),
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(appLocalizations.vCardClaimTitle),
                  ),
                if (current.paymentState == 'paid')
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 10),
                        Text(appLocalizations.vCardIssuing),
                      ],
                    ),
                  ),
                if (current.paymentState == 'expired')
                  Text(
                    appLocalizations.vCardOrderExpired,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (asyncOrder.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      appLocalizations.vCardOrderPollFailed,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

String _status(String state) => switch (state) {
  'waiting' => appLocalizations.vCardStatusWaiting,
  'paid' => appLocalizations.vCardStatusPaid,
  'expired' => appLocalizations.vCardStatusExpired,
  'not_started' => appLocalizations.vCardStatusNotStarted,
  'processing' => appLocalizations.vCardStatusProcessing,
  'succeeded' => appLocalizations.vCardStatusSucceeded,
  'failed' => appLocalizations.vCardStatusFailed,
  _ => state,
};
