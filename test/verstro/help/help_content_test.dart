import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/verstro/help/help_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _faqIds = <String>[
  'mode-difference',
  'global-coverage',
  'proxy-and-tun',
  'connected-no-effect',
  'tun-permission',
  'disable-tun',
  'restore-recommended',
  'mobile-toggles',
];

void _expectImmutable(VerstroHelpContent content) {
  expect(
    () => content.sections.add(content.sections.first),
    throwsUnsupportedError,
  );
  expect(() => content.faqs.add(content.faqs.first), throwsUnsupportedError);
}

void main() {
  test('桌面帮助使用固定章节和 FAQ 顺序，且列表不可变', () async {
    final l10n = await AppLocalizations.load(const Locale('zh', 'CN'));
    final content = buildVerstroHelpContent(l10n, VerstroHelpAudience.desktop);

    expect(
      content.sections.map((section) => section.id).toList(),
      orderedEquals([
        'quick-start',
        'outbound',
        'system-proxy',
        'tun',
        'desktop-combinations',
        'nodes',
        'account',
        'payment',
        'update',
      ]),
    );
    expect(content.faqs.map((faq) => faq.id).toList(), orderedEquals(_faqIds));
    expect(content.recommendedConfiguration, contains('智能分流'));
    _expectImmutable(content);
  });

  test('移动帮助使用固定章节和 FAQ 顺序，并隔离桌面开关', () async {
    final l10n = await AppLocalizations.load(const Locale('en'));
    final content = buildVerstroHelpContent(l10n, VerstroHelpAudience.mobile);

    expect(
      content.sections.map((section) => section.id).toList(),
      orderedEquals([
        'quick-start',
        'outbound',
        'mobile-vpn',
        'nodes',
        'account',
        'payment',
        'update',
      ]),
    );
    expect(
      content.sections.map((section) => section.id),
      isNot(contains('system-proxy')),
    );
    expect(
      content.sections.map((section) => section.id),
      isNot(contains('tun')),
    );
    expect(
      content.sections.map((section) => section.id),
      isNot(contains('desktop-combinations')),
    );
    expect(content.faqs.map((faq) => faq.id).toList(), orderedEquals(_faqIds));
    _expectImmutable(content);
  });

  test('四种语言分别保留 TUN 冲突降级、完整排查和密码边界', () async {
    final expectations = <Locale, List<List<String>>>{
      const Locale('zh', 'CN'): [
        ['虚拟网卡与其他 VPN、代理或安全软件冲突时，暂时关闭虚拟网卡并保留系统代理'],
        ['系统代理和虚拟网卡开关、当前出站模式、节点和其他 VPN', '断开并重新连接'],
        ['不会取得用户的账户或管理员密码'],
        ['其他 VPN、代理或安全软件冲突', '睡眠恢复异常', '只需要浏览器代理'],
      ],
      const Locale('en'): [
        [
          'Virtual NIC conflicts with another VPN, proxy, or security software, temporarily disable Virtual NIC and keep System proxy enabled',
        ],
        [
          'System proxy and Virtual NIC switches, the current outbound mode, node, and other VPNs',
          'disconnect and reconnect',
        ],
        ['never asks for or receives your account or administrator password'],
        [
          'another VPN, proxy, or security software',
          'sleep or wake recovery is abnormal',
          'only need browser proxying',
        ],
      ],
      const Locale('ja'): [
        [
          '仮想ネットワークアダプターが他の VPN、プロキシ、セキュリティソフトと競合する場合は、一時的にオフにしてシステムプロキシをオンのままにします',
        ],
        ['システムプロキシと仮想ネットワークアダプターのスイッチ、現在の送信モード、ノード、他の VPN', '切断して再接続'],
        ['アカウントのパスワードや管理者パスワードを要求したり取得したりすることはありません'],
        ['他の VPN、プロキシ、セキュリティソフトと競合', 'スリープ復帰が正常でない', 'ブラウザーだけをプロキシしたい'],
      ],
      const Locale('ru'): [
        [
          'Виртуальный сетевой адаптер конфликтует с другим VPN, прокси или защитным ПО, временно выключите Виртуальный сетевой адаптер и оставьте Системный прокси включённым',
        ],
        [
          'переключатели Системного прокси и Виртуального сетевого адаптера, текущий режим выхода, узел и другие VPN',
          'отключитесь и подключитесь заново',
        ],
        [
          'никогда не запрашивает и не получает пароль аккаунта или пароль администратора',
        ],
        [
          'другим VPN, прокси или защитным ПО',
          'некорректно восстанавливается после сна',
          'нужен прокси только для браузера',
        ],
      ],
    };

    for (final entry in expectations.entries) {
      final content = buildVerstroHelpContent(
        await AppLocalizations.load(entry.key),
        VerstroHelpAudience.desktop,
      );
      final answers = <String>[
        content.faqs[2].answer,
        content.faqs[3].answer,
        content.faqs[4].answer,
        content.faqs[5].answer,
      ];

      for (var index = 0; index < answers.length; index++) {
        for (final expected in entry.value[index]) {
          expect(
            answers[index],
            contains(expected),
            reason: '${entry.key}: $expected',
          );
        }
      }
    }
  });

  test('日文和俄文使用各自帮助标题，不回退英文', () async {
    final ja = await AppLocalizations.load(const Locale('ja'));
    expect(
      buildVerstroHelpContent(ja, VerstroHelpAudience.mobile).title,
      'ヘルプセンター',
    );
    final ru = await AppLocalizations.load(const Locale('ru'));
    expect(
      buildVerstroHelpContent(ru, VerstroHelpAudience.mobile).title,
      'Справочный центр',
    );
  });
}
