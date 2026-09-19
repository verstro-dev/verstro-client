import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/controller.dart';

class FlClashHttpOverrides extends HttpOverrides {
  static String handleFindProxy(Uri url) {
    if ([localhost].contains(url.host)) {
      return 'DIRECT';
    }
    // iOS: 核心跑在 NE 扩展、全局 TUN 已捕获 app 流量(Safari 同理), 无需也不该显式连本地代理端口
    // —— app 的 mixedPort(默认7890) 还和订阅服务端 sing-box 模板的 mixed-in(2412) 对不上,
    // 显式 PROXY 会 connection refused 致网络检测/checkIp 卡死. 直接 DIRECT 交给 TUN 路由.
    if (Platform.isIOS) return 'DIRECT';
    final port = appController.config.patchClashConfig.mixedPort;
    final isStart = appController.isStart;
    commonPrint.log('find $url proxy:$isStart');
    if (!isStart) return 'DIRECT';
    return 'PROXY localhost:$port';
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (_, _, _) => true;
    client.findProxy = handleFindProxy;
    return client;
  }
}
