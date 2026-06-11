import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/verstro/pages/about_page.dart';
import 'package:fl_clash/verstro/providers/auth_provider.dart';
import 'package:fl_clash/views/access.dart';
import 'package:fl_clash/views/application_setting.dart';
import 'package:fl_clash/views/hotkey.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show dirname, join;

import 'theme.dart';

// 私有化托管服务的「设置」页 (取代原「工具」tab)。单一扁平列表 (无"设置/其他"
// 分节、无诊断「更多」区), 底部为红色「退出登录」危险行。从账号页右上角齿轮进入。
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const _LocaleItem(),
      const _ThemeItem(),
      if (system.isDesktop) const _HotkeyItem(),
      if (system.isWindows) const _LoopbackItem(),
      if (system.isAndroid) const _AccessItem(),
      const _SettingItem(),
      const _InfoItem(),
      const _LogoutItem(),
    ];
    return BaseScaffold(
      title: context.appLocalizations.settings,
      body: ListView.separated(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: items.length,
        itemBuilder: (_, index) => items[index],
        separatorBuilder: (_, _) => const Divider(height: 0),
      ),
    );
  }
}

class _LocaleItem extends ConsumerWidget {
  const _LocaleItem();

  String _getLocaleString(Locale? locale) {
    if (locale == null) return appLocalizations.defaultText;
    return Intl.message(locale.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(
      appSettingProvider.select((state) => state.locale),
    );
    final subTitle = locale ?? context.appLocalizations.defaultText;
    final currentLocale = utils.getLocaleForString(locale);
    return ListItem<Locale?>.options(
      leading: const Icon(Icons.language_outlined),
      title: Text(context.appLocalizations.language),
      subtitle: Text(Intl.message(subTitle)),
      delegate: OptionsDelegate(
        title: context.appLocalizations.language,
        options: [null, ...AppLocalizations.delegate.supportedLocales],
        onChanged: (Locale? locale) {
          ref
              .read(appSettingProvider.notifier)
              .update((state) => state.copyWith(locale: locale?.toString()));
        },
        textBuilder: (locale) => _getLocaleString(locale),
        value: currentLocale,
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.style),
      title: Text(context.appLocalizations.theme),
      subtitle: Text(context.appLocalizations.themeDesc),
      delegate: OpenDelegate(widget: const ThemeView()),
    );
  }
}

class _HotkeyItem extends StatelessWidget {
  const _HotkeyItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.keyboard),
      title: Text(context.appLocalizations.hotkeyManagement),
      subtitle: Text(context.appLocalizations.hotkeyManagementDesc),
      delegate: OpenDelegate(widget: const HotKeyView()),
    );
  }
}

class _LoopbackItem extends StatelessWidget {
  const _LoopbackItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.lock),
      title: Text(context.appLocalizations.loopback),
      subtitle: Text(context.appLocalizations.loopbackDesc),
      onTap: () {
        windows?.runas(
          '"${join(dirname(Platform.resolvedExecutable), "EnableLoopback.exe")}"',
          '',
        );
      },
    );
  }
}

class _AccessItem extends StatelessWidget {
  const _AccessItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.view_list),
      title: Text(context.appLocalizations.accessControl),
      subtitle: Text(context.appLocalizations.accessControlDesc),
      delegate: OpenDelegate(widget: const AccessView()),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.settings),
      title: Text(context.appLocalizations.application),
      subtitle: Text(context.appLocalizations.applicationDesc),
      delegate: OpenDelegate(widget: const ApplicationSettingView()),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.info),
      title: Text(context.appLocalizations.about),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const VerstroAboutPage()),
      ),
    );
  }
}

// 退出登录: 危险操作, 红色 + 二次确认, 防误触。登出后 VerstroGate 状态联动跳登录页。
class _LogoutItem extends ConsumerWidget {
  const _LogoutItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = context.colorScheme.error;
    return ListItem(
      leading: Icon(Icons.logout, color: error),
      title: Text('退出登录', style: TextStyle(color: error)),
      onTap: () async {
        final confirm = await globalState.showMessage(
          title: '退出登录',
          message: const TextSpan(text: '确定要退出当前账号吗？'),
        );
        if (confirm == true) {
          await ref.read(authNotifierProvider.notifier).logout();
        }
      },
    );
  }
}
