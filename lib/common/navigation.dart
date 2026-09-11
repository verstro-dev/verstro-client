import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/verstro/pages/account_page.dart';
import 'package:fl_clash/views/views.dart';
import 'package:flutter/material.dart';

class Navigation {
  static Navigation? _instance;

  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    return [
      NavigationItem(
        keep: false,
        icon: Icon(Icons.space_dashboard),
        label: PageLabel.dashboard,
        builder: (_) =>
            const DashboardView(key: GlobalObjectKey(PageLabel.dashboard)),
      ),
      NavigationItem(
        icon: const Icon(Icons.article),
        label: PageLabel.proxies,
        builder: (_) =>
            const ProxiesView(key: GlobalObjectKey(PageLabel.proxies)),
        modes: hasProxies
            ? [NavigationItemMode.mobile, NavigationItemMode.desktop]
            : [],
      ),
      // 私有化托管服务: 诊断类页面(请求/连接/资源/日志)不进移动端工具页「More」区
      // —— 去掉 NavigationItemMode.more。暴露流量明细与服务逻辑, 用户无需。
      // 桌面端非面向消费者, 保留 desktop 模式不影响移动端。
      NavigationItem(
        icon: Icon(Icons.view_timeline),
        label: PageLabel.requests,
        builder: (_) =>
            const RequestsView(key: GlobalObjectKey(PageLabel.requests)),
        description: 'requestsDesc',
        modes: [NavigationItemMode.desktop],
      ),
      NavigationItem(
        icon: Icon(Icons.ballot),
        label: PageLabel.connections,
        builder: (_) =>
            const ConnectionsView(key: GlobalObjectKey(PageLabel.connections)),
        description: 'connectionsDesc',
        modes: [NavigationItemMode.desktop],
      ),
      NavigationItem(
        icon: Icon(Icons.storage),
        label: PageLabel.resources,
        description: 'resourcesDesc',
        builder: (_) =>
            const ResourcesView(key: GlobalObjectKey(PageLabel.resources)),
        modes: [],
      ),
      NavigationItem(
        icon: const Icon(Icons.adb),
        label: PageLabel.logs,
        builder: (_) => const LogsView(key: GlobalObjectKey(PageLabel.logs)),
        description: 'logsDesc',
        modes: openLogs ? [NavigationItemMode.desktop] : [],
      ),
      // 「工具」tab 已移除: 内容收进「设置」页(lib/views/settings.dart), 从账号页
      // 右上角齿轮进入。底栏按 modes 过滤生成, 删此项即自动变 3 tab。
      // Verstro 账户 tab (阶段 2.3.8): 查看当前套餐 / 续费升级 / 订单历史 / 登出.
      // VerstroAccountPage 自带 Scaffold+AppBar, 可直接作 navigation view 嵌入
      // (与其他 view 一致, home.dart 不额外包 Scaffold). 续费→PlanPicker、
      // 订单→UsdtInvoice 都是 Navigator.push 全屏路由.
      NavigationItem(
        icon: Icon(Icons.account_circle),
        label: PageLabel.account,
        builder: (_) =>
            const VerstroAccountPage(key: GlobalObjectKey(PageLabel.account)),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
    ];
  }

  Navigation._internal();

  factory Navigation() {
    _instance ??= Navigation._internal();
    return _instance!;
  }
}

final navigation = Navigation();
