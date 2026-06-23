import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/controller.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/proxies/list.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tab.dart';

class ProxiesView extends ConsumerStatefulWidget {
  const ProxiesView({super.key});

  @override
  ConsumerState<ProxiesView> createState() => _ProxiesViewState();
}

class _ProxiesViewState extends ConsumerState<ProxiesView> {
  final GlobalKey<CommonScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<ProxiesTabViewState> _proxiesTabKey = GlobalKey();
  bool _isTab = false;
  bool _isRefreshing = false;

  // 顶部只保留「刷新」(重新拉取订阅)。搜索/三点菜单/定位圆点已精简移除:
  // 节点固定且少, 搜索与"滚动到选中组"无实际用途, 代理样式设置入口也一并隐藏。
  List<Widget> _buildActions() {
    return [
      IconButton(
        onPressed: _isRefreshing ? null : _refreshProfiles,
        icon: const Icon(Icons.refresh),
      ),
    ];
  }

  Widget? _buildFAB() {
    return _isTab
        ? DelayTestButton(
            onClick: () async {
              await _proxiesTabKey.currentState?.delayTestCurrentGroup();
            },
          )
        : null;
  }

  // 刷新代理 = 重新拉取订阅内容更新配置 (用户无需感知"配置"概念)。
  Future<void> _refreshProfiles() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      await appController.updateProfiles();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      proxiesStyleSettingProvider.select(
        (state) => state.type == ProxiesType.tab,
      ),
      (prev, next) {
        if (prev != next) {
          setState(() {
            _isTab = next;
          });
        }
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final proxiesType = ref.watch(
      proxiesStyleSettingProvider.select((state) => state.type),
    );
    final isLoading = ref.watch(loadingProvider(LoadingTag.proxies));
    return CommonScaffold(
      key: _scaffoldKey,
      isLoading: isLoading || _isRefreshing,
      resizeToAvoidBottomInset: false,
      floatingActionButton: _buildFAB(),
      actions: _buildActions(),
      title: appLocalizations.proxies,
      body: switch (proxiesType) {
        ProxiesType.tab => ProxiesTabView(key: _proxiesTabKey),
        ProxiesType.list => const ProxiesListView(),
      },
    );
  }
}
