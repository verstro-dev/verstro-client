// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static String m0(count) => "${count} 天前";

  static String m1(label) => "确定删除选中的${label}吗？";

  static String m2(label) => "确定删除当前${label}吗？";

  static String m3(label) => "${label}详情";

  static String m4(label) => "${label}不能为空";

  static String m5(label) => "${label}当前已存在";

  static String m6(count) => "${count} 小时前";

  static String m7(count) => "${count} 分钟前";

  static String m8(count) => "${count} 个月前";

  static String m9(label) => "暂无${label}";

  static String m10(label) => "${label}必须为数字";

  static String m11(label) => "${label} 必须在 1024 到 49151 之间";

  static String m12(count) => "已选择 ${count} 项";

  static String m13(label) => "${label}必须为URL";

  static String m14(url) => "无法打开: ${url}";

  static String m15(days) => "${days} 天前活跃";

  static String m16(hours) => "${hours} 小时前活跃";

  static String m17(minutes) => "${minutes} 分钟前活跃";

  static String m18(count) => "邀请好友赚 30% 佣金 · 已邀请 ${count} 人";

  static String m19(amount) => "可提现 ${amount}";

  static String m20(amount) => "可用余额  ${amount}";

  static String m21(error) => "启动失败: ${error}";

  static String m22(days) => "${days} 天后";

  static String m23(count, max) => "已登记 ${count} / ${max} 台";

  static String m24(count) => "已登记 ${count} 台";

  static String m25(date) => "到期 ${date}";

  static String m26(hours) => "${hours} 小时后";

  static String m27(name) => "\"${name}\" 将被移除, 需重新登录才能继续使用 Verstro.";

  static String m28(error) => "登出失败: ${error}";

  static String m29(minutes) => "${minutes} 分钟后";

  static String m30(error) => "订单查询失败: ${error}";

  static String m31(amount) => "剩余 ${amount}";

  static String m32(email) => "验证码已发送到 ${email}（含垃圾箱）。输入 6 位验证码完成验证。";

  static String m33(amount) => "可提现 ${amount}";

  static String m34(dest) => "到账地址 ${dest}";

  static String m35(count) => "已邀请 ${count} 人";

  static String m36(price) => "最低可售价 ${price}";

  static String m37(amount) => "已打款 ${amount}";

  static String m38(min) => "可提现余额不足，最低提现额为 ${min}";

  static String m39(amount, dest) =>
      "提现金额：${amount}\n收款地址（TRC20）：\n${dest}\n\n提交后由人工打款，通常 24 小时内到账，最迟不超过 3 个工作日。链上手续费由平台承担，到账金额即为申请金额。\n\n请仔细核对地址：提交后不可修改，转入错误地址将无法找回。";

  static String m40(min, current) => "满 ${min} 可提现 (当前 ${current})";

  static String m41(amount) => "待成熟 ${amount}（14 天成熟期）";

  static String m42(planId) => "套餐 ${planId}";

  static String m43(list, floor) => "平台价 ${list} · 你的拿货价 ${floor}";

  static String m44(floor, list) => "须在 ${floor} ~ ${list} 之间";

  static String m45(floor, list) => "可用区间 ${floor} ~ ${list} (只许折扣)";

  static String m46(planId, price) => "已设 ${planId} 售价 ${price}";

  static String m47(list) => "未设 (按平台价 ${list} 收)";

  static String m48(amount) => "处理中 ${amount}（人工打款中）";

  static String m49(planId) => "设 ${planId} 售价";

  static String m50(code, url) =>
      "用我的邀请码 ${code} 注册 Verstro，首次购买你也有奖励！下载：${url}";

  static String m51(count, amount) => "下线 ${count} 人 · override 可提 ${amount}";

  static String m52(price, earn) => "你的售价 ${price} · 每单赚 ${earn}";

  static String m53(detail) => "连不上后端：${detail}";

  static String m54(status) => "服务端错误 (${status})";

  static String m55(detail) => "TLS 证书错误：${detail}";

  static String m56(type) => "意料外的响应类型：${type}";

  static String m57(status) => "意料外状态码 ${status}";

  static String m58(error) => "登录失败: ${error}";

  static String m59(error) => "注册失败: ${error}";

  static String m60(seconds) => "重新发送（${seconds} s）";

  static String m61(email) => "验证码已发送到 ${email}（含垃圾箱）。\n输入 6 位验证码并设置新密码.";

  static String m62(count) => "${count} 张会员卡已进入你的库存。";

  static String m63(payment, issuance) => "付款：${payment} · 发卡：${issuance}";

  static String m64(id) => "会员卡订单 #${id}";

  static String m65(days, traffic) => "${days} 天 · ${traffic}";

  static String m66(count) => "普通用户批量价：${count} 张，按服务端确认的 70% 档计费。";

  static String m67(cost) => "战略代理成本档：服务端成本比例 ${cost}/10000，不叠加批量折扣。";

  static String m68(cost) => "推广代理成本档：服务端成本比例 ${cost}/10000，不叠加批量折扣。";

  static String m69(cost) => "分销代理成本档：服务端成本比例 ${cost}/10000，不叠加批量折扣。";

  static String m70(count) => "普通零售礼品卡：${count} 张，按目录原价计费。";

  static String m71(date) => "该权益将于 ${date} 按排期生效。";

  static String m72(start, end) => "${start} 至 ${end}";

  static String m73(amount) => "已确认，订阅已开通。多付的 ${amount} 已存入账户余额，下次购买自动抵扣。";

  static String m74(amount) =>
      "该订单已过期，但我们收到了这笔转账。${amount} 已全额存入账户余额。请重新下单——余额自动抵扣，足额立即开通。";

  static String m75(amount) => "${amount} 已存入账户余额。请重新下单——余额自动抵扣。";

  static String m76(amount, shortfall) =>
      "到账金额少于应付。${amount} 已全额存入账户余额，原订单已作废。请重新下单——余额自动抵扣，只需补付差额 ${shortfall}。";

  static String m77(amount, count, remaining) =>
      "已通过 ${count} 笔付款累计收到 ${amount}，尚需补付 ${remaining}。请向本订单收款地址补付差额并继续提交 TXID。";

  static String m78(count) => "已通过 ${count} 笔付款完成支付，订阅已开通。";

  static String m79(amount) => "超额的 ${amount} 已存入账户余额，下次购买自动抵扣。";

  static String m80(recipient) =>
      "该交易的实际收款地址为 ${recipient}，与订单不符；请核对转账记录，勿重复付款。";

  static String m81(code) => "授权编号 ${code}";

  static String m82(basePrice) =>
      "套餐基价 \$${basePrice} + 防冲突尾数. 多 0.01 或少 0.01 都无法自动匹配, 请检查钱包「金额」字段是否一致到小数点后 2 位.";

  static String m83(id) => "订单 #${id} 在 24 小时内未收到付款, 已自动作废.";

  static String m84(id) => "订单 #${id}";

  static String m85(plan, id) => "${plan} 订单 #${id}";

  static String m86(seconds) => "${seconds} 秒后可重试";

  static String m87(error) => "提交失败: ${error}";

  static String m88(email) => "账号: ${email}";

  static String m89(error) => "创建订单失败: ${error}";

  static String m90(days) => "${days} 天有效";

  static String m91(error) => "加载套餐失败: ${error}";

  static String m92(count) => "${count} 台设备同时在线";

  static String m93(price) => "约 \$${price} / 月";

  static String m94(amount) => "${amount} 流量";

  static String m95(amount) => "已减免 ${amount}";

  static String m96(error) => "无法获取优惠报价：${error}";

  static String m97(trial, invite, url) =>
      "Verstro 隐私优先的跨平台网络工具：Android 与桌面端提供客户端，iOS 可按教程导入兼容第三方客户端。${trial}${invite}${url}";

  static String m98(trial, invite, url) =>
      "终端、Docker、Git 不读取系统代理？Verstro 桌面端开启 TUN 后，可在系统网络层覆盖更多应用；实际覆盖受系统、应用、规则与网络环境影响。客户端 GPLv3 开源可审计。${trial}${invite}${url}";

  static String m99(trial, invite, url) =>
      "我在用 Verstro —— 隐私优先的跨平台网络工具。Android 与桌面端提供客户端，iOS 可按教程导入兼容第三方客户端；实际体验受系统和网络环境影响。客户端 GPLv3 开源可审计。${trial}${invite}下载：${url}";

  static String m100(prefix, amount) => "${prefix}，首购后你我各得 ${amount} 抵扣。";

  static String m101(prefix) => "${prefix}。";

  static String m102(code) => "注册时填我的邀请码 ${code}";

  static String m103(code) => "注册填邀请码 ${code}";

  static String m104(prefix, amount) => "${prefix}，首购后可得 ${amount} 抵扣。";

  static String m105(amount) => "填码注册 · 首购后你我各得 ${amount}";

  static String m106(amount) => "填码注册 · 首购得 ${amount} 抵扣";

  static String m107(days) => "免费试用 ${days} 天";

  static String m108(trial, gb) => "新用户${trial}${gb}";

  static String m109(days) => "新用户可免费试用 ${days} 天。";

  static String m110(days, gb) => "${days} 天 · ${gb}GB 流量";

  static String m111(days) => "验证邮箱后可领取 ${days} 天免费试用（输入邮件里的 6 位验证码）";

  static String m112(error) => "下载失败: ${error}";

  static String m113(percent) => "下载中 ${percent}%";

  static String m114(version) => "需要更新到 v${version}";

  static String m115(error) => "调起安装失败: ${error}";

  static String m116(version) => "发现新版本 v${version}";

  static String m117(error) => "更新失败: ${error}";

  static String m118(count) => "${count} 年前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("关于"),
    "accessControl": MessageLookupByLibrary.simpleMessage("访问控制"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "只允许选中应用进入VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage("配置应用访问代理"),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "选中应用将会被排除在VPN之外",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage("访问控制设置"),
    "account": MessageLookupByLibrary.simpleMessage("账号"),
    "action": MessageLookupByLibrary.simpleMessage("操作"),
    "action_mode": MessageLookupByLibrary.simpleMessage("切换模式"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "action_start": MessageLookupByLibrary.simpleMessage("启动/停止"),
    "action_tun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "action_view": MessageLookupByLibrary.simpleMessage("显示/隐藏"),
    "add": MessageLookupByLibrary.simpleMessage("添加"),
    "addProfile": MessageLookupByLibrary.simpleMessage("添加配置"),
    "addRule": MessageLookupByLibrary.simpleMessage("添加规则"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage("附加到原始规则"),
    "addedRules": MessageLookupByLibrary.simpleMessage("附加规则"),
    "address": MessageLookupByLibrary.simpleMessage("地址"),
    "addressHelp": MessageLookupByLibrary.simpleMessage("WebDAV服务器地址"),
    "addressTip": MessageLookupByLibrary.simpleMessage("请输入有效的WebDAV地址"),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage("管理员自启动"),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage("使用管理员模式开机自启动"),
    "advancedConfig": MessageLookupByLibrary.simpleMessage("进阶配置"),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage("提供多样化配置"),
    "ago": MessageLookupByLibrary.simpleMessage("前"),
    "agree": MessageLookupByLibrary.simpleMessage("同意"),
    "allApps": MessageLookupByLibrary.simpleMessage("所有应用"),
    "allowBypass": MessageLookupByLibrary.simpleMessage("允许应用绕过VPN"),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage("开启后部分应用可绕过VPN"),
    "allowLan": MessageLookupByLibrary.simpleMessage("局域网代理"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage("允许通过局域网访问代理"),
    "app": MessageLookupByLibrary.simpleMessage("应用"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage("应用访问控制"),
    "appDesc": MessageLookupByLibrary.simpleMessage("处理应用相关设置"),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage("追加系统DNS"),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage("强制为配置附加系统DNS"),
    "application": MessageLookupByLibrary.simpleMessage("应用程序"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage("修改应用程序相关设置"),
    "auto": MessageLookupByLibrary.simpleMessage("自动"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage("自动检查更新"),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage("应用启动时自动检查更新"),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage("自动关闭连接"),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "切换节点后自动关闭连接",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("自启动"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage("跟随系统自启动"),
    "autoRun": MessageLookupByLibrary.simpleMessage("自动运行"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage("应用打开时自动运行"),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage("自动设置系统DNS"),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("自动更新"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage("自动更新间隔（分钟）"),
    "backup": MessageLookupByLibrary.simpleMessage("备份"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage("备份与恢复"),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "通过WebDAV或者文件同步数据",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("备份成功"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("基本配置"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage("全局修改基本配置"),
    "bind": MessageLookupByLibrary.simpleMessage("绑定"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("黑名单模式"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("排除域名"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage("仅在系统代理启用时生效"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage("缓存已损坏，是否清空？"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage("取消过滤系统应用"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("取消全选"),
    "checkError": MessageLookupByLibrary.simpleMessage("检测失败"),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage("当前应用已经是最新版了"),
    "checking": MessageLookupByLibrary.simpleMessage("检测中..."),
    "clearData": MessageLookupByLibrary.simpleMessage("清除数据"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("导出剪贴板"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("剪贴板导入"),
    "color": MessageLookupByLibrary.simpleMessage("颜色"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("配色方案"),
    "columns": MessageLookupByLibrary.simpleMessage("列数"),
    "compatible": MessageLookupByLibrary.simpleMessage("兼容模式"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "开启将失去部分应用能力，获得全量的Clash的支持",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("确定"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage("确定要清除所有数据？"),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage("确定要强制崩溃核心？"),
    "connected": MessageLookupByLibrary.simpleMessage("已连接"),
    "connecting": MessageLookupByLibrary.simpleMessage("连接中..."),
    "connection": MessageLookupByLibrary.simpleMessage("连接"),
    "connections": MessageLookupByLibrary.simpleMessage("连接"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage("查看当前连接数据"),
    "connectivity": MessageLookupByLibrary.simpleMessage("连通性："),
    "contactMe": MessageLookupByLibrary.simpleMessage("联系我"),
    "content": MessageLookupByLibrary.simpleMessage("内容"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("内容主题"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage("控制全局附加规则"),
    "copy": MessageLookupByLibrary.simpleMessage("复制"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage("复制环境变量"),
    "copyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("复制成功"),
    "core": MessageLookupByLibrary.simpleMessage("内核"),
    "coreConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "检测到核心配置更改",
    ),
    "coreInfo": MessageLookupByLibrary.simpleMessage("内核信息"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("核心状态"),
    "country": MessageLookupByLibrary.simpleMessage("区域"),
    "crashTest": MessageLookupByLibrary.simpleMessage("崩溃测试"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("崩溃分析"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "开启后，应用崩溃时自动上传不包含敏感信息的崩溃日志",
    ),
    "create": MessageLookupByLibrary.simpleMessage("创建"),
    "creationTime": MessageLookupByLibrary.simpleMessage("创建时间"),
    "cut": MessageLookupByLibrary.simpleMessage("剪切"),
    "dark": MessageLookupByLibrary.simpleMessage("深色"),
    "dashboard": MessageLookupByLibrary.simpleMessage("仪表盘"),
    "days": MessageLookupByLibrary.simpleMessage("天"),
    "daysAgo": m0,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage("默认域名服务器"),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析DNS服务器"),
    "defaultSort": MessageLookupByLibrary.simpleMessage("按默认排序"),
    "defaultText": MessageLookupByLibrary.simpleMessage("默认"),
    "delay": MessageLookupByLibrary.simpleMessage("延迟"),
    "delaySort": MessageLookupByLibrary.simpleMessage("按延迟排序"),
    "delayTest": MessageLookupByLibrary.simpleMessage("延迟测试"),
    "delete": MessageLookupByLibrary.simpleMessage("删除"),
    "deleteMultipTip": m1,
    "deleteTip": m2,
    "desc": MessageLookupByLibrary.simpleMessage(
      "基于ClashMeta的多平台代理客户端，简单易用，开源无广告。",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("目标地址"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage("目标地理定位"),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage("目标IP ASN"),
    "details": m3,
    "detectionTip": MessageLookupByLibrary.simpleMessage("依赖第三方api，仅供参考"),
    "developerMode": MessageLookupByLibrary.simpleMessage("开发者模式"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage("开发者模式已启用。"),
    "direct": MessageLookupByLibrary.simpleMessage("直连"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("免责声明"),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "本软件仅供学习交流、科研等非商业性质的用途，严禁将本软件用于商业目的。如有任何商业行为，均与本软件无关。",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("已断开"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage("发现新版本"),
    "discovery": MessageLookupByLibrary.simpleMessage("发现新版本"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("更新DNS相关设置"),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS劫持"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS模式"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage("是否要通过"),
    "domain": MessageLookupByLibrary.simpleMessage("域名"),
    "download": MessageLookupByLibrary.simpleMessage("下载"),
    "edit": MessageLookupByLibrary.simpleMessage("编辑"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage("编辑全局规则"),
    "editRule": MessageLookupByLibrary.simpleMessage("编辑规则"),
    "emptyTip": m4,
    "en": MessageLookupByLibrary.simpleMessage("英语"),
    "enableOverride": MessageLookupByLibrary.simpleMessage("启用覆写"),
    "entries": MessageLookupByLibrary.simpleMessage("个条目"),
    "exclude": MessageLookupByLibrary.simpleMessage("从最近任务中隐藏"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage("应用在后台时,从最近任务中隐藏应用"),
    "existsTip": m5,
    "exit": MessageLookupByLibrary.simpleMessage("退出"),
    "expand": MessageLookupByLibrary.simpleMessage("标准"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("到期时间"),
    "exportFile": MessageLookupByLibrary.simpleMessage("导出文件"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("导出日志"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("导出成功"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("表现力"),
    "externalController": MessageLookupByLibrary.simpleMessage("外部控制器"),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "开启后将可以通过9090端口控制Clash内核",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("外部获取"),
    "externalLink": MessageLookupByLibrary.simpleMessage("外部链接"),
    "externalResources": MessageLookupByLibrary.simpleMessage("外部资源"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fakeip过滤"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fakeip范围"),
    "fallback": MessageLookupByLibrary.simpleMessage("Fallback"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage("一般情况下使用境外DNS"),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback过滤"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("高保真"),
    "file": MessageLookupByLibrary.simpleMessage("文件"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("直接上传配置文件"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage("文件有修改，是否保存修改"),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage("过滤系统应用"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("查找进程"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage("开启后会有一定性能损耗"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("字体"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage("您确定要强制重启核心吗？"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("四列"),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("果缤纷"),
    "general": MessageLookupByLibrary.simpleMessage("常规"),
    "generalDesc": MessageLookupByLibrary.simpleMessage("修改通用设置"),
    "geoData": MessageLookupByLibrary.simpleMessage("地理数据"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage("Geo低内存模式"),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage("开启将使用Geo低内存加载器"),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Geoip代码"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage("获取原始规则"),
    "global": MessageLookupByLibrary.simpleMessage("全局"),
    "go": MessageLookupByLibrary.simpleMessage("前往"),
    "goDownload": MessageLookupByLibrary.simpleMessage("前往下载"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage("前往配置脚本"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage("是否缓存修改"),
    "host": MessageLookupByLibrary.simpleMessage("主机"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("追加Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("快捷键冲突"),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("快捷键管理"),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage("使用键盘控制应用程序"),
    "hours": MessageLookupByLibrary.simpleMessage("小时"),
    "hoursAgo": m6,
    "icon": MessageLookupByLibrary.simpleMessage("图片"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage("图片配置"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("图标样式"),
    "import": MessageLookupByLibrary.simpleMessage("导入"),
    "importFile": MessageLookupByLibrary.simpleMessage("通过文件导入"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("从URL导入"),
    "importUrl": MessageLookupByLibrary.simpleMessage("通过URL导入"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("长期有效"),
    "init": MessageLookupByLibrary.simpleMessage("初始化"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage("请输入正确的快捷键"),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("智能选择"),
    "internet": MessageLookupByLibrary.simpleMessage("互联网"),
    "interval": MessageLookupByLibrary.simpleMessage("间隔"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("内网 IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage("无效备份文件"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("IP/掩码"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage("开启后将可以接收IPv6流量"),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage("允许IPv6入站"),
    "ja": MessageLookupByLibrary.simpleMessage("日语"),
    "just": MessageLookupByLibrary.simpleMessage("刚刚"),
    "justNow": MessageLookupByLibrary.simpleMessage("刚刚"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage("TCP保持活动间隔"),
    "key": MessageLookupByLibrary.simpleMessage("键"),
    "language": MessageLookupByLibrary.simpleMessage("语言"),
    "layout": MessageLookupByLibrary.simpleMessage("布局"),
    "light": MessageLookupByLibrary.simpleMessage("浅色"),
    "list": MessageLookupByLibrary.simpleMessage("列表"),
    "listen": MessageLookupByLibrary.simpleMessage("监听"),
    "loadTest": MessageLookupByLibrary.simpleMessage("加载测试"),
    "loading": MessageLookupByLibrary.simpleMessage("加载中..."),
    "local": MessageLookupByLibrary.simpleMessage("本地"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage("备份数据到本地"),
    "log": MessageLookupByLibrary.simpleMessage("日志"),
    "logLevel": MessageLookupByLibrary.simpleMessage("日志等级"),
    "logcat": MessageLookupByLibrary.simpleMessage("日志捕获"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage("禁用将会隐藏日志入口"),
    "logs": MessageLookupByLibrary.simpleMessage("日志"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("日志捕获记录"),
    "logsTest": MessageLookupByLibrary.simpleMessage("日志测试"),
    "loopback": MessageLookupByLibrary.simpleMessage("回环解锁工具"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage("用于UWP回环解锁"),
    "loose": MessageLookupByLibrary.simpleMessage("宽松"),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("内存信息"),
    "messageTest": MessageLookupByLibrary.simpleMessage("消息测试"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("这是一条消息。"),
    "min": MessageLookupByLibrary.simpleMessage("最小"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("退出时最小化"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage("修改系统默认退出事件"),
    "minutes": MessageLookupByLibrary.simpleMessage("分钟"),
    "minutesAgo": m7,
    "mixedPort": MessageLookupByLibrary.simpleMessage("混合端口"),
    "mode": MessageLookupByLibrary.simpleMessage("模式"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("单色"),
    "months": MessageLookupByLibrary.simpleMessage("月"),
    "monthsAgo": m8,
    "more": MessageLookupByLibrary.simpleMessage("更多"),
    "name": MessageLookupByLibrary.simpleMessage("名称"),
    "nameSort": MessageLookupByLibrary.simpleMessage("按名称排序"),
    "nameserver": MessageLookupByLibrary.simpleMessage("域名服务器"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析域名"),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage("域名服务器策略"),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage("指定对应域名服务器策略"),
    "network": MessageLookupByLibrary.simpleMessage("网络"),
    "networkDesc": MessageLookupByLibrary.simpleMessage("修改网络相关设置"),
    "networkDetection": MessageLookupByLibrary.simpleMessage("网络检测"),
    "networkException": MessageLookupByLibrary.simpleMessage("网络异常，请检查连接后重试"),
    "networkRequestException": MessageLookupByLibrary.simpleMessage(
      "网络请求异常，请稍后再试。",
    ),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("网络速度"),
    "networkType": MessageLookupByLibrary.simpleMessage("网络类型"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("中性"),
    "noData": MessageLookupByLibrary.simpleMessage("暂无数据"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("暂无快捷键"),
    "noIcon": MessageLookupByLibrary.simpleMessage("无图标"),
    "noInfo": MessageLookupByLibrary.simpleMessage("暂无信息"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage("不再提示"),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage("暂无更多信息"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("无网络"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("无网络应用"),
    "noProxy": MessageLookupByLibrary.simpleMessage("暂无代理"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage("请创建配置文件或者添加有效配置文件"),
    "noResolve": MessageLookupByLibrary.simpleMessage("不解析IP"),
    "none": MessageLookupByLibrary.simpleMessage("无"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage("当前代理组无法选中"),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage("没有配置文件,请先添加配置文件"),
    "nullTip": m9,
    "numberTip": m10,
    "oneColumn": MessageLookupByLibrary.simpleMessage("一列"),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("仅图标"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage("仅第三方应用"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage("仅统计代理"),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "开启后，将只统计代理流量",
    ),
    "options": MessageLookupByLibrary.simpleMessage("选项"),
    "other": MessageLookupByLibrary.simpleMessage("其他"),
    "otherContributors": MessageLookupByLibrary.simpleMessage("其他贡献者"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("出站模式"),
    "override": MessageLookupByLibrary.simpleMessage("覆写"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage("覆写代理相关配置"),
    "overrideDns": MessageLookupByLibrary.simpleMessage("覆写DNS"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage("开启后将覆盖配置中的DNS选项"),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage("在脚本模式下不生效"),
    "overrideMode": MessageLookupByLibrary.simpleMessage("覆写模式"),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage("覆盖原始规则"),
    "overrideScript": MessageLookupByLibrary.simpleMessage("覆写脚本"),
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage("自定义"),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "自定义模式，支持完全自定义修改代理组以及规则",
    ),
    "palette": MessageLookupByLibrary.simpleMessage("调色板"),
    "password": MessageLookupByLibrary.simpleMessage("密码"),
    "paste": MessageLookupByLibrary.simpleMessage("粘贴"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage("请绑定WebDAV"),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage("请输入脚本名称"),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "请输入管理员密码",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage("请上传文件"),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "请上传有效的二维码",
    ),
    "port": MessageLookupByLibrary.simpleMessage("端口"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage("请输入不同的端口"),
    "portTip": m11,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage("优先使用DOH的http/3"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage("请按下按键"),
    "preview": MessageLookupByLibrary.simpleMessage("预览"),
    "process": MessageLookupByLibrary.simpleMessage("进程"),
    "profile": MessageLookupByLibrary.simpleMessage("配置"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("请输入有效间隔时间格式"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("请输入自动更新间隔时间"),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "配置文件已经修改,是否关闭自动更新 ",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入配置名称",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage("配置文件解析错误"),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入有效配置URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入配置URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("配置"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("配置排序"),
    "project": MessageLookupByLibrary.simpleMessage("项目"),
    "providers": MessageLookupByLibrary.simpleMessage("提供者"),
    "proxies": MessageLookupByLibrary.simpleMessage("代理"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("代理设置"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("代理链"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("代理组"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("代理域名服务器"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析代理节点的域名"),
    "proxyPort": MessageLookupByLibrary.simpleMessage("代理端口"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage("设置Clash监听端口"),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("代理提供者"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("修剪缓存"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("纯黑模式"),
    "qrcode": MessageLookupByLibrary.simpleMessage("二维码"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage("扫描二维码获取配置文件"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("彩虹"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir端口"),
    "redo": MessageLookupByLibrary.simpleMessage("重做"),
    "regExp": MessageLookupByLibrary.simpleMessage("正则"),
    "reload": MessageLookupByLibrary.simpleMessage("重载"),
    "remote": MessageLookupByLibrary.simpleMessage("远程"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage("备份数据到WebDAV"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage("远程目标"),
    "remove": MessageLookupByLibrary.simpleMessage("移除"),
    "rename": MessageLookupByLibrary.simpleMessage("重命名"),
    "request": MessageLookupByLibrary.simpleMessage("请求"),
    "requests": MessageLookupByLibrary.simpleMessage("请求"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage("查看最近请求记录"),
    "reset": MessageLookupByLibrary.simpleMessage("重置"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "当前页面存在更改，确定重置吗？",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage("确定要重置吗?"),
    "resources": MessageLookupByLibrary.simpleMessage("资源"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage("外部资源相关信息"),
    "respectRules": MessageLookupByLibrary.simpleMessage("遵守规则"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS连接跟随rules,需配置proxy-server-nameserver",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("重启"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage("您确定要重启核心吗？"),
    "restore": MessageLookupByLibrary.simpleMessage("恢复"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("恢复所有数据"),
    "restoreException": MessageLookupByLibrary.simpleMessage("恢复异常"),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage("通过文件恢复数据"),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "通过WebDAV恢复数据",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage("仅恢复配置文件"),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("恢复策略"),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage("兼容"),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage("覆盖"),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage("恢复成功"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("路由地址"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage("配置监听路由地址"),
    "routeMode": MessageLookupByLibrary.simpleMessage("路由模式"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage("绕过私有路由地址"),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("使用配置"),
    "ru": MessageLookupByLibrary.simpleMessage("俄语"),
    "rule": MessageLookupByLibrary.simpleMessage("规则"),
    "ruleName": MessageLookupByLibrary.simpleMessage("规则名称"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("规则提供者"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("规则目标"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("是否保存更改？"),
    "saveTip": MessageLookupByLibrary.simpleMessage("确定要保存吗？"),
    "script": MessageLookupByLibrary.simpleMessage("脚本"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "脚本模式，使用外部扩展脚本，提供一键覆写配置的能力",
    ),
    "search": MessageLookupByLibrary.simpleMessage("搜索"),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "selectAll": MessageLookupByLibrary.simpleMessage("全选"),
    "selected": MessageLookupByLibrary.simpleMessage("已选择"),
    "selectedCountTitle": m12,
    "settings": MessageLookupByLibrary.simpleMessage("设置"),
    "show": MessageLookupByLibrary.simpleMessage("显示"),
    "shrink": MessageLookupByLibrary.simpleMessage("紧凑"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("静默启动"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage("后台启动"),
    "size": MessageLookupByLibrary.simpleMessage("尺寸"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks端口"),
    "sort": MessageLookupByLibrary.simpleMessage("排序"),
    "source": MessageLookupByLibrary.simpleMessage("来源"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("源IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("特殊代理"),
    "specialRules": MessageLookupByLibrary.simpleMessage("特殊规则"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("网速统计"),
    "stackMode": MessageLookupByLibrary.simpleMessage("栈模式"),
    "standard": MessageLookupByLibrary.simpleMessage("标准"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "标准模式，覆写基本配置，提供简单追加规则能力",
    ),
    "start": MessageLookupByLibrary.simpleMessage("启动"),
    "startVpn": MessageLookupByLibrary.simpleMessage("正在启动VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("状态"),
    "statusDesc": MessageLookupByLibrary.simpleMessage("关闭后将使用系统DNS"),
    "stop": MessageLookupByLibrary.simpleMessage("暂停"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("正在停止VPN..."),
    "style": MessageLookupByLibrary.simpleMessage("风格"),
    "subRule": MessageLookupByLibrary.simpleMessage("子规则"),
    "submit": MessageLookupByLibrary.simpleMessage("提交"),
    "sync": MessageLookupByLibrary.simpleMessage("同步"),
    "system": MessageLookupByLibrary.simpleMessage("系统"),
    "systemApp": MessageLookupByLibrary.simpleMessage("系统应用"),
    "systemFont": MessageLookupByLibrary.simpleMessage("系统字体"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage("设置系统代理"),
    "tab": MessageLookupByLibrary.simpleMessage("标签页"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("选项卡动画"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage("仅在移动视图中有效"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP并发"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage("开启后允许TCP并发"),
    "testUrl": MessageLookupByLibrary.simpleMessage("测速链接"),
    "textScale": MessageLookupByLibrary.simpleMessage("文本缩放"),
    "theme": MessageLookupByLibrary.simpleMessage("主题"),
    "themeColor": MessageLookupByLibrary.simpleMessage("主题色彩"),
    "themeDesc": MessageLookupByLibrary.simpleMessage("设置深色模式，调整色彩"),
    "themeMode": MessageLookupByLibrary.simpleMessage("主题模式"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("三列"),
    "tight": MessageLookupByLibrary.simpleMessage("紧凑"),
    "time": MessageLookupByLibrary.simpleMessage("时间"),
    "tip": MessageLookupByLibrary.simpleMessage("提示"),
    "toggle": MessageLookupByLibrary.simpleMessage("切换"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("调性点缀"),
    "tools": MessageLookupByLibrary.simpleMessage("工具"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy端口"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("流量统计"),
    "tun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "tunDesc": MessageLookupByLibrary.simpleMessage("仅在管理员模式生效"),
    "turnOff": MessageLookupByLibrary.simpleMessage("关闭"),
    "turnOn": MessageLookupByLibrary.simpleMessage("开启"),
    "twoColumns": MessageLookupByLibrary.simpleMessage("两列"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "无法更新当前配置文件",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("撤销"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("统一延迟"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage("去除握手等额外延迟"),
    "unknown": MessageLookupByLibrary.simpleMessage("未知"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage("未知网络错误"),
    "unnamed": MessageLookupByLibrary.simpleMessage("未命名"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "upload": MessageLookupByLibrary.simpleMessage("上传"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage("通过URL获取配置文件"),
    "urlTip": m13,
    "useHosts": MessageLookupByLibrary.simpleMessage("使用Hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("使用系统Hosts"),
    "vAboutCannotOpen": m14,
    "vAboutChecking": MessageLookupByLibrary.simpleMessage("检查中…"),
    "vAboutContactSection": MessageLookupByLibrary.simpleMessage("联系与支持"),
    "vAboutCreditsBody": MessageLookupByLibrary.simpleMessage(
      "感谢 FlClash (chen08209)、Mihomo (Clash.Meta) 团队、sing-box 团队, 以及整个开源网络社区. Verstro 的网络能力建立在这些项目之上.",
    ),
    "vAboutCreditsSection": MessageLookupByLibrary.simpleMessage("致谢"),
    "vAboutEmail": MessageLookupByLibrary.simpleMessage("邮件"),
    "vAboutOssBody": MessageLookupByLibrary.simpleMessage(
      "Verstro 客户端基于开源项目 FlClash (GPLv3) 衍生, 内核为 Mihomo / sing-box (均 GPLv3). 依据 GPLv3, 本客户端的完整源代码对外公开.",
    ),
    "vAboutOssSection": MessageLookupByLibrary.simpleMessage("开源与许可"),
    "vAboutPrivacyBody": MessageLookupByLibrary.simpleMessage(
      "• 邮箱仅用于支付通知和找回密码, 不发营销邮件\n• 不收集设备 ID / 位置 / 通讯录 / 联系人\n• 流量统计仅记录用量, 不记录内容\n• 收款经自建链上接收, 不经过第三方托管",
    ),
    "vAboutPrivacySection": MessageLookupByLibrary.simpleMessage("隐私承诺"),
    "vAboutSlogan": MessageLookupByLibrary.simpleMessage("隐私优先的全球网络"),
    "vAboutSourceCode": MessageLookupByLibrary.simpleMessage("源代码与许可证"),
    "vAboutTelegramGroup": MessageLookupByLibrary.simpleMessage("Telegram 社群"),
    "vAboutTitle": MessageLookupByLibrary.simpleMessage("关于 Verstro"),
    "vAboutVisitWebsite": MessageLookupByLibrary.simpleMessage("访问官网"),
    "vAboutWebsiteSection": MessageLookupByLibrary.simpleMessage("官网"),
    "vAcctActiveDaysAgo": m15,
    "vAcctActiveHoursAgo": m16,
    "vAcctActiveJustNow": MessageLookupByLibrary.simpleMessage("刚刚活跃"),
    "vAcctActiveMinutesAgo": m17,
    "vAcctAgentCenter": MessageLookupByLibrary.simpleMessage("推广中心"),
    "vAcctAgentEntrySubtitle": m18,
    "vAcctAgentTierAgent": MessageLookupByLibrary.simpleMessage("认证分销伙伴"),
    "vAcctAgentTierMaster": MessageLookupByLibrary.simpleMessage("战略分销伙伴"),
    "vAcctAgentWithdrawable": m19,
    "vPayLocalExpiryTitle": MessageLookupByLibrary.simpleMessage("付款时限已到"),
    "vPayLocalExpiryDesc": MessageLookupByLibrary.simpleMessage("请勿继续转账。正在等待服务器确认最终状态；若已付款，请提交交易号核实已付资金。"),
    "vAcctPendingTitle": MessageLookupByLibrary.simpleMessage("待补款订单已收金额"),
    "vAcctPendingSubtitle": MessageLookupByLibrary.simpleMessage("资金用于对应订单补付，暂不可用于其他购买。"),
    "vAcctPendingReceived": MessageLookupByLibrary.simpleMessage("已收"),
    "vAcctPendingRemaining": MessageLookupByLibrary.simpleMessage("待补"),
    "vAcctPendingTransfer": MessageLookupByLibrary.simpleMessage("等待转余额"),
    "vAcctPendingContinue": MessageLookupByLibrary.simpleMessage("继续补付"),
    "vAcctCreditError": MessageLookupByLibrary.simpleMessage("余额加载失败，请重试"),
    "vAcctBalanceSubtitle": MessageLookupByLibrary.simpleMessage(
      "购买时自动抵扣 · 待补款订单已收金额不计入可用余额",
    ),
    "vAcctBalanceTitle": m20,
    "vAcctBootFailed": MessageLookupByLibrary.simpleMessage("启动失败"),
    "vAcctBootFailedWithError": m21,
    "vAcctBuyPlan": MessageLookupByLibrary.simpleMessage("购买套餐"),
    "vAcctCheckingSubscription": MessageLookupByLibrary.simpleMessage(
      "查询订阅状态...",
    ),
    "vAcctCopySubscriptionUrl": MessageLookupByLibrary.simpleMessage("复制订阅链接"),
    "vAcctDaysLater": m22,
    "vAcctDevicesEntrySubtitle": MessageLookupByLibrary.simpleMessage(
      "管理已登录的设备",
    ),
    "vAcctDevicesLimitHint": MessageLookupByLibrary.simpleMessage(
      "超出设备上限时, 登录新设备会自动登出最早活跃的那台",
    ),
    "vAcctDevicesRegistered": m23,
    "vAcctDevicesRegisteredNoMax": m24,
    "vAcctDevicesUnavailable": MessageLookupByLibrary.simpleMessage("设备列表暂不可用"),
    "vAcctEmailUnverified": MessageLookupByLibrary.simpleMessage(
      "邮箱未验证 (找回密码用)",
    ),
    "vAcctEmailVerified": MessageLookupByLibrary.simpleMessage("邮箱已验证"),
    "vAcctExpired": MessageLookupByLibrary.simpleMessage("已过期"),
    "vAcctExpiresOn": m25,
    "vAcctGrantActive": MessageLookupByLibrary.simpleMessage("活跃中"),
    "vAcctGrantExhausted": MessageLookupByLibrary.simpleMessage("已用尽"),
    "vAcctHoursLater": m26,
    "vAcctLogout": MessageLookupByLibrary.simpleMessage("登出"),
    "vAcctLogoutDevice": MessageLookupByLibrary.simpleMessage("登出此设备"),
    "vAcctLogoutDeviceContent": m27,
    "vAcctLogoutDeviceTitle": MessageLookupByLibrary.simpleMessage("登出此设备?"),
    "vAcctLogoutFailed": m28,
    "vAcctMinutesLater": m29,
    "vAcctMultiPlanBadge": MessageLookupByLibrary.simpleMessage("多套餐"),
    "vAcctMyDevices": MessageLookupByLibrary.simpleMessage("我的设备"),
    "vAcctNoDevices": MessageLookupByLibrary.simpleMessage("暂无登记设备"),
    "vAcctNoOrders": MessageLookupByLibrary.simpleMessage("暂无订单"),
    "vAcctNoSubscription": MessageLookupByLibrary.simpleMessage("暂无订阅"),
    "vAcctNoSubscriptionDesc": MessageLookupByLibrary.simpleMessage(
      "购买套餐后即可使用 Verstro VPN.",
    ),
    "vAcctOrderFailed": MessageLookupByLibrary.simpleMessage("失败"),
    "vAcctOrderHistory": MessageLookupByLibrary.simpleMessage("订单历史"),
    "vAcctOrderHistorySubtitle": MessageLookupByLibrary.simpleMessage(
      "查看历史订单与付款记录",
    ),
    "vAcctOrderPaid": MessageLookupByLibrary.simpleMessage("已支付"),
    "vAcctOrderWaiting": MessageLookupByLibrary.simpleMessage("等待付款"),
    "vAcctOrdersQueryFailed": m30,
    "vAcctPageTitle": MessageLookupByLibrary.simpleMessage("我的账号"),
    "vAcctPlanDetails": MessageLookupByLibrary.simpleMessage("套餐明细"),
    "vAcctPlanLabel": MessageLookupByLibrary.simpleMessage("套餐"),
    "vAcctPlanPremiumMonthly": MessageLookupByLibrary.simpleMessage("专业·月付"),
    "vAcctPlanPremiumQuarterly": MessageLookupByLibrary.simpleMessage("专业·季付"),
    "vAcctPlanPremiumYearly": MessageLookupByLibrary.simpleMessage("专业·年付"),
    "vAcctPlanStandardMonthly": MessageLookupByLibrary.simpleMessage("标准·月付"),
    "vAcctPlanStandardQuarterly": MessageLookupByLibrary.simpleMessage("标准·季付"),
    "vAcctPlanStandardYearly": MessageLookupByLibrary.simpleMessage("标准·年付"),
    "vAcctRefresh": MessageLookupByLibrary.simpleMessage("刷新"),
    "vAcctRemainingBytes": m31,
    "vAcctRemainingLabel": MessageLookupByLibrary.simpleMessage("剩余"),
    "vAcctRenewUpgrade": MessageLookupByLibrary.simpleMessage("续费 / 升级套餐"),
    "vAcctRepurchase": MessageLookupByLibrary.simpleMessage("重新购买"),
    "vAcctRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "vAcctSubActive": MessageLookupByLibrary.simpleMessage("订阅有效中"),
    "vAcctSubExpired": MessageLookupByLibrary.simpleMessage("订阅已过期"),
    "vAcctSubQueryFailed": MessageLookupByLibrary.simpleMessage("订阅状态查询失败"),
    "vAcctSubQueryFailedTitle": MessageLookupByLibrary.simpleMessage("订阅查询失败"),
    "vAcctSubscriptionUrlCopied": MessageLookupByLibrary.simpleMessage(
      "已复制订阅链接",
    ),
    "vAcctSubscriptionUrlDesc": MessageLookupByLibrary.simpleMessage(
      "可复制到 Shadowrocket 等第三方客户端导入使用 (例如 iOS 设备).",
    ),
    "vAcctSubscriptionUrlLabel": MessageLookupByLibrary.simpleMessage("订阅链接"),
    "vAcctTapToContinuePayment": MessageLookupByLibrary.simpleMessage("点击继续付款"),
    "vAcctTapToReorder": MessageLookupByLibrary.simpleMessage("点击重新下单"),
    "vAcctThisDevice": MessageLookupByLibrary.simpleMessage("本机"),
    "vAcctTotalRemainingLabel": MessageLookupByLibrary.simpleMessage("总剩余"),
    "vAcctTrafficLimitLabel": MessageLookupByLibrary.simpleMessage("流量上限"),
    "vAcctTrafficNearLimit": MessageLookupByLibrary.simpleMessage(
      "流量即将用尽, 建议升级套餐",
    ),
    "vAcctTrafficUsage": MessageLookupByLibrary.simpleMessage("流量使用"),
    "vAcctTryLater": MessageLookupByLibrary.simpleMessage("稍后再试"),
    "vAcctUnknownDevice": MessageLookupByLibrary.simpleMessage("未知设备"),
    "vAcctVerifyCodeSentDesc": m32,
    "vAcctVerifyEmailTitle": MessageLookupByLibrary.simpleMessage("验证邮箱"),
    "vAgentAvailable": m33,
    "vAgentChangePrice": MessageLookupByLibrary.simpleMessage("改价"),
    "vAgentCopyInviteCode": MessageLookupByLibrary.simpleMessage("复制邀请码"),
    "vAgentCopyShareText": MessageLookupByLibrary.simpleMessage("复制分享文案"),
    "vAgentCopyTxid": MessageLookupByLibrary.simpleMessage("复制 txid"),
    "vAgentDestLine": m34,
    "vAgentInviteCode": MessageLookupByLibrary.simpleMessage("邀请码"),
    "vAgentInviteCodeCopied": MessageLookupByLibrary.simpleMessage("已复制邀请码"),
    "vAgentInvitedCount": m35,
    "vAgentLoadFailed": MessageLookupByLibrary.simpleMessage("加载失败"),
    "vAgentMinimumSaleLine": m36,
    "vAgentNextStep": MessageLookupByLibrary.simpleMessage("下一步"),
    "vAgentOpenBrowserFailed": MessageLookupByLibrary.simpleMessage(
      "无法打开浏览器, 请手动到 tronscan.org 查询该交易",
    ),
    "vAgentPaid": m37,
    "vAgentPanelTitle": MessageLookupByLibrary.simpleMessage("推广中心"),
    "vAgentPayoutAddrInvalid": MessageLookupByLibrary.simpleMessage(
      "请输入有效 TRC20 地址",
    ),
    "vAgentPayoutAddrLabel": MessageLookupByLibrary.simpleMessage(
      "TRC20 地址 (T 开头, 34 位)",
    ),
    "vAgentPayoutBelowMin": m38,
    "vAgentPayoutButton": MessageLookupByLibrary.simpleMessage("提现到 TRC20"),
    "vAgentPayoutConfirm": MessageLookupByLibrary.simpleMessage("确认提现"),
    "vAgentPayoutConfirmContent": m39,
    "vAgentPayoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "提现到 TRC20 地址",
    ),
    "vAgentPayoutFailed": MessageLookupByLibrary.simpleMessage("提现失败，请重试"),
    "vAgentPayoutGuardProcessing": MessageLookupByLibrary.simpleMessage(
      "有一笔提现正在处理中，完成后可再次发起",
    ),
    "vAgentPayoutHistory": MessageLookupByLibrary.simpleMessage("提现记录"),
    "vAgentPayoutInProgress": MessageLookupByLibrary.simpleMessage(
      "已有一笔提现正在处理中，完成后才能再次发起",
    ),
    "vAgentPayoutInvalidDest": MessageLookupByLibrary.simpleMessage(
      "收款地址无效，请检查 TRC20 地址",
    ),
    "vAgentPayoutRefundedDesc": MessageLookupByLibrary.simpleMessage(
      "打款未成功，金额已退回可提现余额",
    ),
    "vAgentPayoutSubmitted": MessageLookupByLibrary.simpleMessage(
      "提现申请已提交，等待人工打款（通常 24 小时内）",
    ),
    "vAgentPayoutThinkAgain": MessageLookupByLibrary.simpleMessage("再想想"),
    "vAgentPayoutThreshold": m40,
    "vAgentPending": m41,
    "vAgentPlanPricing": MessageLookupByLibrary.simpleMessage("套餐定价"),
    "vAgentPlanTitle": m42,
    "vAgentPlatformFloorLine": m43,
    "vAgentPriceLabel": MessageLookupByLibrary.simpleMessage("售价 (USD)"),
    "vAgentPriceNotNumber": MessageLookupByLibrary.simpleMessage("请输入数字"),
    "vAgentPriceOutOfRange": m44,
    "vAgentPriceRangeHint": m45,
    "vAgentPriceSetFailed": MessageLookupByLibrary.simpleMessage("设价失败，请重试"),
    "vAgentPriceSetSuccess": m46,
    "vAgentPriceUnset": m47,
    "vAgentProcessing": m48,
    "vAgentRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "vAgentSetPriceTitle": m49,
    "vAgentSharePoster": MessageLookupByLibrary.simpleMessage("分享海报"),
    "vAgentShareText": m50,
    "vAgentShareTextCopied": MessageLookupByLibrary.simpleMessage("分享文案已复制"),
    "vAgentStatusProcessing": MessageLookupByLibrary.simpleMessage("人工打款中"),
    "vAgentStatusRefunded": MessageLookupByLibrary.simpleMessage("已退回"),
    "vAgentStatusSent": MessageLookupByLibrary.simpleMessage("已打款"),
    "vAgentSubAgentLine": m51,
    "vAgentTierMaster": MessageLookupByLibrary.simpleMessage("战略分销伙伴"),
    "vAgentTierPromoter": MessageLookupByLibrary.simpleMessage("推广员"),
    "vAgentTierReseller": MessageLookupByLibrary.simpleMessage("认证分销伙伴"),
    "vAgentTxidCopied": MessageLookupByLibrary.simpleMessage("已复制 txid"),
    "vAgentViewOnTronScan": MessageLookupByLibrary.simpleMessage(
      "在 TronScan 查看",
    ),
    "vAgentWalletTitle": MessageLookupByLibrary.simpleMessage("佣金钱包"),
    "vAgentYourPriceLine": m52,
    "vApiBadRequest": MessageLookupByLibrary.simpleMessage("请求参数错误"),
    "vApiConflict": MessageLookupByLibrary.simpleMessage("操作冲突"),
    "vApiConnectFailed": m53,
    "vApiEmailTaken": MessageLookupByLibrary.simpleMessage("该邮箱已注册"),
    "vApiForbidden": MessageLookupByLibrary.simpleMessage("无权限"),
    "vApiInvalidCredentials": MessageLookupByLibrary.simpleMessage("邮箱或密码错误"),
    "vApiNoActiveBackend": MessageLookupByLibrary.simpleMessage(
      "所有备用域名都无法连接，检查网络",
    ),
    "vApiNotFound": MessageLookupByLibrary.simpleMessage("资源不存在"),
    "vApiNotLoggedIn": MessageLookupByLibrary.simpleMessage("未登录或会话过期"),
    "vApiRequestCancelled": MessageLookupByLibrary.simpleMessage("请求已取消"),
    "vApiRequestTimeout": MessageLookupByLibrary.simpleMessage(
      "请求超时，检查网络或 VPN",
    ),
    "vApiServerError": MessageLookupByLibrary.simpleMessage("服务端错误，请稍后重试"),
    "vApiServerErrorStatus": m54,
    "vApiTlsCertError": m55,
    "vApiTokenExpired": MessageLookupByLibrary.simpleMessage("登录会话已过期，请重新登录"),
    "vApiTokenInvalid": MessageLookupByLibrary.simpleMessage("登录凭证无效"),
    "vApiUnauthorized": MessageLookupByLibrary.simpleMessage("未授权"),
    "vApiUnexpectedResponseType": m56,
    "vApiUnexpectedStatus": m57,
    "vAppCountryAu": MessageLookupByLibrary.simpleMessage("澳大利亚"),
    "vAppCountryCa": MessageLookupByLibrary.simpleMessage("加拿大"),
    "vAppCountryCn": MessageLookupByLibrary.simpleMessage("中国"),
    "vAppCountryDe": MessageLookupByLibrary.simpleMessage("德国"),
    "vAppCountryFr": MessageLookupByLibrary.simpleMessage("法国"),
    "vAppCountryGb": MessageLookupByLibrary.simpleMessage("英国"),
    "vAppCountryHk": MessageLookupByLibrary.simpleMessage("香港"),
    "vAppCountryId": MessageLookupByLibrary.simpleMessage("印尼"),
    "vAppCountryIn": MessageLookupByLibrary.simpleMessage("印度"),
    "vAppCountryJp": MessageLookupByLibrary.simpleMessage("日本"),
    "vAppCountryKr": MessageLookupByLibrary.simpleMessage("韩国"),
    "vAppCountryMo": MessageLookupByLibrary.simpleMessage("澳门"),
    "vAppCountryMy": MessageLookupByLibrary.simpleMessage("马来西亚"),
    "vAppCountryNl": MessageLookupByLibrary.simpleMessage("荷兰"),
    "vAppCountryPh": MessageLookupByLibrary.simpleMessage("菲律宾"),
    "vAppCountryRu": MessageLookupByLibrary.simpleMessage("俄罗斯"),
    "vAppCountrySg": MessageLookupByLibrary.simpleMessage("新加坡"),
    "vAppCountryTh": MessageLookupByLibrary.simpleMessage("泰国"),
    "vAppCountryTr": MessageLookupByLibrary.simpleMessage("土耳其"),
    "vAppCountryTw": MessageLookupByLibrary.simpleMessage("台湾"),
    "vAppCountryUs": MessageLookupByLibrary.simpleMessage("美国"),
    "vAppCountryVn": MessageLookupByLibrary.simpleMessage("越南"),
    "vAppLogout": MessageLookupByLibrary.simpleMessage("退出登录"),
    "vAppLogoutConfirm": MessageLookupByLibrary.simpleMessage("确定要退出当前账号吗？"),
    "vAppModeGlobal": MessageLookupByLibrary.simpleMessage("全局代理"),
    "vAppModeRule": MessageLookupByLibrary.simpleMessage("智能分流"),
    "vAppProfilesSyncingTip": MessageLookupByLibrary.simpleMessage(
      "正在同步订阅…若长时间为空，请到「账户」页下拉刷新或重新登录",
    ),
    "vAppShareSubtitle": MessageLookupByLibrary.simpleMessage("邀请好友，你我都有奖励"),
    "vAppShareTitle": MessageLookupByLibrary.simpleMessage("分享 Verstro"),
    "vAuthBackToLogin": MessageLookupByLibrary.simpleMessage("返回登录"),
    "vAuthCodeHint": MessageLookupByLibrary.simpleMessage("6 位数字"),
    "vAuthCodeLabel": MessageLookupByLibrary.simpleMessage("验证码"),
    "vAuthCodeRequired": MessageLookupByLibrary.simpleMessage("请输入验证码"),
    "vAuthCodeResent": MessageLookupByLibrary.simpleMessage("验证码已重新发送, 请查收邮箱"),
    "vAuthCodeSent": MessageLookupByLibrary.simpleMessage("验证码已发送, 请查收邮箱"),
    "vAuthConfirmNewPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "确认新密码",
    ),
    "vAuthConfirmNewPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "请再次输入新密码",
    ),
    "vAuthConfirmPasswordLabel": MessageLookupByLibrary.simpleMessage("确认密码"),
    "vAuthConfirmPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "请再次输入密码",
    ),
    "vAuthEmailInvalid": MessageLookupByLibrary.simpleMessage("邮箱格式不对"),
    "vAuthEmailLabel": MessageLookupByLibrary.simpleMessage("邮箱"),
    "vAuthEmailRequired": MessageLookupByLibrary.simpleMessage("请填邮箱"),
    "vAuthEmailVerified": MessageLookupByLibrary.simpleMessage("邮箱已验证 ✓"),
    "vAuthForgotIntro": MessageLookupByLibrary.simpleMessage(
      "输入你的注册邮箱, 我们会发送 6 位验证码（10 分钟内有效）.",
    ),
    "vAuthForgotPasswordLink": MessageLookupByLibrary.simpleMessage("忘记密码?"),
    "vAuthForgotPasswordTitle": MessageLookupByLibrary.simpleMessage("忘记密码"),
    "vAuthGoToLogin": MessageLookupByLibrary.simpleMessage("已有账号? 直接登录"),
    "vAuthGoToRegister": MessageLookupByLibrary.simpleMessage("没有账号? 立即注册"),
    "vAuthLoginButton": MessageLookupByLibrary.simpleMessage("登录"),
    "vAuthLoginFailed": m58,
    "vAuthLoginTitle": MessageLookupByLibrary.simpleMessage("登录 Verstro"),
    "vAuthNewPasswordLabelMin8": MessageLookupByLibrary.simpleMessage(
      "新密码 (≥ 8 位)",
    ),
    "vAuthNewPasswordRequired": MessageLookupByLibrary.simpleMessage("请填新密码"),
    "vAuthPasswordLabelMin6": MessageLookupByLibrary.simpleMessage(
      "密码 (≥ 6 位)",
    ),
    "vAuthPasswordMin6": MessageLookupByLibrary.simpleMessage("密码至少 6 位"),
    "vAuthPasswordMin8": MessageLookupByLibrary.simpleMessage("密码至少 8 位"),
    "vAuthPasswordMismatch": MessageLookupByLibrary.simpleMessage("两次密码不一致"),
    "vAuthPasswordRequired": MessageLookupByLibrary.simpleMessage("请填密码"),
    "vAuthPasswordResetDone": MessageLookupByLibrary.simpleMessage("密码已重置"),
    "vAuthReferralCodeLabel": MessageLookupByLibrary.simpleMessage("推荐码（可选）"),
    "vAuthRegisterButton": MessageLookupByLibrary.simpleMessage("注册"),
    "vAuthRegisterFailed": m59,
    "vAuthRegisterIntro": MessageLookupByLibrary.simpleMessage(
      "免费注册. 邮箱仅用于找回密码 + 支付通知, 不强制验证.",
    ),
    "vAuthRegisterTitle": MessageLookupByLibrary.simpleMessage("注册 Verstro"),
    "vAuthResendCodeButton": MessageLookupByLibrary.simpleMessage("重新发送验证码"),
    "vAuthResendCodeLink": MessageLookupByLibrary.simpleMessage("没收到? 重新发送验证码"),
    "vAuthResendCooldown": m60,
    "vAuthResetFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "重置失败, 请检查网络后重试",
    ),
    "vAuthResetIntro": m61,
    "vAuthResetPasswordTitle": MessageLookupByLibrary.simpleMessage("重置密码"),
    "vAuthResetSuccessDesc": MessageLookupByLibrary.simpleMessage(
      "即将跳回登录页, 请用新密码登录.",
    ),
    "vAuthResetSuccessTitle": MessageLookupByLibrary.simpleMessage("重置成功"),
    "vAuthSendCodeButton": MessageLookupByLibrary.simpleMessage("发送验证码"),
    "vAuthSendFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "发送失败, 请检查网络或稍后重试",
    ),
    "vAuthSendFailedRetry": MessageLookupByLibrary.simpleMessage("发送失败, 请稍后重试"),
    "vAuthVerifyButton": MessageLookupByLibrary.simpleMessage("验证"),
    "vAuthVerifyFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "验证失败, 请检查网络后重试",
    ),
    "vCardActivationCode": MessageLookupByLibrary.simpleMessage("激活码"),
    "vCardCashBackedApplied": MessageLookupByLibrary.simpleMessage("现金支持余额抵扣"),
    "vCardCashDue": MessageLookupByLibrary.simpleMessage("本次应付"),
    "vCardClaimSubmit": MessageLookupByLibrary.simpleMessage("提交核验"),
    "vCardClaimTitle": MessageLookupByLibrary.simpleMessage("我已付款 / 提交交易哈希"),
    "vCardConfirmRedeem": MessageLookupByLibrary.simpleMessage("确认兑换"),
    "vCardCopyAddress": MessageLookupByLibrary.simpleMessage("复制地址"),
    "vCardCopyAmount": MessageLookupByLibrary.simpleMessage("复制金额"),
    "vCardCreateOrder": MessageLookupByLibrary.simpleMessage("确认并创建订单"),
    "vCardDecrease": MessageLookupByLibrary.simpleMessage("减少数量"),
    "vCardEmailCode": MessageLookupByLibrary.simpleMessage("邮箱验证码"),
    "vCardEntrySubtitle": MessageLookupByLibrary.simpleMessage(
      "购买、分发、查看或兑换会员卡激活码",
    ),
    "vCardEntryTitle": MessageLookupByLibrary.simpleMessage("会员卡与激活码"),
    "vCardErrExportUnavailable": MessageLookupByLibrary.simpleMessage(
      "会员卡导出当前不可用。",
    ),
    "vCardErrOpenOrderLimit": MessageLookupByLibrary.simpleMessage(
      "待付款会员卡订单已达上限，请先处理现有订单。",
    ),
    "vCardErrPreviewConsumed": MessageLookupByLibrary.simpleMessage(
      "该兑换预览已使用，请勿重复提交。",
    ),
    "vCardErrPreviewExpired": MessageLookupByLibrary.simpleMessage(
      "兑换预览已过期，请重新输入激活码。",
    ),
    "vCardErrQuoteChanged": MessageLookupByLibrary.simpleMessage(
      "报价已更新，请重新获取报价后确认。",
    ),
    "vCardErrRedemptionFrozen": MessageLookupByLibrary.simpleMessage(
      "会员卡兑换暂时冻结，请稍后再试。",
    ),
    "vCardErrRevealAuth": MessageLookupByLibrary.simpleMessage(
      "查看完整激活码前需先验证已绑定邮箱。",
    ),
    "vCardErrRevealExpired": MessageLookupByLibrary.simpleMessage(
      "本次查看授权已失效，请重新验证。",
    ),
    "vCardErrScheduleChanged": MessageLookupByLibrary.simpleMessage(
      "权益排期已变化，请重新预览后确认。",
    ),
    "vCardErrUnavailable": MessageLookupByLibrary.simpleMessage(
      "该会员卡当前不可查看或不可操作。",
    ),
    "vCardErrWholesaleSelf": MessageLookupByLibrary.simpleMessage(
      "批发库存卡不能由购买者本人兑换，请分发给最终用户。",
    ),
    "vCardGenericError": MessageLookupByLibrary.simpleMessage("会员卡操作失败，请稍后重试。"),
    "vCardGetQuote": MessageLookupByLibrary.simpleMessage("获取报价"),
    "vCardGoodsTotal": MessageLookupByLibrary.simpleMessage("会员卡价格"),
    "vCardIncrease": MessageLookupByLibrary.simpleMessage("增加数量"),
    "vCardInventoryDescription": MessageLookupByLibrary.simpleMessage(
      "默认只显示掩码。完整码仅在 App 内存中短暂展示，离开页面或进入后台会立即清除。",
    ),
    "vCardInventoryEmpty": MessageLookupByLibrary.simpleMessage(
      "暂无会员卡库存。付款并发卡成功后会显示在这里。",
    ),
    "vCardInventoryTab": MessageLookupByLibrary.simpleMessage("库存"),
    "vCardIssuedDescription": m62,
    "vCardIssuedTitle": MessageLookupByLibrary.simpleMessage("会员卡已发放"),
    "vCardIssuing": MessageLookupByLibrary.simpleMessage("付款已确认，正在安全发卡…"),
    "vCardListTotal": MessageLookupByLibrary.simpleMessage("目录原价"),
    "vCardMarketDescription": MessageLookupByLibrary.simpleMessage(
      "可混合选择多个套餐。普通用户 1–9 张按原价，10 张起按原价 70%；正式代理直接使用既有成本档位，不叠加批量折扣。最终价格以服务端报价为准。",
    ),
    "vCardMarketTab": MessageLookupByLibrary.simpleMessage("购卡"),
    "vCardNeedQuantity": MessageLookupByLibrary.simpleMessage("请至少选择一张会员卡。"),
    "vCardOrderExpired": MessageLookupByLibrary.simpleMessage(
      "订单已过期，请返回重新下单；迟到款项按现有资金规则处理。",
    ),
    "vCardOrderPollFailed": MessageLookupByLibrary.simpleMessage(
      "状态查询暂时失败，App 会继续重试。",
    ),
    "vCardOrderState": m63,
    "vCardOrderTitle": m64,
    "vCardPaymentWarning": MessageLookupByLibrary.simpleMessage(
      "必须使用 USDT-TRC20 并按页面显示的精确金额转账；交易所手续费需另付，实际到账不能少。",
    ),
    "vCardPlanMeta": m65,
    "vCardPreviewRedeem": MessageLookupByLibrary.simpleMessage("预览兑换"),
    "vCardPriceBulkRetail": m66,
    "vCardPriceMaster": m67,
    "vCardPricePromoter": m68,
    "vCardPriceReseller": m69,
    "vCardPriceRetail": m70,
    "vCardQuantity": MessageLookupByLibrary.simpleMessage("数量"),
    "vCardQuoting": MessageLookupByLibrary.simpleMessage("正在获取报价…"),
    "vCardRedeemDescription": MessageLookupByLibrary.simpleMessage(
      "先预览套餐和生效时间，再确认兑换；确认步骤不会再次上传完整激活码。",
    ),
    "vCardRedeemImmediate": MessageLookupByLibrary.simpleMessage("该权益确认后立即生效。"),
    "vCardRedeemScheduled": m71,
    "vCardRedeemSuccess": MessageLookupByLibrary.simpleMessage(
      "兑换已接受，权益时间线已更新。",
    ),
    "vCardRedeemTab": MessageLookupByLibrary.simpleMessage("兑换"),
    "vCardRevealAction": MessageLookupByLibrary.simpleMessage("查看完整码"),
    "vCardRevealContinue": MessageLookupByLibrary.simpleMessage("理解风险并继续"),
    "vCardRevealIrreversible": MessageLookupByLibrary.simpleMessage(
      "完整激活码一旦查看，即视为已交付且不再支持退款。请仅在准备安全保存或分发时继续。",
    ),
    "vCardRevealTitle": MessageLookupByLibrary.simpleMessage("查看完整激活码"),
    "vCardRevealVerifyHint": MessageLookupByLibrary.simpleMessage(
      "6 位验证码已发送到已验证邮箱",
    ),
    "vCardRevealVerifyTitle": MessageLookupByLibrary.simpleMessage("验证邮箱后查看"),
    "vCardServerQuote": MessageLookupByLibrary.simpleMessage("服务端报价"),
    "vCardShareExplicit": MessageLookupByLibrary.simpleMessage("明确分享"),
    "vCardShareExplicitDone": MessageLookupByLibrary.simpleMessage(
      "完整激活码已复制，请通过可信渠道分发。",
    ),
    "vCardStatusActivationPending": MessageLookupByLibrary.simpleMessage("待激活"),
    "vCardStatusActive": MessageLookupByLibrary.simpleMessage("生效中"),
    "vCardStatusAvailable": MessageLookupByLibrary.simpleMessage("可用"),
    "vCardStatusExpired": MessageLookupByLibrary.simpleMessage("已过期"),
    "vCardStatusFailed": MessageLookupByLibrary.simpleMessage("失败"),
    "vCardStatusNotStarted": MessageLookupByLibrary.simpleMessage("待发卡"),
    "vCardStatusPaid": MessageLookupByLibrary.simpleMessage("已付款"),
    "vCardStatusPaused": MessageLookupByLibrary.simpleMessage("已暂停"),
    "vCardStatusProcessing": MessageLookupByLibrary.simpleMessage("处理中"),
    "vCardStatusRedeemed": MessageLookupByLibrary.simpleMessage("已兑换"),
    "vCardStatusRevoked": MessageLookupByLibrary.simpleMessage("已撤销"),
    "vCardStatusScheduled": MessageLookupByLibrary.simpleMessage("已排期"),
    "vCardStatusSucceeded": MessageLookupByLibrary.simpleMessage("已发卡"),
    "vCardStatusWaiting": MessageLookupByLibrary.simpleMessage("待付款"),
    "vCardTimelineCurrent": MessageLookupByLibrary.simpleMessage("当前权益"),
    "vCardTimelineEmpty": MessageLookupByLibrary.simpleMessage("暂无相关权益。"),
    "vCardTimelinePending": MessageLookupByLibrary.simpleMessage("后续排期"),
    "vCardTimelinePeriod": m72,
    "vCardTimelineTab": MessageLookupByLibrary.simpleMessage("权益时间线"),
    "vCardTitle": MessageLookupByLibrary.simpleMessage("会员卡中心"),
    "vCardTxHash": MessageLookupByLibrary.simpleMessage("交易哈希"),
    "vCardUnavailableBulk": MessageLookupByLibrary.simpleMessage(
      "批量购卡当前未开放；可减少数量后重新报价。",
    ),
    "vCardUnavailableSales": MessageLookupByLibrary.simpleMessage(
      "会员卡功能或销售当前未开放，请稍后再试。",
    ),
    "vCardUseCashBacked": MessageLookupByLibrary.simpleMessage(
      "使用可退款的现金支持余额抵扣",
    ),
    "vCardVerify": MessageLookupByLibrary.simpleMessage("验证"),
    "vCardViewInventory": MessageLookupByLibrary.simpleMessage("查看会员卡库存"),
    "vCardWarningWholesaleSelf": MessageLookupByLibrary.simpleMessage(
      "本单属于批发库存：购买者本人不能兑换；分发后符合既有归因条件的兑换用户会归属为购买者下线，分润仍遵循原代理规则。",
    ),
    "vCardWholesaleConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "确认批发库存规则",
    ),
    "vClaimActivated": MessageLookupByLibrary.simpleMessage("已确认，订阅已开通。"),
    "vClaimActivatedOverpay": m73,
    "vClaimAlreadyProcessed": MessageLookupByLibrary.simpleMessage(
      "该交易此前已处理，不能重复使用。若需核对，请将订单号和 TXID 私下发送至 feedback@verstro.com；不要发送密码、验证码、私钥或助记词。",
    ),
    "vClaimCreditedExpired": m74,
    "vClaimCreditedNoShortfall": m75,
    "vClaimCreditedUnderpay": m76,
    "vClaimMatchedOtherOrder": MessageLookupByLibrary.simpleMessage(
      "该交易已匹配到另一笔订单。若你没有其他订单，请将订单号和 TXID 私下发送至 feedback@verstro.com 核对；不要发送密码、验证码、私钥或助记词。",
    ),
    "vClaimNotFound": MessageLookupByLibrary.simpleMessage(
      "链上尚未找到该交易，请核对 TXID 与网络后重试；无需重复付款。",
    ),
    "vClaimPartiallyPaid": m77,
    "vClaimPendingConfirmation": MessageLookupByLibrary.simpleMessage(
      "交易尚未完成链上确认，请等待确认后重试；无需重复付款。",
    ),
    "vClaimProviderUnavailable": MessageLookupByLibrary.simpleMessage(
      "链上查询服务暂不可用，请稍后重试；无需重复付款。",
    ),
    "vClaimRejectedManual": MessageLookupByLibrary.simpleMessage(
      "该交易需要人工确认。请将订单号、注册邮箱和 TXID 私下发送至 feedback@verstro.com；不要发送密码、验证码、私钥或助记词。",
    ),
    "vClaimSplitPaymentCompleted": m78,
    "vClaimSplitPaymentCredit": m79,
    "vClaimUnsupportedTransfer": MessageLookupByLibrary.simpleMessage(
      "该交易不是可识别的 USDT TRC20 转账，无法用于此订单。",
    ),
    "vClaimVerifyFailed": MessageLookupByLibrary.simpleMessage(
      "暂时无法验证此交易，请稍后重试；无需重复付款。若持续失败，可在 @verstro_chat 公开群仅提供平台、版本、错误文字和发生时间。",
    ),
    "vClaimWrongRecipient": m80,
    "vErrCodeExpired": MessageLookupByLibrary.simpleMessage("验证码已过期，请重新获取"),
    "vErrCodeLocked": MessageLookupByLibrary.simpleMessage("尝试次数过多，请重新获取验证码"),
    "vErrCouponDisabled": MessageLookupByLibrary.simpleMessage("优惠码已停用"),
    "vErrCouponInactive": MessageLookupByLibrary.simpleMessage("优惠码未开始或已过期"),
    "vErrCouponInvalid": MessageLookupByLibrary.simpleMessage("无效优惠码"),
    "vErrCouponLimitReached": MessageLookupByLibrary.simpleMessage("已达每人使用上限"),
    "vErrCouponNewUsersOnly": MessageLookupByLibrary.simpleMessage("仅限新用户"),
    "vErrCouponPartnerPriceConflict": MessageLookupByLibrary.simpleMessage(
      "合作伙伴专属价不可与平台优惠码叠加",
    ),
    "vErrCouponPlanMismatch": MessageLookupByLibrary.simpleMessage("优惠码不适用本套餐"),
    "vErrCouponSoldOut": MessageLookupByLibrary.simpleMessage("优惠码已抢光"),
    "vErrDuplicateCode": MessageLookupByLibrary.simpleMessage("优惠码已存在"),
    "vErrEmailUnverified": MessageLookupByLibrary.simpleMessage("请先验证邮箱再领取试用"),
    "vErrHasSubscription": MessageLookupByLibrary.simpleMessage("已有订阅，无需试用"),
    "vErrInvalidCode": MessageLookupByLibrary.simpleMessage("验证码错误或已失效"),
    "vErrInvalidDest": MessageLookupByLibrary.simpleMessage(
      "收款地址需为有效 TRC20 地址",
    ),
    "vErrInvalidPlan": MessageLookupByLibrary.simpleMessage("套餐不存在"),
    "vErrInvalidReferralCode": MessageLookupByLibrary.simpleMessage(
      "推荐码无效，请检查后重试",
    ),
    "vErrInvalidTxHash": MessageLookupByLibrary.simpleMessage("交易号长度异常"),
    "vErrMissingCode": MessageLookupByLibrary.simpleMessage("请输入验证码"),
    "vErrNoSubscription": MessageLookupByLibrary.simpleMessage("无订阅"),
    "vErrProvisionFailed": MessageLookupByLibrary.simpleMessage("试用开通失败，请重试"),
    "vErrSubExpired": MessageLookupByLibrary.simpleMessage("订阅已过期"),
    "vErrSubProxyDisabled": MessageLookupByLibrary.simpleMessage(
      "订阅代理未启用，暂无可重置的链接",
    ),
    "vErrTokenUsed": MessageLookupByLibrary.simpleMessage("链接已使用"),
    "vErrTrialClaimed": MessageLookupByLibrary.simpleMessage("已领取过试用"),
    "vErrTrialDisabled": MessageLookupByLibrary.simpleMessage("试用未开放"),
    "vHelpAccountBody": MessageLookupByLibrary.simpleMessage(
      "在账户页面查看订阅状态、到期时间和已登录设备。请仅在自己的设备上登录；遇到订阅或设备问题，先确认账户与网络状态。",
    ),
    "vHelpAccountTitle": MessageLookupByLibrary.simpleMessage("账户、订阅和多设备"),
    "vHelpContactBody": MessageLookupByLibrary.simpleMessage(
      "公开群只用于一般排障；请说明平台、应用版本、错误文字和发生时间。订单等敏感资料请改用私下邮件。",
    ),
    "vHelpContactTitle": MessageLookupByLibrary.simpleMessage("支持与反馈"),
    "vHelpCoverageTitle": MessageLookupByLibrary.simpleMessage("流量接管范围"),
    "vHelpDesktopCombinations": MessageLookupByLibrary.simpleMessage(
      "系统代理开启 / 虚拟网卡开启：浏览器等走系统代理，其余流量由虚拟网卡补充接管，覆盖最完整，推荐日常使用。\n\n系统代理开启 / 虚拟网卡关闭：仅覆盖遵循系统代理的软件，适合无管理员权限或只需浏览器时使用。\n\n系统代理关闭 / 虚拟网卡开启：主要依靠虚拟网卡接管整机流量，适合高级用户或排查系统代理冲突。\n\n系统代理关闭 / 虚拟网卡关闭：Verstro 不主动接管大部分系统流量，通常不建议，仅用于排障。",
    ),
    "vHelpDesktopRecommended": MessageLookupByLibrary.simpleMessage(
      "推荐日常配置：智能分流 + 系统代理开启 + 虚拟网卡开启。",
    ),
    "vHelpFaqConnectedNoEffectA": MessageLookupByLibrary.simpleMessage(
      "先检查系统代理和虚拟网卡开关、当前出站模式、节点和其他 VPN，再断开并重新连接。若仍异常，确认应用是否遵循系统代理；桌面端可开启虚拟网卡，或暂时切换全局代理排查，完成后恢复智能分流。",
    ),
    "vHelpFaqConnectedNoEffectQ": MessageLookupByLibrary.simpleMessage(
      "显示已连接，但 IP 或部分应用没有变化怎么办？",
    ),
    "vHelpFaqDisableTunA": MessageLookupByLibrary.simpleMessage(
      "当虚拟网卡与其他 VPN、代理或安全软件冲突、睡眠恢复异常，或只需要浏览器代理时，可暂时关闭虚拟网卡，并保留系统代理。确认问题后重新开启虚拟网卡以恢复完整覆盖。",
    ),
    "vHelpFaqDisableTunQ": MessageLookupByLibrary.simpleMessage(
      "哪些情况应暂时关闭虚拟网卡？",
    ),
    "vHelpFaqGlobalCoverageA": MessageLookupByLibrary.simpleMessage(
      "不代表。全局代理只影响已经进入 Verstro 的流量；系统代理和虚拟网卡决定哪些应用或系统流量会进入。桌面端需要更完整覆盖时开启系统代理和虚拟网卡，移动端由系统 VPN 通道承担接管。",
    ),
    "vHelpFaqGlobalCoverageQ": MessageLookupByLibrary.simpleMessage(
      "全局代理是否代表整台设备都会走代理？",
    ),
    "vHelpFaqMobileTogglesA": MessageLookupByLibrary.simpleMessage(
      "Android 和 iOS 通过系统 VPN 通道接管流量，不使用桌面端的这两个开关。请按系统提示授予 VPN 权限，并选择出站模式和节点。",
    ),
    "vHelpFaqMobileTogglesQ": MessageLookupByLibrary.simpleMessage(
      "为什么移动端看不到系统代理和虚拟网卡？",
    ),
    "vHelpFaqModeDifferenceA": MessageLookupByLibrary.simpleMessage(
      "智能分流按规则决定直连或走节点；全局代理让已经进入 Verstro 的互联网流量统一经当前节点出站。全局代理不会自行扩大流量接管范围，日常优先使用智能分流。",
    ),
    "vHelpFaqModeDifferenceQ": MessageLookupByLibrary.simpleMessage(
      "智能分流和全局代理有什么区别？",
    ),
    "vHelpFaqProxyAndTunA": MessageLookupByLibrary.simpleMessage(
      "日常建议两者同时开启：系统代理覆盖遵循系统代理的软件，虚拟网卡补充覆盖其他应用。当虚拟网卡与其他 VPN、代理或安全软件冲突时，暂时关闭虚拟网卡并保留系统代理。无管理员权限或只需要浏览器代理时，也可仅开系统代理。",
    ),
    "vHelpFaqProxyAndTunQ": MessageLookupByLibrary.simpleMessage(
      "系统代理和虚拟网卡需要同时开启吗？",
    ),
    "vHelpFaqRestoreRecommendedA": MessageLookupByLibrary.simpleMessage(
      "桌面端选择智能分流，开启系统代理和虚拟网卡，然后断开并重新连接。移动端选择智能分流和合适节点，确认系统 VPN 权限仍已授权。",
    ),
    "vHelpFaqRestoreRecommendedQ": MessageLookupByLibrary.simpleMessage(
      "如何恢复推荐配置？",
    ),
    "vHelpFaqTitle": MessageLookupByLibrary.simpleMessage("FAQ 与故障排查"),
    "vHelpFaqTunPermissionA": MessageLookupByLibrary.simpleMessage(
      "虚拟网卡需要创建或调整系统网络接口，因此首次启用可能要求管理员授权。请只在确认是 Verstro 的系统提示中授权；Verstro 不会取得用户的账户或管理员密码。无权限时可以先仅使用系统代理。",
    ),
    "vHelpFaqTunPermissionQ": MessageLookupByLibrary.simpleMessage(
      "开启虚拟网卡为什么需要管理员权限？",
    ),
    "vHelpGlobalBody": MessageLookupByLibrary.simpleMessage(
      "让已经进入 Verstro 的互联网流量统一经当前节点出站，但保留系统地址、局域网和必要绕过项。它不会自动接管整台设备，也不一定更快；用于个别服务无法访问、统一出口 IP、开发测试或临时排障，问题解决后切回智能分流。",
    ),
    "vHelpGlobalTitle": MessageLookupByLibrary.simpleMessage("全局代理"),
    "vHelpIntro": MessageLookupByLibrary.simpleMessage(
      "出站模式决定“进入 Verstro 的流量怎么走”；系统代理与虚拟网卡决定“哪些流量会进入 Verstro”。本帮助可离线阅读。",
    ),
    "vHelpMobileVpnBody": MessageLookupByLibrary.simpleMessage(
      "Android 和 iOS 的系统 VPN 通道承担流量接管。首次连接时按系统提示授权；移动端主要选择出站模式和节点，不显示桌面端的系统代理与虚拟网卡开关。",
    ),
    "vHelpMobileVpnTitle": MessageLookupByLibrary.simpleMessage("系统 VPN 通道"),
    "vHelpNodesBody": MessageLookupByLibrary.simpleMessage(
      "优先使用自动选线以平衡延迟与可用性；如某项服务表现异常，可手动切换节点后重新连接。节点可用性会随网络环境变化。",
    ),
    "vHelpNodesTitle": MessageLookupByLibrary.simpleMessage("节点与线路"),
    "vHelpOpenLinkFailed": MessageLookupByLibrary.simpleMessage(
      "无法打开链接，请稍后重试。",
    ),
    "vHelpOutboundIntro": MessageLookupByLibrary.simpleMessage(
      "出站模式只决定已经进入 Verstro 的流量如何离开设备，不决定哪些应用或系统流量会进入 Verstro。",
    ),
    "vHelpOutboundTitle": MessageLookupByLibrary.simpleMessage("出站模式"),
    "vHelpPaymentBody": MessageLookupByLibrary.simpleMessage(
      "下单前核对套餐、金额和网络。付款时仅使用页面显示的网络和准确金额；付款后等待链上确认，异常订单请通过支持渠道并附订单信息咨询。",
    ),
    "vHelpPaymentTitle": MessageLookupByLibrary.simpleMessage("购买与付款"),
    "vHelpQuickBody": MessageLookupByLibrary.simpleMessage(
      "登录并确认订阅有效后，选择节点，保持智能分流，点击连接。需要停止时点击断开；首次使用虚拟网卡或系统 VPN 时按系统提示授权。",
    ),
    "vHelpQuickTitle": MessageLookupByLibrary.simpleMessage("快速开始"),
    "vHelpReplaySubtitle": MessageLookupByLibrary.simpleMessage(
      "重新查看连接、模式和平台说明，不会修改当前网络设置。",
    ),
    "vHelpReplayTitle": MessageLookupByLibrary.simpleMessage("重播新手引导"),
    "vHelpSmartBody": MessageLookupByLibrary.simpleMessage(
      "按规则让本地网络、局域网和适合直连的服务保持直连，需要代理的流量走节点。它通常延迟更低、更省流量，也更方便访问打印机和 NAS，推荐日常使用。",
    ),
    "vHelpSmartTitle": MessageLookupByLibrary.simpleMessage("智能分流"),
    "vHelpSystemProxyBody": MessageLookupByLibrary.simpleMessage(
      "开启后，Verstro 写入系统代理设置，浏览器等遵循系统代理的软件会进入 Verstro；关闭后它们不再经该路径进入。无需创建虚拟网卡、权限要求较低，但终端工具、Git、Docker、游戏和部分桌面应用可能忽略它。",
    ),
    "vHelpSystemProxyTitle": MessageLookupByLibrary.simpleMessage("系统代理"),
    "vHelpTitle": MessageLookupByLibrary.simpleMessage("帮助中心"),
    "vHelpTunBody": MessageLookupByLibrary.simpleMessage(
      "开启后创建虚拟网络接口，从系统网络层接管流量，可覆盖不读取系统代理的软件；关闭后不再做系统级接管，只保留系统代理或应用手动配置的路径。适合终端、Git、brew、Docker、Electron 等场景；首次开启可能需要管理员授权，并可能与其他 VPN、代理或安全软件冲突。虚拟网卡可以配合智能分流，不等于全局代理。",
    ),
    "vHelpTunTitle": MessageLookupByLibrary.simpleMessage("虚拟网卡（TUN）"),
    "vHelpUpdateBody": MessageLookupByLibrary.simpleMessage(
      "从官方渠道下载更新。安装或升级失败时确认存储空间、系统权限和安装包来源；不要使用未知来源的修改版安装包。",
    ),
    "vHelpUpdateTitle": MessageLookupByLibrary.simpleMessage("应用更新与安装帮助"),
    "vHelpWebSubtitle": MessageLookupByLibrary.simpleMessage(
      "在系统浏览器中打开官网帮助中心。",
    ),
    "vHelpWebTitle": MessageLookupByLibrary.simpleMessage("查看完整网页版帮助"),
    "vOnboardingBack": MessageLookupByLibrary.simpleMessage("上一步"),
    "vOnboardingConnectDesktopBody": MessageLookupByLibrary.simpleMessage(
      "点击主界面连接按钮开始或断开；首次可能要求系统权限。",
    ),
    "vOnboardingConnectMobileBody": MessageLookupByLibrary.simpleMessage(
      "点击主界面连接按钮开始或断开；首次连接可能要求系统 VPN 权限。",
    ),
    "vOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage("连接"),
    "vOnboardingFinish": MessageLookupByLibrary.simpleMessage("完成"),
    "vOnboardingHelpBody": MessageLookupByLibrary.simpleMessage(
      "以后可从仪表盘问号或“设置 → 帮助中心”重播。",
    ),
    "vOnboardingHelpTitle": MessageLookupByLibrary.simpleMessage("帮助"),
    "vOnboardingNext": MessageLookupByLibrary.simpleMessage("下一步"),
    "vOnboardingOpenHelp": MessageLookupByLibrary.simpleMessage("打开帮助中心"),
    "vOnboardingOutboundBody": MessageLookupByLibrary.simpleMessage(
      "日常推荐智能分流；仅在统一出口或排障时临时使用全局代理。",
    ),
    "vOnboardingSkip": MessageLookupByLibrary.simpleMessage("跳过"),
    "vPartnerAuthorizationCode": m81,
    "vPartnerCertifiedAffiliate": MessageLookupByLibrary.simpleMessage(
      "认证联盟伙伴",
    ),
    "vPartnerCertifiedReseller": MessageLookupByLibrary.simpleMessage("认证分销伙伴"),
    "vPartnerNonExclusive": MessageLookupByLibrary.simpleMessage("标准合作默认为非独家"),
    "vPartnerStrategicDistributor": MessageLookupByLibrary.simpleMessage(
      "战略分销伙伴",
    ),
    "vPartnerVerified": MessageLookupByLibrary.simpleMessage("Verstro 平台认证"),
    "vPayAddressCopied": MessageLookupByLibrary.simpleMessage("收款地址已复制"),
    "vPayAmountCopied": MessageLookupByLibrary.simpleMessage("金额已复制 (注意保留小数位)"),
    "vPayAmountMismatchNote": MessageLookupByLibrary.simpleMessage(
      "多 0.01 或少 0.01 都无法自动匹配, 请检查钱包「金额」字段是否一致到小数点后 2 位.",
    ),
    "vPayAmountMismatchNoteWithBase": m82,
    "vPayAntiCollisionSuffixLabel": MessageLookupByLibrary.simpleMessage(
      "防冲突尾数",
    ),
    "vPayBackToHome": MessageLookupByLibrary.simpleMessage("回到主页"),
    "vPayBackToReorder": MessageLookupByLibrary.simpleMessage("返回重新下单"),
    "vPayBasePriceLabel": MessageLookupByLibrary.simpleMessage("原价"),
    "vPayClaimInstruction": MessageLookupByLibrary.simpleMessage(
      "从 imToken / TronLink 等钱包复制刚才转账的 tx hash 粘贴到下方:",
    ),
    "vPayClaimNote": MessageLookupByLibrary.simpleMessage(
      "提交后客户端按链上结构化结果处理：未确认时按提示等待；部分到账可继续补付并提交下一笔 TXID；完成后自动刷新订单和订阅。",
    ),
    "vPayContactSupport": MessageLookupByLibrary.simpleMessage("用户交流群（公开）"),
    "vPayContinuePaymentWithHash": MessageLookupByLibrary.simpleMessage(
      "继续提交补款 TXID",
    ),
    "vPayCopyAddress": MessageLookupByLibrary.simpleMessage("复制地址"),
    "vPayCopyAmount": MessageLookupByLibrary.simpleMessage("复制金额"),
    "vPayCountdownExpired": MessageLookupByLibrary.simpleMessage("已过期"),
    "vPayCouponDiscountLabel": MessageLookupByLibrary.simpleMessage("优惠码"),
    "vPayCreditAppliedLabel": MessageLookupByLibrary.simpleMessage("余额抵扣"),
    "vPayExactAmountWarning": MessageLookupByLibrary.simpleMessage("请精确转账以下金额"),
    "vPayExpiredClaimHint": MessageLookupByLibrary.simpleMessage(
      "已转账但没到账？提交交易号后，到账金额将自动存入你的账户余额。",
    ),
    "vPayFeeWarningBody": MessageLookupByLibrary.simpleMessage(
      "交易所提币会额外收取网络手续费（TRC20 常见约 1 USDT）并从提币数量中扣除，实际到账会比填写的少，导致无法自动匹配。推荐用自己的钱包直接转账（imToken / TronLink）；必须用交易所时，提币数量 = 应付金额 + 手续费，确保「到账数量」恰好等于应付金额。错额付款请提交 TXID：多付会开通并把多付部分存入账户余额；少付则到账金额全额存入余额，重新下单时自动抵扣。",
    ),
    "vPayFeeWarningTitle": MessageLookupByLibrary.simpleMessage(
      "用交易所提币付款？注意手续费",
    ),
    "vPayIHavePaid": MessageLookupByLibrary.simpleMessage("我已付款"),
    "vPayIHavePaidSubmitTx": MessageLookupByLibrary.simpleMessage(
      "我已付款（提交交易号）",
    ),
    "vPayIHavePaidWithHash": MessageLookupByLibrary.simpleMessage(
      "我已付款 (输入 tx hash 立即验证)",
    ),
    "vPayOrderExpiredDesc": m83,
    "vPayOrderExpiredTitle": MessageLookupByLibrary.simpleMessage("订单已过期"),
    "vPayOrderFooterNote": MessageLookupByLibrary.simpleMessage(
      "订单 24h 内未付款自动作废. 24h 内付款后, backend 30s 内自动匹配; 点「我已付款」可立即触发匹配.",
    ),
    "vPayOrderNumber": m84,
    "vPayOrderTitle": m85,
    "vPayPaymentConfirmed": MessageLookupByLibrary.simpleMessage("付款已确认"),
    "vPayPlanMonthly": MessageLookupByLibrary.simpleMessage("月付"),
    "vPayPlanQuarterly": MessageLookupByLibrary.simpleMessage("季付"),
    "vPayPlanYearly": MessageLookupByLibrary.simpleMessage("年付"),
    "vPayPromotionDiscountLabel": MessageLookupByLibrary.simpleMessage("促销优惠"),
    "vPayReorderWithCredit": MessageLookupByLibrary.simpleMessage(
      "重新下单（余额自动抵扣）",
    ),
    "vPayRetryInSeconds": m86,
    "vPayStatusChecking": MessageLookupByLibrary.simpleMessage("查询订单状态..."),
    "vPayStatusQueryFailed": MessageLookupByLibrary.simpleMessage("查询失败, 继续轮询"),
    "vPayStatusWaiting": MessageLookupByLibrary.simpleMessage(
      "⏳ 等待付款 ... (5 秒自动刷新)",
    ),
    "vPaySubmitFailed": m87,
    "vPaySubmitVerify": MessageLookupByLibrary.simpleMessage("提交验证"),
    "vPaySubscriptionActivated": MessageLookupByLibrary.simpleMessage("订阅已开通"),
    "vPayTelegramNotInstalled": MessageLookupByLibrary.simpleMessage(
      "无法打开 Telegram；用户交流群：@verstro_chat",
    ),
    "vPayTronAddressTitle": MessageLookupByLibrary.simpleMessage(
      "Tron USDT 地址",
    ),
    "vPayTxHashHint": MessageLookupByLibrary.simpleMessage(
      "64 字符 hex, 形如 abc1234...",
    ),
    "vPayTxHashLengthError": MessageLookupByLibrary.simpleMessage(
      "tx hash 长度异常 (应 64 字符)",
    ),
    "vPlanAccountEmail": m88,
    "vPlanBadgeBestValue": MessageLookupByLibrary.simpleMessage("最划算"),
    "vPlanBadgeRecommended": MessageLookupByLibrary.simpleMessage("推荐"),
    "vPlanCouponLabel": MessageLookupByLibrary.simpleMessage("优惠码（可选）"),
    "vPlanCreateOrderFailed": m89,
    "vPlanDurationDays": m90,
    "vPlanFeatureAutoNode": MessageLookupByLibrary.simpleMessage("自动选最快节点"),
    "vPlanFeaturePremiumNodes": MessageLookupByLibrary.simpleMessage(
      "可手动选国家 / 节点 · 含加速节点",
    ),
    "vPlanLoadFailed": m91,
    "vPlanLogout": MessageLookupByLibrary.simpleMessage("登出"),
    "vPlanMaxDevices": m92,
    "vPlanMultiDevices": MessageLookupByLibrary.simpleMessage("多设备同时使用"),
    "vPlanNameTrial": MessageLookupByLibrary.simpleMessage("试用"),
    "vPlanPartnerPriceLabel": MessageLookupByLibrary.simpleMessage("合作伙伴专属价"),
    "vPlanPartnerSalesPaused": MessageLookupByLibrary.simpleMessage(
      "合作伙伴的此套餐新购暂时不可用；历史订单和权益不受影响。",
    ),
    "vPlanPaymentMethodNote": MessageLookupByLibrary.simpleMessage(
      "支付方式: USDT-TRC20\n收款由 Verstro 自建链上接收, 不经过第三方托管",
    ),
    "vPlanPerMonthHint": m93,
    "vPlanPickThis": MessageLookupByLibrary.simpleMessage("选择此套餐"),
    "vPlanPickTitle": MessageLookupByLibrary.simpleMessage("选择套餐"),
    "vPlanPriceChanged": MessageLookupByLibrary.simpleMessage(
      "套餐价格已更新，请查看新价格并重新确认",
    ),
    "vPlanRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "vPlanTelegramSupport": MessageLookupByLibrary.simpleMessage(
      "Telegram 社群支持",
    ),
    "vPlanTierPremium": MessageLookupByLibrary.simpleMessage("专业套餐"),
    "vPlanTierPremiumDesc": MessageLookupByLibrary.simpleMessage(
      "可手动选国家 / 节点 · 含低延迟加速节点 · 更多设备",
    ),
    "vPlanTierStandard": MessageLookupByLibrary.simpleMessage("标准套餐"),
    "vPlanTierStandardDesc": MessageLookupByLibrary.simpleMessage(
      "自动选最快节点 · 够用够快",
    ),
    "vPlanTraffic": m94,
    "vPlanUnavailable": MessageLookupByLibrary.simpleMessage("暂不可购买"),
    "vPromotionApply": MessageLookupByLibrary.simpleMessage("应用优惠码"),
    "vPromotionApplying": MessageLookupByLibrary.simpleMessage("获取报价中…"),
    "vPromotionAutomaticBest": MessageLookupByLibrary.simpleMessage(
      "结算时由服务端自动应用当前可用的最佳优惠。",
    ),
    "vPromotionAvailable": MessageLookupByLibrary.simpleMessage("可用"),
    "vPromotionBadge": MessageLookupByLibrary.simpleMessage("可享优惠"),
    "vPromotionCodeHint": MessageLookupByLibrary.simpleMessage("优惠码（可选）"),
    "vPromotionDiscountRecord": m95,
    "vPromotionEmpty": MessageLookupByLibrary.simpleMessage("当前没有可展示的优惠或使用记录。"),
    "vPromotionHeld": MessageLookupByLibrary.simpleMessage("处理中"),
    "vPromotionMyEntrySubtitle": MessageLookupByLibrary.simpleMessage(
      "查看可用、已使用和已过期的优惠",
    ),
    "vPromotionMyEntryTitle": MessageLookupByLibrary.simpleMessage("我的优惠"),
    "vPromotionNoDiscount": MessageLookupByLibrary.simpleMessage("当前套餐没有额外优惠。"),
    "vPromotionPublicTitle": MessageLookupByLibrary.simpleMessage("当前优惠活动"),
    "vPromotionQuoteAfter": MessageLookupByLibrary.simpleMessage("优惠后"),
    "vPromotionQuoteBase": MessageLookupByLibrary.simpleMessage("原价"),
    "vPromotionQuoteDiscount": MessageLookupByLibrary.simpleMessage("优惠"),
    "vPromotionQuoteExpired": MessageLookupByLibrary.simpleMessage(
      "报价已过期，正在重新获取一次…",
    ),
    "vPromotionQuoteFailed": m96,
    "vPromotionReleased": MessageLookupByLibrary.simpleMessage("已释放"),
    "vPromotionTitle": MessageLookupByLibrary.simpleMessage("优惠活动"),
    "vPromotionUnavailable": MessageLookupByLibrary.simpleMessage("不可用"),
    "vPromotionUnsupported": MessageLookupByLibrary.simpleMessage(
      "当前服务版本不支持统一优惠。",
    ),
    "vPromotionUsed": MessageLookupByLibrary.simpleMessage("已使用"),
    "vShareCodeLoadFailed": MessageLookupByLibrary.simpleMessage("邀请码加载失败"),
    "vShareCopyBrief": m97,
    "vShareCopyButton": MessageLookupByLibrary.simpleMessage("复制文案"),
    "vShareCopyDev": m98,
    "vShareCopyGeneral": m99,
    "vShareCopyTitle": MessageLookupByLibrary.simpleMessage("分享文案"),
    "vShareGenerating": MessageLookupByLibrary.simpleMessage("正在生成…"),
    "vShareInviteBoth": m100,
    "vShareInvitePlain": m101,
    "vShareInvitePrefix": m102,
    "vShareInvitePrefixBrief": m103,
    "vShareInviteReferee": m104,
    "vSharePageTitle": MessageLookupByLibrary.simpleMessage("分享 Verstro"),
    "vSharePosterFeat1Desc": MessageLookupByLibrary.simpleMessage(
      "覆盖更多不读系统代理的应用",
    ),
    "vSharePosterFeat1Label": MessageLookupByLibrary.simpleMessage("系统级 TUN"),
    "vSharePosterFeat2Desc": MessageLookupByLibrary.simpleMessage(
      "支持自动选择，体验受网络影响",
    ),
    "vSharePosterFeat2Label": MessageLookupByLibrary.simpleMessage("多地节点"),
    "vSharePosterFeat3Desc": MessageLookupByLibrary.simpleMessage(
      "不记录连接内容与访问目标",
    ),
    "vSharePosterFeat3Label": MessageLookupByLibrary.simpleMessage("隐私优先"),
    "vSharePosterFeat4Label": MessageLookupByLibrary.simpleMessage("多平台"),
    "vSharePosterFileName": MessageLookupByLibrary.simpleMessage(
      "Verstro-邀请海报.png",
    ),
    "vSharePosterFooter": MessageLookupByLibrary.simpleMessage(
      "客户端 GPLv3 开源 · 行为可审计",
    ),
    "vSharePosterGenFailed": MessageLookupByLibrary.simpleMessage("生成图片失败，请重试"),
    "vSharePosterGetVerstro": MessageLookupByLibrary.simpleMessage(
      "获取 Verstro",
    ),
    "vSharePosterHeadline": MessageLookupByLibrary.simpleMessage("跨应用网络连接"),
    "vSharePosterNotReady": MessageLookupByLibrary.simpleMessage(
      "海报尚未就绪，请稍后再试",
    ),
    "vSharePosterRewardBoth": m105,
    "vSharePosterRewardNone": MessageLookupByLibrary.simpleMessage("注册时填写此邀请码"),
    "vSharePosterRewardReferee": m106,
    "vSharePosterSaved": MessageLookupByLibrary.simpleMessage("海报已保存"),
    "vSharePosterScanHint": MessageLookupByLibrary.simpleMessage("扫码下载"),
    "vSharePosterScanSite": MessageLookupByLibrary.simpleMessage(
      "扫码访问官网，下载客户端",
    ),
    "vSharePosterSubline": MessageLookupByLibrary.simpleMessage(
      "系统级 TUN · 覆盖范围受环境影响",
    ),
    "vSharePosterTagline": MessageLookupByLibrary.simpleMessage("隐私优先的全球网络"),
    "vSharePosterTrialDays": m107,
    "vSharePosterTrialGeneric": MessageLookupByLibrary.simpleMessage("支持免费试用"),
    "vSharePosterTrialLine": m108,
    "vShareSaveCanceled": MessageLookupByLibrary.simpleMessage("已取消保存"),
    "vShareSaveFailed": MessageLookupByLibrary.simpleMessage("保存失败，请重试"),
    "vShareSaveImage": MessageLookupByLibrary.simpleMessage("保存图片"),
    "vShareStyleBrief": MessageLookupByLibrary.simpleMessage("简洁"),
    "vShareStyleDeveloper": MessageLookupByLibrary.simpleMessage("开发者向"),
    "vShareStyleGeneral": MessageLookupByLibrary.simpleMessage("通用"),
    "vShareTrialGeneral": MessageLookupByLibrary.simpleMessage("新用户可免费试用。"),
    "vShareTrialGeneralDays": m109,
    "vShareTrialShort": MessageLookupByLibrary.simpleMessage("可免费试用。"),
    "vSupportCommunityTitle": MessageLookupByLibrary.simpleMessage(
      "Telegram 用户交流群",
    ),
    "vSupportFeedbackPrivacy": MessageLookupByLibrary.simpleMessage(
      "敏感资料可私下发送至 feedback@verstro.com，但仍不得发送密码、验证码、私钥或助记词。",
    ),
    "vSupportPublicGroupPrivacy": MessageLookupByLibrary.simpleMessage(
      "公开群隐私提醒：不得发送邮箱、订单号、TXID、钱包截图、卡码、订阅链接、密码、验证码、私钥或助记词；可发送平台、版本、错误文字和发生时间。",
    ),
    "vTrialActivated": MessageLookupByLibrary.simpleMessage("试用已开通！"),
    "vTrialClaimFailed": MessageLookupByLibrary.simpleMessage("领取失败，请重试"),
    "vTrialClaimNow": MessageLookupByLibrary.simpleMessage("立即领取"),
    "vTrialSpec": m110,
    "vTrialTitle": MessageLookupByLibrary.simpleMessage("免费试用"),
    "vTrialVerifyEmailHint": m111,
    "vUpdAlreadyLatest": MessageLookupByLibrary.simpleMessage("已是最新版本"),
    "vUpdChecksumFailed": MessageLookupByLibrary.simpleMessage(
      "完整性校验失败(sha256 不匹配), 已丢弃下载",
    ),
    "vUpdDownloadFailed": m112,
    "vUpdDownloadingProgress": m113,
    "vUpdExitApp": MessageLookupByLibrary.simpleMessage("退出应用"),
    "vUpdForceDesc": MessageLookupByLibrary.simpleMessage(
      "当前版本已不再受支持, 请更新后继续使用.",
    ),
    "vUpdForceTitle": m114,
    "vUpdIgnoreThisVersion": MessageLookupByLibrary.simpleMessage("忽略此版本"),
    "vUpdInstallLaunchFailed": m115,
    "vUpdLater": MessageLookupByLibrary.simpleMessage("稍后"),
    "vUpdNewVersionTitle": m116,
    "vUpdNoMatchingPackage": MessageLookupByLibrary.simpleMessage(
      "未找到适配当前设备的安装包",
    ),
    "vUpdUpdateFailed": m117,
    "vUpdUpdateNow": MessageLookupByLibrary.simpleMessage("立即更新"),
    "value": MessageLookupByLibrary.simpleMessage("值"),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("活力"),
    "view": MessageLookupByLibrary.simpleMessage("查看"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "检测到VPN相关配置改动",
    ),
    "vpnDesc": MessageLookupByLibrary.simpleMessage("修改VPN相关设置"),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "通过VpnService自动路由系统所有流量",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "为VpnService附加HTTP代理",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage("重启VPN后改变生效"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage("WebDAV配置"),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("白名单模式"),
    "years": MessageLookupByLibrary.simpleMessage("年"),
    "yearsAgo": m118,
    "zh_CN": MessageLookupByLibrary.simpleMessage("中文简体"),
  };
}
