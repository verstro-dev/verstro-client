import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/help/help_content.dart';
import 'package:fl_clash/verstro/help/onboarding/onboarding_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

typedef VerstroExternalLauncher = Future<bool> Function(Uri uri);
typedef VerstroOnboardingReplay = Future<void> Function(BuildContext context);

const _webHelpUri = 'https://verstro.com/help';
const _telegramUri = 'https://t.me/VerstroSupportBot';
const _feedbackMailUri = 'mailto:feedback@verstro.com';

Future<void> openVerstroHelpCenter(BuildContext context) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => const VerstroHelpCenterPage()));

class VerstroHelpCenterPage extends StatelessWidget {
  const VerstroHelpCenterPage({
    super.key,
    this.audienceOverride,
    this.externalLauncher,
    this.onReplayOnboarding,
  });

  final VerstroHelpAudience? audienceOverride;
  final VerstroExternalLauncher? externalLauncher;
  final VerstroOnboardingReplay? onReplayOnboarding;

  Future<void> _openExternal(BuildContext context, String value) async {
    final uri = Uri.parse(value);
    final opened = await (externalLauncher ?? _launchExternal)(uri);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.vAboutCannotOpen(value))),
      );
    }
  }

  Future<bool> _launchExternal(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final audience =
        audienceOverride ??
        (system.isDesktop
            ? VerstroHelpAudience.desktop
            : VerstroHelpAudience.mobile);
    final l10n = AppLocalizations.of(context);
    final content = buildVerstroHelpContent(l10n, audience);

    return Scaffold(
      appBar: AppBar(title: Text(content.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(content.intro),
                      const SizedBox(height: 12),
                      Text(
                        content.recommendedConfiguration,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...content.sections.map(
                (section) => ExpansionTile(
                  title: Text(section.title),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(section.body),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 4),
                child: Text(
                  content.faqTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...content.faqs.map(
                (faq) => ExpansionTile(
                  title: Text(faq.question),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(faq.answer),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              ListTile(
                leading: const Icon(Icons.replay_outlined),
                title: Text(l10n.vHelpReplayTitle),
                subtitle: Text(l10n.vHelpReplaySubtitle),
                onTap: () async {
                  final replay = onReplayOnboarding;
                  if (replay != null) {
                    await replay(context);
                    return;
                  }
                  await showVerstroOnboarding(context, audience: audience);
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: Text(l10n.vHelpWebTitle),
                subtitle: Text(l10n.vHelpWebSubtitle),
                onTap: () => _openExternal(context, _webHelpUri),
              ),
              ListTile(
                leading: const Icon(Icons.send_outlined),
                title: const Text('Telegram'),
                subtitle: const Text('@VerstroSupportBot'),
                onTap: () => _openExternal(context, _telegramUri),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('feedback@verstro.com'),
                onTap: () => _openExternal(context, _feedbackMailUri),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
