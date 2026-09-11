import Foundation
import Libbox

// Phase E 诊断: app 进程把命令客户端行为 append 到 App Group 文件 (devicectl 拉). 与扩展的
// verstro-ext.log 分开成 verstro-app.log 避免交叉. NSLog 进不了 idevicesyslog 故用文件.
private let appLogQueue = DispatchQueue(label: "com.verstro.app.applog")
func appLog(_ message: String) {
    appLogQueue.async {
        guard let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.verstro.app") else { return }
        let url = dir.appendingPathComponent("verstro-app.log")
        let line = "\(Date().timeIntervalSince1970) \(message)\n"
        guard let data = line.data(using: .utf8) else { return }
        if let h = try? FileHandle(forWritingTo: url) { h.seekToEndOfFile(); h.write(data); try? h.close() }
        else { try? data.write(to: url, options: .atomic) }
    }
}

// 流式 libbox CommandClient (Phase C-2): 持久连扩展的 CommandServer, 订阅 Status (流量/内存) 与
// Group (代理列表), 实现 LibboxCommandClientHandler 缓存最新值, 供 Flutter 一次性查询
// (getProxies/getTraffic/getMemory). 把 libbox OutboundGroup 映射成 FlClash 期望的 mihomo
// /proxies 形态 {proxies:{name:{type,now,all,history}}, all:[...]}.
// 注: socket 路径由 VPNManager 的 LibboxSetup 设. 运行时正确性 (是否真填充/映射对) 需真机验.
final class CommandClientBridge: NSObject, LibboxCommandClientHandlerProtocol {
    static let shared = CommandClientBridge()

    private var statusClient: LibboxCommandClient?
    private var groupClient: LibboxCommandClient?
    private var started = false
    private let lock = NSLock()

    // 首个 group 推送到达的栅栏: proxies() 首调阻塞等它, 对冲 Dart 侧 retry(3,立即,无延迟)
    // 可能全部落在首个 writeGroups 之前 (流式异步 vs 同步查询的阻抗失配).
    private var groupReceived = false
    private let groupReady = DispatchSemaphore(value: 0)

    // 延迟测试 (Phase E): libbox 只有组级 URLTest, 单节点延迟从 group 流的 item.urlTestDelay 回来.
    // testDelay 触发组 URLTest(去重) 后轮询本表. delayLock 保护跨线程访问 (writeGroups 写/testDelay 读).
    private let delayLock = NSLock()
    private var itemDelays: [String: Int] = [:]   // 节点 tag → 延迟 ms (nil=待测, 0=超时)
    private var itemGroup: [String: String] = [:] // 节点 tag → 所属组 tag
    private var lastURLTestAt: TimeInterval = 0

    // 缓存 (writeStatus / writeGroups 回调里更新)
    private var uplink: Int64 = 0
    private var downlink: Int64 = 0
    private var uplinkTotal: Int64 = 0
    private var downlinkTotal: Int64 = 0
    private var memoryBytes: Int64 = 0
    private var proxiesJSONString = "{\"proxies\":{},\"all\":[]}"

    // 懒启动: 首次查询时连 (此时隧道应已起, CommandServer 可用).
    // ⚠️ 关键: 创建 LibboxNewCommandClient 前必须让本进程 LibboxSetup 跑过 —— libbox 的
    // dialTarget() 用全局 sBasePath 拼 "<basePath>/command.sock" 去连扩展的 CommandServer;
    // sBasePath 由 LibboxSetup 设. app 进程过去只在一次性命令 (selectOutbound 等) 路径里
    // ensureLibboxSetup, 而那条路在代理 tab 出来前不可达 → 流式 client 用空 basePath 拨错
    // socket → 永远连不上 → groups 空 → 代理 tab 隐藏. 这里补调修复 (见 docs Phase E 调试).
    func ensureStarted() {
        // ⚠️ 死锁防护 (Phase E 真机实测根因): 命令客户端绝不能在扩展 startOrReloadService 执行期间连入 ——
        // 长连的 Group/Status 订阅会和服务启动抢 command server 锁 → startOrReloadService 永久卡死 →
        // openTun 永不调用 → TUN 不接管 → 流量直连泄漏出本地 IP. 故先在锁外轮询等隧道完全连上
        // (startOrReloadService 返回 → openTun → status=.connected) 再连. 查询类已在后台队列, 等待不卡 UI.
        if !started {
            appLog("ensureStarted: poll for service-ready (status=\(VPNManager.shared.statusDesc))")
            var waited = 0
            while !VPNManager.shared.isServiceReady, waited < 60 { // 最多 ~30s (cache 锁竞争时 sing-box 启动可达 ~10s)
                Thread.sleep(forTimeInterval: 0.5); waited += 1
            }
            appLog("ensureStarted: poll done serviceReady=\(VPNManager.shared.isServiceReady) waited=\(waited) status=\(VPNManager.shared.statusDesc)")
        }
        lock.lock(); defer { lock.unlock() }
        guard !started else { return }
        guard VPNManager.shared.isServiceReady else { appLog("ensureStarted: service not ready, defer"); return }
        VPNManager.shared.ensureLibboxSetup()

        // group 先连: 代理 tab 数据靠它, 别被 status 连接耗时拖慢
        let groupOpts = LibboxCommandClientOptions()
        groupOpts.addCommand(LibboxCommandGroup)
        let g = LibboxNewCommandClient(self, groupOpts)

        let statusOpts = LibboxCommandClientOptions()
        statusOpts.statusInterval = 1_000_000_000 // 1s (ns)
        statusOpts.addCommand(LibboxCommandStatus)
        let s = LibboxNewCommandClient(self, statusOpts)
        do {
            try g?.connect()
            try s?.connect()
            groupClient = g
            statusClient = s
            started = true // 仅成功才 latch; 失败留 false 让下次查询 (Dart retry) 重连
            appLog("CommandClient CONNECTED (group+status)")
        } catch {
            try? g?.disconnect()
            try? s?.disconnect()
            appLog("CommandClient connect FAILED: \(error.localizedDescription)")
        }
    }

