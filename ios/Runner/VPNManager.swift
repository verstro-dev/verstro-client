import Flutter
import Libbox
import NetworkExtension

// Verstro iOS VPN 控制 —— 主 App 经 NETunnelProviderManager 装 / 起 / 停 VerstroTunnel NE 扩展.
// MethodChannel "com.verstro.app/vpn", 对接 Dart lib/core/extension.dart 的 CoreExtension.
// 核心 (sing-box) 跑在扩展进程; 本类只负责 VPN profile 生命周期 + 把 sing-box 配置写到 App Group
// 共享文件 (= 扩展侧 FilePath.configFile), 扩展启动时读取.
final class VPNManager: NSObject {
    static let shared = VPNManager()
    private let providerBundleId = "com.verstro.app.VerstroTunnel"
    private let appGroup = "group.com.verstro.app"
    private var manager: NETunnelProviderManager?

    // 隧道是否完全连上. CommandClientBridge 必须等这个为 true 才连命令客户端 ——
    // 否则在扩展 startOrReloadService 执行期间连入命令服务器会抢锁致其永久卡死 (见 CommandClientBridge).
    var isTunnelConnected: Bool { manager?.connection.status == .connected }
    var statusDesc: String { statusString(manager?.connection.status ?? .invalid) + (manager == nil ? "(nil-mgr)" : "") }

    // 扩展置的"sing-box 服务就绪"标记 (startOrReloadService 已返回). 命令客户端等这个再连 —
    // 比 isTunnelConnected(iOS status, 可滞后 ~27s) 早得多, 且仍在 startOrReloadService 返回之后(防死锁).
    var isServiceReady: Bool {
        guard let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else { return false }
        return FileManager.default.fileExists(atPath: dir.appendingPathComponent("service-ready").path)
    }

