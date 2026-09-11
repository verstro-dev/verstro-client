import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('仪表盘和设置页都打开同一个原生帮助中心', () {
    final dashboard = File(
      'lib/views/dashboard/dashboard.dart',
    ).readAsStringSync();
    final settings = File('lib/views/settings.dart').readAsStringSync();
    expect(dashboard, contains('openVerstroHelpCenter(context)'));
    expect(dashboard, contains('Icons.help_outline'));
    expect(settings, contains('openVerstroHelpCenter(context)'));
    expect(settings, contains('Icons.help_outline'));
  });

  test('Application 在托管订阅同步后才启动新手引导', () {
    final source = File('lib/application.dart').readAsStringSync();
    final integrate = source.indexOf('await _verstroAutoIntegrate();');
    final launch = source.indexOf(
      'await maybeLaunchVerstroOnboarding(updateCtx, ref);',
    );
    final update = source.indexOf(
      'unawaited(runUpdateCheck(updateCtx, isUser: false));',
    );
    expect(integrate, greaterThanOrEqualTo(0));
    expect(launch, greaterThan(integrate));
    expect(update, greaterThan(launch));
  });

  test('所有 App 可操作 Telegram 支持入口都使用 verstro_chat', () {
    final sources = [
      File('lib/verstro/pages/usdt_invoice_page.dart').readAsStringSync(),
      File('lib/verstro/help/help_center_page.dart').readAsStringSync(),
      File('lib/verstro/pages/about_page.dart').readAsStringSync(),
    ].join('\n');

    expect(sources, isNot(contains('https://t.me/VerstroSupportBot')));
    expect(RegExp(r'https://t\.me/verstro_chat').allMatches(sources).length, 3);
  });

  test('关于页联系区把公开群和私下邮箱警示分别放在对应可操作入口之后', () {
    final source = File('lib/verstro/pages/about_page.dart').readAsStringSync();
    final contactStart = source.indexOf(
      'title: appLocalizations.vAboutContactSection',
    );
    final contactEnd = source.indexOf(
      'title: appLocalizations.vAboutWebsiteSection',
      contactStart + 1,
    );
    expect(contactStart, greaterThanOrEqualTo(0));
    expect(contactEnd, greaterThan(contactStart));

    final contact = source.substring(contactStart, contactEnd);
    final group = contact.indexOf("_open('https://t.me/verstro_chat')");
    final groupWarning = contact.indexOf('vSupportPublicGroupPrivacy');
    final email = contact.indexOf("_open('mailto:feedback@verstro.com')");
    final emailWarning = contact.indexOf('vSupportFeedbackPrivacy');

    expect(group, greaterThanOrEqualTo(0));
    expect(groupWarning, greaterThan(group));
    expect(email, greaterThan(groupWarning));
    expect(emailWarning, greaterThan(email));
  });

  test('四语公开群警示覆盖全部禁发项与允许诊断项', () {
    final required = <String, List<String>>{
      'zh_CN': [
        '邮箱',
        '订单号',
        'TXID',
        '钱包截图',
        '卡码',
        '订阅链接',
        '密码',
        '验证码',
        '私钥',
        '助记词',
        '平台',
        '版本',
        '错误文字',
        '发生时间',
      ],
      'en': [
        'email',
        'order number',
        'TXID',
        'wallet screenshot',
        'card code',
        'subscription link',
        'password',
        'verification code',
        'private key',
        'recovery phrase',
        'platform',
        'version',
        'error text',
        'when it happened',
      ],
      'ja': [
        'メールアドレス',
        '注文番号',
        'TXID',
        'ウォレットのスクリーンショット',
        'カードコード',
        '購読リンク',
        'パスワード',
        '認証コード',
        '秘密鍵',
        'リカバリーフレーズ',
        'プラットフォーム',
        'バージョン',
        'エラー文',
        '発生時刻',
      ],
      'ru': [
        'адрес электронной почты',
        'номер заказа',
        'TXID',
        'снимки кошелька',
        'коды карт',
        'ссылки подписки',
        'пароли',
        'коды подтверждения',
        'приватные ключи',
        'сид-фразы',
        'платформу',
        'версию',
        'текст ошибки',
        'время возникновения',
      ],
    };

    for (final entry in required.entries) {
      final source = File('arb/intl_${entry.key}.arb').readAsStringSync();
      final arb = jsonDecode(source) as Map<String, dynamic>;
      final warning = arb['vSupportPublicGroupPrivacy'] as String?;
      expect(warning, isNotNull, reason: entry.key);
      if (warning == null) continue;
      for (final token in entry.value) {
        expect(warning, contains(token), reason: '${entry.key}: $token');
      }
      expect(source, isNot(contains('VerstroSupportBot')));
    }
  });

  test('四语 feedback 邮箱允许私下敏感信息但禁止核心凭据', () {
    final forbidden = <String, List<String>>{
      'zh_CN': ['密码', '验证码', '私钥', '助记词'],
      'en': ['password', 'verification code', 'private key', 'recovery phrase'],
      'ja': ['パスワード', '認証コード', '秘密鍵', 'リカバリーフレーズ'],
      'ru': ['пароли', 'коды подтверждения', 'приватные ключи', 'сид-фразы'],
    };

    for (final entry in forbidden.entries) {
      final arb =
          jsonDecode(File('arb/intl_${entry.key}.arb').readAsStringSync())
              as Map<String, dynamic>;
      final warning = arb['vSupportFeedbackPrivacy'] as String?;
      expect(warning, isNotNull, reason: entry.key);
      if (warning == null) continue;
      expect(warning, contains('feedback@verstro.com'));
      for (final token in entry.value) {
        expect(warning, contains(token), reason: '${entry.key}: $token');
      }
    }
  });
}