    func stop() {
        lock.lock(); defer { lock.unlock() }
        try? statusClient?.disconnect(); statusClient = nil
        try? groupClient?.disconnect(); groupClient = nil
        started = false
        groupReceived = false
    }

    // 查询接口 (VPNManager 经 method channel 转给 Dart). VPNManager 把这些放后台队列调,
    // 因 ensureStarted 的 connect() 会阻塞至多数秒.
    func proxies() -> String {
        ensureStarted()
        // 等首个 group 推送 (至多 2s); 已收到则直接返回缓存
        if started, !groupReceived { _ = groupReady.wait(timeout: .now() + 2) }
        return proxiesJSONString
    }
    func traffic() -> String { ensureStarted(); return "{\"up\":\(uplink),\"down\":\(downlink)}" }
    func totalTraffic() -> String { ensureStarted(); return "{\"up\":\(uplinkTotal),\"down\":\(downlinkTotal)}" }
    func memory() -> Int { ensureStarted(); return Int(memoryBytes) }

    // 延迟测试: libbox 无单节点测速, 触发该节点所属组的 URLTest(同组多节点共一次, 1.5s 去重),
    // 再轮询 group 流回写的本节点延迟. 返回 ms (>0=延迟, 0=节点超时, -1=无结果). FlClash 按 <=0 显 Timeout.
    func testDelay(_ proxyName: String, timeoutMs: Int) -> Int {
        ensureStarted()
        delayLock.lock()
        let group = itemGroup[proxyName]
        let now = Date().timeIntervalSince1970
        let shouldTrigger = now - lastURLTestAt > 1.5
        if shouldTrigger {
            lastURLTestAt = now
            if let group { for (k, g) in itemGroup where g == group { itemDelays[k] = nil } } // 清旧延迟等新结果
        }
        delayLock.unlock()
        if shouldTrigger, let group { VPNManager.shared.runURLTest(group) }
        let deadline = Date().addingTimeInterval(Double(timeoutMs) / 1000.0)
        while Date() < deadline {
            delayLock.lock(); let d = itemDelays[proxyName]; delayLock.unlock()
            if let d { return d } // 收到新结果(含 0=超时)即返回
            Thread.sleep(forTimeInterval: 0.2)
        }
        delayLock.lock(); let d = itemDelays[proxyName] ?? -1; delayLock.unlock()
        return d
    }

    // MARK: - LibboxCommandClientHandler

    func writeStatus(_ message: LibboxStatusMessage?) {
        guard let m = message else { return }
        uplink = m.uplink; downlink = m.downlink
        uplinkTotal = m.uplinkTotal; downlinkTotal = m.downlinkTotal
        memoryBytes = m.memory
    }

    // sing-box 组类型(小写 "selector"/"urltest")→ FlClash 期望的 mihomo 风格(首字母大写 "Selector"
    // /"URLTest"). FlClash task.dart 用 GroupTypeExtension.valueList.contains(proxy['type']) 识别"组",
    // 只认大写枚举名; 不映射则该 selector 分组被当成普通节点丢弃 → 代理 tab 永远不显示 (Phase E 真机根因).
    private func mihomoGroupType(_ t: String) -> String {
        switch t.lowercased() {
        case "selector": return "Selector"
        case "urltest": return "URLTest"
        case "loadbalance": return "LoadBalance"
        case "fallback": return "Fallback"
        case "relay": return "Relay"
        default: return "Selector" // 未知组类型按 Selector 显示, 保证被识别为组
        }
    }

