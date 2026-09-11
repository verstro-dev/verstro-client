import Foundation
import Libbox
import NetworkExtension
import os

// Verstro iOS NE 扩展主类. VerstroTunnel/Info.plist 的 NSExtensionPrincipalClass 指向它
// ($(PRODUCT_MODULE_NAME).PacketTunnelProvider). 精简移植 sing-box-for-apple ExtensionProvider:
// 只保 iOS 路径, 去掉 macOS 系统扩展 / 位置服务 / 管理 UI / 快照持久化等. 核心 = 用 libbox
// CommandServer 跑 sing-box, 由 VerstroPlatformInterface.openTun 把 packetFlow 桥成 tun fd.
class PacketTunnelProvider: NEPacketTunnelProvider {
    private static let logger = Logger(subsystem: "com.verstro.app.VerstroTunnel", category: "PacketTunnel")
    private var commandServer: LibboxCommandServer?
    private lazy var platformInterface = VerstroPlatformInterface(self)

    override init() {
        LibboxPrepareCrashSignalHandlers()
        LibboxReinstallCrashSignalHandlers()
        super.init()
    }

    override func startTunnel(options: [String: NSObject]?) async throws {
        do {
            try await startTunnelInner(options: options)
        } catch {
            // libbox/openTun 抛的是 gomobile 的 Go-error (ObjC 类 "Universeerror"), 直接抛给 NE 框架会
            // "class Universeerror not loaded" (不可 NSSecureCoding) → startedWithError: 上报被丢弃, 真因丢失.
            // 这里先把真因 log 出来 (NSLog → idevicesyslog 可抓), 再转成干净 NSError 让 NE 能正常序列化上报.
            let detail = "\(error.localizedDescription) || \(String(describing: error))"
            Self.logger.error("startTunnel FAILED: \(detail, privacy: .public)")
            NSLog("[VerstroTunnel] startTunnel FAILED: \(detail)")
            throw NSError(domain: "VerstroTunnel", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "tunnel start failed: \(detail)",
            ])
        }
    }

    private func startTunnelInner(options: [String: NSObject]?) async throws {
        extLog("startTunnel BEGIN")
        setServiceReady(false) // 清掉上次的就绪标记: startOrReloadService 期间命令客户端必须等待, 防死锁
        let shared = FilePath.sharedDirectory
        let working = FilePath.workingDirectory
        let cache = FilePath.cacheDirectory
        for dir in [shared, working, cache] {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }

        // 配置来源: 优先 start options 的 configContent (主 App 起隧道时传), 退回 App Group 共享文件.
        let configContent: String
        if let inline = options?["configContent"] as? String, !inline.isEmpty {
            configContent = inline
        } else if let data = try? Data(contentsOf: FilePath.configFile),
                  let fromFile = String(data: data, encoding: .utf8), !fromFile.isEmpty {
            configContent = fromFile
        } else {
            throw NSError(domain: "VerstroTunnel", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "缺少 sing-box 配置 (options.configContent 或 App Group config.json)",
            ])
        }

        let setup = LibboxSetupOptions()
        setup.basePath = shared.path
        setup.workingPath = working.path
        setup.tempPath = cache.path
        setup.logMaxLines = 3000
        setup.crashReportSource = "NetworkExtension"
        setup.oomKillerEnabled = true // NE 进程 50MB jetsam 命门 —— libbox 内建 OOM 治理

        extLog("config loaded len=\(configContent.count); LibboxSetup begin")
        var setupError: NSError?
        LibboxSetup(setup, &setupError)
        if let setupError { extLog("LibboxSetup FAILED: \(setupError.localizedDescription)"); throw setupError }
        LibboxPromoteOOMDraft()
        extLog("LibboxSetup done; NewCommandServer begin")

        var newError: NSError?
        commandServer = LibboxNewCommandServer(platformInterface, platformInterface, &newError)
        if let newError { extLog("NewCommandServer FAILED: \(newError.localizedDescription)"); throw newError }
        try commandServer?.start()
        extLog("commandServer.start done; calling startOrReloadService")
        // 起 sing-box: libbox 解析配置后回调 platformInterface.openTun 建隧道.
        try commandServer?.startOrReloadService(configContent, options: LibboxOverrideOptions())
        extLog("startOrReloadService RETURNED OK")
        setServiceReady(true) // sing-box 已就绪, 命令服务器可安全连入 → 通知 app 进程的 CommandClient
        writeMessage("(verstro-tunnel) started")
    }

    override func stopTunnel(with reason: NEProviderStopReason) async {
        extLog("stopTunnel reason=\(reason.rawValue)")
        setServiceReady(false)
        writeMessage("(verstro-tunnel) stopping, reason: \(reason.rawValue)")
        try? commandServer?.closeService()
        platformInterface.reset()
        if let server = commandServer {
            try? await Task.sleep(nanoseconds: 100 * NSEC_PER_MSEC)
            server.close()
            commandServer = nil
        }
    }

    // 主 App 经 NETunnelProviderSession.sendProviderMessage 发新 sing-box 配置 → 热重载.
    override func handleAppMessage(_ messageData: Data) async -> Data? {
        guard let content = String(data: messageData, encoding: .utf8), !content.isEmpty else { return nil }
        extLog("handleAppMessage RELOAD len=\(content.count)")
        reasserting = true
        defer { reasserting = false }
        do {
            try commandServer?.startOrReloadService(content, options: LibboxOverrideOptions())
            extLog("handleAppMessage reload OK")
            return nil
        } catch {
            extLog("handleAppMessage reload FAILED: \(error.localizedDescription)")
            return error.localizedDescription.data(using: .utf8)
        }
    }

    override func sleep() async { commandServer?.pause() }
    override func wake() { commandServer?.wake() }

    func writeMessage(_ message: String) {
        commandServer?.writeMessage(2, message: message)
        Self.logger.info("\(message, privacy: .public)")
    }
}
