import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/help/help_content.dart';
import 'package:fl_clash/verstro/help/onboarding/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<VerstroOnboardingResult?> showVerstroOnboarding(
  BuildContext context, {
  required VerstroHelpAudience audience,
}) async {
  final result = await showDialog<VerstroOnboardingResult>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _VerstroOnboardingDialog(audience: audience),
  );

  // 模态框不可点击遮罩关闭，因此空结果只会来自系统返回键；返回键等同跳过。
  return result ?? VerstroOnboardingResult.skipped;
}

class _AdvanceOnboardingIntent extends Intent {
  const _AdvanceOnboardingIntent();
}

class _BackOnboardingIntent extends Intent {
  const _BackOnboardingIntent();
}

class _SkipOnboardingIntent extends Intent {
  const _SkipOnboardingIntent();
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;
}

class _VerstroOnboardingDialog extends StatefulWidget {
  const _VerstroOnboardingDialog({required this.audience});

  final VerstroHelpAudience audience;

  @override
  State<_VerstroOnboardingDialog> createState() =>
      _VerstroOnboardingDialogState();
}

class _VerstroOnboardingDialogState extends State<_VerstroOnboardingDialog> {
  static const _stepCount = 5;
  final _pageController = PageController();
  var _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_OnboardingStep> _buildSteps(AppLocalizations l10n) {
    final isDesktop = widget.audience == VerstroHelpAudience.desktop;
    final connectionBody = isDesktop
        ? l10n.vOnboardingConnectDesktopBody
        : l10n.vOnboardingConnectMobileBody;
    final platformSteps = isDesktop
        ? <_OnboardingStep>[
            _OnboardingStep(
              title: l10n.vHelpSystemProxyTitle,
              body: l10n.vHelpSystemProxyBody,
              icon: Icons.language_outlined,
            ),
            _OnboardingStep(
              title: l10n.vHelpTunTitle,
              body: l10n.vHelpTunBody,
              icon: Icons.lan_outlined,
            ),
          ]
        : <_OnboardingStep>[
            _OnboardingStep(
              title: l10n.vHelpMobileVpnTitle,
              body: l10n.vHelpMobileVpnBody,
              icon: Icons.vpn_lock_outlined,
            ),
            _OnboardingStep(
              title: l10n.vHelpNodesTitle,
              body: l10n.vHelpNodesBody,
              icon: Icons.route_outlined,
            ),
          ];

    return [
      _OnboardingStep(
        title: l10n.vOnboardingConnectTitle,
        body: '$connectionBody\n\n${l10n.vHelpQuickBody}',
        icon: Icons.power_settings_new,
      ),
      _OnboardingStep(
        title: l10n.vHelpOutboundTitle,
        body:
            '${l10n.vOnboardingOutboundBody}\n\n'
            '${l10n.vHelpOutboundIntro}\n\n'
            '${l10n.vHelpSmartTitle}: ${l10n.vHelpSmartBody}\n\n'
            '${l10n.vHelpGlobalTitle}: ${l10n.vHelpGlobalBody}',
        icon: Icons.alt_route_outlined,
      ),
      ...platformSteps,
      _OnboardingStep(
        title: l10n.vOnboardingHelpTitle,
        body:
            '${l10n.vOnboardingHelpBody}\n\n'
            '${l10n.vHelpContactBody}',
        icon: Icons.help_outline,
      ),
    ];
  }

  void _goTo(int page) {
    if (page < 0 || page >= _stepCount || page == _page) return;
    setState(() => _page = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
    );
  }

  void _advance() {
    if (_page == _stepCount - 1) {
      _close(VerstroOnboardingResult.completed);
      return;
    }
    _goTo(_page + 1);
  }

  void _close(VerstroOnboardingResult result) {
    Navigator.of(context).pop(result);
  }

  List<Widget> _buildActions(AppLocalizations l10n) {
    if (_page == _stepCount - 1) {
      return [
        TextButton(
          onPressed: () => _goTo(_page - 1),
          child: Text(l10n.vOnboardingBack),
        ),
        TextButton(
          onPressed: () => _close(VerstroOnboardingResult.openHelp),
          child: Text(l10n.vOnboardingOpenHelp),
        ),
        FilledButton(
          onPressed: () => _close(VerstroOnboardingResult.completed),
          child: Text(l10n.vOnboardingFinish),
        ),
      ];
    }

    return [
      TextButton(
        onPressed: () => _close(VerstroOnboardingResult.skipped),
        child: Text(l10n.vOnboardingSkip),
      ),
      if (_page > 0)
        TextButton(
          onPressed: () => _goTo(_page - 1),
          child: Text(l10n.vOnboardingBack),
        ),
      FilledButton(onPressed: _advance, child: Text(l10n.vOnboardingNext)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = _buildSteps(l10n);

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowRight):
            _AdvanceOnboardingIntent(),
        SingleActivator(LogicalKeyboardKey.enter): _AdvanceOnboardingIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft): _BackOnboardingIntent(),
        SingleActivator(LogicalKeyboardKey.escape): _SkipOnboardingIntent(),
      },
      child: Actions(
        actions: {
          _AdvanceOnboardingIntent: CallbackAction<_AdvanceOnboardingIntent>(
            onInvoke: (_) {
              _advance();
              return null;
            },
          ),
          _BackOnboardingIntent: CallbackAction<_BackOnboardingIntent>(
            onInvoke: (_) {
              _goTo(_page - 1);
              return null;
            },
          ),
          _SkipOnboardingIntent: CallbackAction<_SkipOnboardingIntent>(
            onInvoke: (_) {
              _close(VerstroOnboardingResult.skipped);
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: PopScope(
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 520,
                  maxHeight: 620,
                ),
                child: SizedBox(
                  width: 520,
                  height: 560,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: steps.length,
                            itemBuilder: (context, index) {
                              final step = steps[index];
                              return Semantics(
                                container: true,
                                namesRoute: true,
                                label:
                                    '${index + 1} / $_stepCount · ${step.title}',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      step.icon,
                                      size: 34,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      step.title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall,
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(step.body),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Semantics(
                          liveRegion: true,
                          label: '${_page + 1} / $_stepCount',
                          child: ExcludeSemantics(
                            child: Text(
                              '${_page + 1} / $_stepCount',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OverflowBar(
                          alignment: MainAxisAlignment.end,
                          spacing: 8,
                          overflowSpacing: 8,
                          children: _buildActions(l10n),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