    func writeGroups(_ message: LibboxOutboundGroupIteratorProtocol?) {
        guard let it = message else { return }
        var proxies: [String: Any] = [:]
        var groupTags: [String] = []
        var newDelays: [String: Int] = [:]   // 本次推送的节点延迟 (供 testDelay 轮询)
        var newGroups: [String: String] = [:]
        while it.hasNext() {
            guard let g = it.next() else { continue }
            groupTags.append(g.tag)
            var itemTags: [String] = []
            if let items = g.getItems() {
                while items.hasNext() {
                    guard let item = items.next() else { continue }
                    itemTags.append(item.tag)
                    newDelays[item.tag] = Int(item.urlTestDelay)
                    newGroups[item.tag] = g.tag
                    proxies[item.tag] = [
                        "name": item.tag,
                        "type": item.type,
                        "history": item.urlTestDelay > 0 ? [["delay": Int(item.urlTestDelay)]] : [],
                    ]
                }
            }
            proxies[g.tag] = [
                "name": g.tag,
                "type": mihomoGroupType(g.type),
                "now": g.selected,
                "all": itemTags,
                "history": [],
                // ⚠️ 必须显式 false: Dart Group.hidden 是 bool?(无默认), 缺此字段→null;
                // currentGroupsState 过滤 `hidden == false`(null==false 为 false)→组被丢弃→
                // 代理 tab 隐藏 + 节点列表空(真机实测根因)。primarySelectorName 同样 `hidden != false` 跳过。
                "hidden": false,
            ]
        }
        if !groupTags.isEmpty {
            delayLock.lock()
            for (k, v) in newDelays { itemDelays[k] = v }
            for (k, v) in newGroups { itemGroup[k] = v }
            delayLock.unlock()
        }
        // ⚠️ 忽略空分组推送: Verstro 的 sing-box 配置恒有固定 selector 分组, 故 0 分组 =
        // sing-box urltest/重载的瞬态 (handleGroupStream 每次 Recv 都回调本方法), 非真实状态.
        // 若让空推送覆盖已填充的缓存, Dart 侧下一次 updateGroups 会拿到空 → groupsProvider 清空 →
        // hasProxies=false → 代理 tab 闪现后消失 (Phase E 真机实测根因). 空推送一律丢弃, 保住上一份
        // 良好列表; 缓存唯一写入者就是本方法, 故"丢弃空"即可根治 tab 闪没.
        let itemCounts = proxies.values.compactMap { ($0 as? [String: Any])?["all"] as? [String] }.map { $0.count }
        appLog("writeGroups: \(groupTags.count) group(s) tags=\(groupTags) itemCounts=\(itemCounts)")
        if groupTags.isEmpty {
            return
        }
        let payload: [String: Any] = ["proxies": proxies, "all": groupTags]
        if let data = try? JSONSerialization.data(withJSONObject: payload),
           let s = String(data: data, encoding: .utf8) {
            proxiesJSONString = s
        }
        // 放行 proxies() 的首推等待 (只放一次), 并记录每次非空推送便于真机日志核对
        if !groupReceived {
            groupReceived = true
            groupReady.signal()
            // pre-warm: 首次拿到分组后台跑一次 URLTest, 预热到各节点的连接 (冷启动慢的 reality/ss
            // 握手提前做掉) → 用户进代理页首次手动测速即命中暖连接、秒出延迟, 不再有节点转圈.
            let warmGroups = groupTags
            delayLock.lock(); lastURLTestAt = Date().timeIntervalSince1970; delayLock.unlock()
            DispatchQueue.global().async { for g in warmGroups { VPNManager.shared.runURLTest(g) } }
        }
        NSLog("[VerstroTunnel] writeGroups: \(groupTags.count) group(s)")
    }

    // 其余回调: Verstro 不用, stub
    func connected() { appLog("CommandClient handler: connected()") }
    func disconnected(_ reason: String?) { appLog("CommandClient handler: disconnected(\(reason ?? "nil"))") }
    func clearLogs() {}
    func initializeClashMode(_: LibboxStringIteratorProtocol?, currentMode _: String?) {}
    func updateClashMode(_: String?) {}
    func setDefaultLogLevel(_: Int32) {}
    func write(_: LibboxConnectionEvents?) {} // bridged 名 (Obj-C: writeConnectionEvents:)
    func writeLogs(_: LibboxLogIteratorProtocol?) {}
    func writeOutbounds(_: LibboxOutboundGroupItemIteratorProtocol?) {}
}
