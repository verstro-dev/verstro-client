import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/controller.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/proxies/common.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProxyCard extends StatelessWidget {
  final String groupName;
  final Proxy proxy;
  final GroupType groupType;
  final ProxyCardType type;
  final String? testUrl;

  const ProxyCard({
    super.key,
    required this.groupName,
    required this.testUrl,
    required this.proxy,
    required this.groupType,
    required this.type,
  });

  Measure get measure => globalState.measure;

  void _handleTestCurrentDelay() {
    proxyDelayTest(proxy, testUrl);
  }

  Widget _buildDelayText() {
    return SizedBox(
      height: measure.labelSmallHeight,
      child: Consumer(
        builder: (context, ref, _) {
          final delay = ref.watch(
            getDelayProvider(proxyName: proxy.name, testUrl: testUrl),
          );
          return FadeThroughBox(
            alignment: type == ProxyCardType.expand
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: delay == 0 || delay == null
                ? SizedBox(
                    height: measure.labelSmallHeight,
                    width: measure.labelSmallHeight,
                    child: delay == 0
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : IconButton(
                            icon: const Icon(Icons.bolt),
                            iconSize: globalState.measure.labelSmallHeight,
                            padding: EdgeInsets.zero,
                            onPressed: _handleTestCurrentDelay,
                          ),
                  )
                : GestureDetector(
                    onTap: _handleTestCurrentDelay,
                    child: Text(
                      delay > 0 ? '$delay ms' : 'Timeout',
                      style: context.textTheme.labelSmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: utils.getDelayColor(delay),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildProxyNameText(BuildContext context) {
    // 国旗 + 中文国名 (按节点名推断); 国旗由 EmojiText 用 Twemoji 字体渲染。
    final country = proxyCountryPrefix(proxy.name).trim();
    // min: 1 行高度预算, 国名+节点名合并单行 (保持旧紧凑行为, 当前未启用)。
    if (type == ProxyCardType.min) {
      return SizedBox(
        height: measure.bodyMediumHeight,
        child: EmojiText(
          country.isEmpty ? proxy.name : '$country ${proxy.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium,
        ),
      );
    }
    // expand/shrink: 国旗国名单独一行(突出) + 节点名单行(超出省略号, 略暗作副标题)。
    // 两行各占 bodyMediumHeight, 总高仍是 bodyMediumHeight*2, 与 getItemHeight 一致。
    return SizedBox(
      height: measure.bodyMediumHeight * 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (country.isNotEmpty)
            SizedBox(
              height: measure.bodyMediumHeight,
              child: EmojiText(
                country,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium,
              ),
            ),
          SizedBox(
            height: measure.bodyMediumHeight,
            child: Text(
              proxy.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.textTheme.bodyMedium?.color?.opacity80,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changeProxy(WidgetRef ref) async {
    final isComputedSelected = groupType.isComputedSelected;
    final isSelector = groupType == GroupType.Selector;
    if (isComputedSelected || isSelector) {
      final currentProxyName = ref.read(getProxyNameProvider(groupName));
      final nextProxyName = switch (isComputedSelected) {
        true => currentProxyName == proxy.name ? '' : proxy.name,
        false => proxy.name,
      };
      appController.updateCurrentSelectedMap(groupName, nextProxyName);
      appController.changeProxyDebounce(groupName, nextProxyName);
      return;
    }
    globalState.showNotifier(appLocalizations.notSelectedTip);
  }

  @override
  Widget build(BuildContext context) {
    final measure = globalState.measure;
    final delayText = _buildDelayText();
    final proxyNameText = _buildProxyNameText(context);
    return Stack(
      children: [
        Consumer(
          builder: (_, ref, child) {
            final selectedProxyName = ref.watch(
              getSelectedProxyNameProvider(groupName),
            );
            return CommonCard(
              key: key,
              onPressed: () {
                _changeProxy(ref);
              },
              isSelected: selectedProxyName == proxy.name,
              child: child!,
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                proxyNameText,
                const SizedBox(height: 8),
                if (type == ProxyCardType.expand) ...[
                  SizedBox(
                    height: measure.bodySmallHeight,
                    child: _ProxyDesc(proxy: proxy),
                  ),
                  const SizedBox(height: 6),
                  delayText,
                ] else
                  SizedBox(
                    height: measure.bodySmallHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: TooltipText(
                            text: Text(
                              proxy.type,
                              style: context.textTheme.bodySmall?.copyWith(
                                overflow: TextOverflow.ellipsis,
                                color: context
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.opacity80,
                              ),
                            ),
                          ),
                        ),
                        delayText,
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (groupType.isComputedSelected)
          Positioned(
            top: 0,
            right: 0,
            child: _ProxyComputedMark(groupName: groupName, proxy: proxy),
          ),
      ],
    );
  }
}

class _ProxyDesc extends ConsumerWidget {
  final Proxy proxy;

  const _ProxyDesc({required this.proxy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final desc = ref.watch(getProxyDescProvider(proxy));
    return EmojiText(
      desc,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.textTheme.bodySmall?.color?.opacity80,
      ),
    );
  }
}

class _ProxyComputedMark extends ConsumerWidget {
  final String groupName;
  final Proxy proxy;

  const _ProxyComputedMark({required this.groupName, required this.proxy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proxyName = ref.watch(getProxyNameProvider(groupName));
    if (proxyName != proxy.name) {
      return SizedBox();
    }
    return Container(
      alignment: Alignment.topRight,
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: const SelectIcon(),
      ),
    );
  }
}

// 按节点名推断国家 → 国旗 emoji + 中文国名, 前缀到代理卡片展示名。
// 国旗经 EmojiText 用 Twemoji 字体渲染 (解决 Android/MIUI 默认不显示国旗 emoji 的问题)。
// 整 token 匹配 (按 [^a-z0-9] 拆分): cn2-jp → ["cn2","jp"], "cn2"≠"cn" 不误判中国 → 命中 jp=日本。
const _kProxyCountryToken = <String, String>{
  'us': 'US', 'usa': 'US',
  'jp': 'JP', 'japan': 'JP',
  'sg': 'SG', 'sgp': 'SG', 'singapore': 'SG',
  'hk': 'HK', 'tw': 'TW', 'mo': 'MO',
  'kr': 'KR', 'korea': 'KR',
  'gb': 'GB', 'uk': 'GB',
  'de': 'DE', 'fr': 'FR', 'nl': 'NL', 'ru': 'RU', 'tr': 'TR',
  'in': 'IN', 'au': 'AU', 'ca': 'CA',
  'vn': 'VN', 'th': 'TH', 'my': 'MY', 'ph': 'PH', 'id': 'ID',
  'cn': 'CN',
};

const _kProxyCountryLabel = <String, String>{
  'US': '美国', 'JP': '日本', 'SG': '新加坡', 'HK': '香港', 'TW': '台湾',
  'MO': '澳门', 'KR': '韩国', 'GB': '英国', 'DE': '德国', 'FR': '法国',
  'NL': '荷兰', 'RU': '俄罗斯', 'TR': '土耳其', 'IN': '印度', 'AU': '澳大利亚',
  'CA': '加拿大', 'VN': '越南', 'TH': '泰国', 'MY': '马来西亚', 'PH': '菲律宾',
  'ID': '印尼', 'CN': '中国',
};

String _countryFlagEmoji(String code) {
  final cc = code.toUpperCase();
  if (cc.length != 2) return '';
  return String.fromCharCode(0x1F1E6 + cc.codeUnitAt(0) - 0x41) +
      String.fromCharCode(0x1F1E6 + cc.codeUnitAt(1) - 0x41);
}

// 返回 "🇺🇸 美国 " 形式的前缀; 认不出国家则返回 ""。
String proxyCountryPrefix(String proxyName) {
  for (final token in proxyName.toLowerCase().split(RegExp(r'[^a-z0-9]+'))) {
    final code = _kProxyCountryToken[token];
    if (code != null) {
      return '${_countryFlagEmoji(code)} ${_kProxyCountryLabel[code] ?? code} ';
    }
  }
  return '';
}