    func register(messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: "com.verstro.app/vpn", binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result)
        }
    }

    private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            loadOrCreate { mgr, err in
                if let err { result(FlutterError(code: "init", message: err.localizedDescription, details: nil)) }
                else { result(mgr != nil) }
            }
        case "start":
            let config = (call.arguments as? [String: Any])?["config"] as? String
            start(config: config, result)
        case "stop":
            CommandClientBridge.shared.stop()
            manager?.connection.stopVPNTunnel()
            result(true)
        case "status":
            result(statusString(manager?.connection.status ?? .invalid))
        // 查询类首调会 ensureStarted→connect (阻塞至多数秒), proxies 还会等首个 group 推送,
        // 必须放后台队列, 否则卡主线程; 结果回主线程交给 Flutter.
        case "getProxies":
            DispatchQueue.global().async { let s = CommandClientBridge.shared.proxies(); DispatchQueue.main.async { result(s) } }
        case "getTraffic":
            DispatchQueue.global().async { let s = CommandClientBridge.shared.traffic(); DispatchQueue.main.async { result(s) } }
        case "getTotalTraffic":
            DispatchQueue.global().async { let s = CommandClientBridge.shared.totalTraffic(); DispatchQueue.main.async { result(s) } }
        case "getMemory":
            DispatchQueue.global().async { let m = CommandClientBridge.shared.memory(); DispatchQueue.main.async { result(m) } }
        case "testDelay": // 单节点延迟测试 → 触发组 URLTest + 轮询 (后台队列, 阻塞至多 timeout)
            let args = call.arguments as? [String: Any]
            let name = (args?["proxy-name"] as? String) ?? ""
            let url = (args?["test-url"] as? String) ?? ""
            let timeout = min((args?["timeout"] as? Int) ?? 5000, 5000)
            DispatchQueue.global().async {
                let delay = CommandClientBridge.shared.testDelay(name, timeoutMs: timeout)
                let dict: [String: Any] = ["name": name, "url": url, "value": delay]
                let s = (try? JSONSerialization.data(withJSONObject: dict)).flatMap { String(data: $0, encoding: .utf8) }
                    ?? "{\"name\":\"\(name)\",\"url\":\"\(url)\",\"value\":-1}"
                DispatchQueue.main.async { result(s) }
            }
        case "selectOutbound": // 换节点 (changeProxy)
            let args = call.arguments as? [String: Any]
            command(result) { try $0.selectOutbound(args?["group"] as? String, outboundTag: args?["tag"] as? String) }
        case "closeConnections":
            command(result) { try $0.closeConnections() }
        case "closeConnection":
            let id = (call.arguments as? [String: Any])?["id"] as? String
            command(result) { try $0.closeConnection(id) }
        case "urlTest":
            let group = (call.arguments as? [String: Any])?["group"] as? String
            command(result) { try $0.urlTest(group) }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // 载入已存在的 VPN profile 或新建一个, 配好 providerBundleIdentifier 指向扩展.
    private func loadOrCreate(_ completion: @escaping (NETunnelProviderManager?, Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            guard let self else { return }
            if let error { completion(nil, error); return }
            let mgr = managers?.first ?? NETunnelProviderManager()
            let proto = (mgr.protocolConfiguration as? NETunnelProviderProtocol) ?? NETunnelProviderProtocol()
            proto.providerBundleIdentifier = self.providerBundleId
            proto.serverAddress = "Verstro"
            mgr.protocolConfiguration = proto
            mgr.localizedDescription = "Verstro"
            mgr.isEnabled = true
            mgr.saveToPreferences { error in
                if let error { completion(nil, error); return }
                // 存盘后须再 load 一次才能 start (Apple 已知行为)
                mgr.loadFromPreferences { error in
                    if let error { completion(nil, error); return }
                    self.manager = mgr
                    completion(mgr, nil)
                }
            }
        }
    }

    private func start(config: String?, _ result: @escaping FlutterResult) {
        if let config, let url = appGroupURL()?.appendingPathComponent("config.json") {
            do { try config.data(using: .utf8)?.write(to: url, options: .atomic) }
            catch { NSLog("VPNManager write config failed: \(error.localizedDescription)") }
        }
        let begin: (NETunnelProviderManager) -> Void = { mgr in
            do { try mgr.connection.startVPNTunnel(options: nil); result(true) }
            catch { result(FlutterError(code: "start", message: error.localizedDescription, details: nil)) }
        }
        if let mgr = manager {
            begin(mgr)
        } else {
            loadOrCreate { mgr, err in
                if let mgr { begin(mgr) }
                else { result(FlutterError(code: "start", message: err?.localizedDescription ?? "no manager", details: nil)) }
            }
        }
    }

    private func appGroupURL() -> URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
    }

    private func statusString(_ status: NEVPNStatus) -> String {
        switch status {
        case .connected: return "connected"
        case .connecting: return "connecting"
        case .disconnecting: return "disconnecting"
        case .disconnected: return "disconnected"
        case .reasserting: return "reasserting"
        default: return "invalid"
        }
    }

    // --- libbox CommandClient (Phase C-2): app 端连扩展的 CommandServer ---
    // 一次性操作 (换节点 selectOutbound / 关连接 closeConnections / 测延迟 urlTest) 与流式查询
    // (CommandClientBridge: 代理列表/流量) 都靠 libbox CommandClient 连扩展. socket 路径 =
    // LibboxSetup basePath (= App Group 容器) 下的 command.sock. 两条路径在不同线程首调, 故
    // ensureLibboxSetup 设为 internal (供 CommandClientBridge 调) + 加锁; 全进程只 setup 一次.
    private var libboxSetupDone = false
    private let setupLock = NSLock()

    func ensureLibboxSetup() {
        setupLock.lock(); defer { setupLock.unlock() }
        guard !libboxSetupDone else { return }
        let shared = appGroupURL()
        let opts = LibboxSetupOptions()
        opts.basePath = shared?.path ?? NSTemporaryDirectory()
        opts.workingPath = shared?.appendingPathComponent("Working").path ?? NSTemporaryDirectory()
        opts.tempPath = shared?.appendingPathComponent("Cache").path ?? NSTemporaryDirectory()
        var err: NSError?
        LibboxSetup(opts, &err)
        if err == nil { libboxSetupDone = true } else { NSLog("VPNManager LibboxSetup failed: \(err!.localizedDescription)") }
    }

    private func command(_ result: @escaping FlutterResult, _ op: (LibboxCommandClient) throws -> Void) {
        ensureLibboxSetup()
        guard let client = LibboxNewStandaloneCommandClient() else {
            result(FlutterError(code: "cmd", message: "no command client", details: nil)); return
        }
        do { try op(client); result(true) }
        catch { result(FlutterError(code: "cmd", message: error.localizedDescription, details: nil)) }
    }

    // CommandClientBridge.testDelay 内部调用: 触发某组 URLTest (一次性 standalone client). 结果经 group 流回.
    func runURLTest(_ group: String) {
        ensureLibboxSetup()
        guard let client = LibboxNewStandaloneCommandClient() else { return }
        try? client.urlTest(group)
    }
}
