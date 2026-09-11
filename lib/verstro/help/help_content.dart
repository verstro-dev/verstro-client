import 'package:fl_clash/l10n/l10n.dart';
import 'package:flutter/foundation.dart';

enum VerstroHelpAudience { desktop, mobile }

@immutable
class VerstroHelpSection {
  const VerstroHelpSection({
    required this.id,
    required this.title,
    required this.body,
  });

  final String id;
  final String title;
  final String body;
}

@immutable
class VerstroHelpFaq {
  const VerstroHelpFaq({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;
}

@immutable
class VerstroHelpContent {
  const VerstroHelpContent({
    required this.title,
    required this.intro,
    required this.sections,
    required this.faqTitle,
    required this.faqs,
    required this.recommendedConfiguration,
  });

  final String title;
  final String intro;
  final List<VerstroHelpSection> sections;
  final String faqTitle;
  final List<VerstroHelpFaq> faqs;
  final String recommendedConfiguration;
}

VerstroHelpContent buildVerstroHelpContent(
  AppLocalizations l10n,
  VerstroHelpAudience audience,
) {
  final platformSections = audience == VerstroHelpAudience.desktop
      ? <VerstroHelpSection>[
          VerstroHelpSection(
            id: 'system-proxy',
            title: l10n.vHelpSystemProxyTitle,
            body: l10n.vHelpSystemProxyBody,
          ),
          VerstroHelpSection(
            id: 'tun',
            title: l10n.vHelpTunTitle,
            body: l10n.vHelpTunBody,
          ),
          VerstroHelpSection(
            id: 'desktop-combinations',
            title: l10n.vHelpCoverageTitle,
            body: l10n.vHelpDesktopCombinations,
          ),
        ]
      : <VerstroHelpSection>[
          VerstroHelpSection(
            id: 'mobile-vpn',
            title: l10n.vHelpMobileVpnTitle,
            body: l10n.vHelpMobileVpnBody,
          ),
        ];

  return VerstroHelpContent(
    title: l10n.vHelpTitle,
    intro: l10n.vHelpIntro,
    sections: List<VerstroHelpSection>.unmodifiable([
      VerstroHelpSection(
        id: 'quick-start',
        title: l10n.vHelpQuickTitle,
        body: l10n.vHelpQuickBody,
      ),
      VerstroHelpSection(
        id: 'outbound',
        title: l10n.vHelpOutboundTitle,
        body:
            '${l10n.vHelpOutboundIntro}\n\n'
            '${l10n.vHelpSmartTitle}: ${l10n.vHelpSmartBody}\n\n'
            '${l10n.vHelpGlobalTitle}: ${l10n.vHelpGlobalBody}',
      ),
      ...platformSections,
      VerstroHelpSection(
        id: 'nodes',
        title: l10n.vHelpNodesTitle,
        body: l10n.vHelpNodesBody,
      ),
      VerstroHelpSection(
        id: 'account',
        title: l10n.vHelpAccountTitle,
        body: l10n.vHelpAccountBody,
      ),
      VerstroHelpSection(
        id: 'payment',
        title: l10n.vHelpPaymentTitle,
        body: l10n.vHelpPaymentBody,
      ),
      VerstroHelpSection(
        id: 'update',
        title: l10n.vHelpUpdateTitle,
        body: l10n.vHelpUpdateBody,
      ),
    ]),
    faqTitle: l10n.vHelpFaqTitle,
    faqs: List<VerstroHelpFaq>.unmodifiable([
      VerstroHelpFaq(
        id: 'mode-difference',
        question: l10n.vHelpFaqModeDifferenceQ,
        answer: l10n.vHelpFaqModeDifferenceA,
      ),
      VerstroHelpFaq(
        id: 'global-coverage',
        question: l10n.vHelpFaqGlobalCoverageQ,
        answer: l10n.vHelpFaqGlobalCoverageA,
      ),
      VerstroHelpFaq(
        id: 'proxy-and-tun',
        question: l10n.vHelpFaqProxyAndTunQ,
        answer: l10n.vHelpFaqProxyAndTunA,
      ),
      VerstroHelpFaq(
        id: 'connected-no-effect',
        question: l10n.vHelpFaqConnectedNoEffectQ,
        answer: l10n.vHelpFaqConnectedNoEffectA,
      ),
      VerstroHelpFaq(
        id: 'tun-permission',
        question: l10n.vHelpFaqTunPermissionQ,
        answer: l10n.vHelpFaqTunPermissionA,
      ),
      VerstroHelpFaq(
        id: 'disable-tun',
        question: l10n.vHelpFaqDisableTunQ,
        answer: l10n.vHelpFaqDisableTunA,
      ),
      VerstroHelpFaq(
        id: 'restore-recommended',
        question: l10n.vHelpFaqRestoreRecommendedQ,
        answer: l10n.vHelpFaqRestoreRecommendedA,
      ),
      VerstroHelpFaq(
        id: 'mobile-toggles',
        question: l10n.vHelpFaqMobileTogglesQ,
        answer: l10n.vHelpFaqMobileTogglesA,
      ),
    ]),
    recommendedConfiguration: audience == VerstroHelpAudience.desktop
        ? l10n.vHelpDesktopRecommended
        : l10n.vHelpMobileVpnBody,
  );
}
