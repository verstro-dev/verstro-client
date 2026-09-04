import Foundation

// App Group 共享路径 —— 主 App 与 NE 扩展之间交接 sing-box 配置 / geo / 日志.
// 主 App (Flutter, 经 NETunnelProviderManager) 把订阅生成的 sing-box JSON 写到 configFile,
// 扩展启动时读取. App Group id 必须与 Runner/VerstroTunnel.entitlements 一致.
enum FilePath {
    static let appGroup = "group.com.verstro.app"

    static var sharedDirectory: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
    }

    static var workingDirectory: URL { sharedDirectory.appendingPathComponent("Working", isDirectory: true) }
    static var cacheDirectory: URL { sharedDirectory.appendingPathComponent("Cache", isDirectory: true) }
    static var configFile: URL { sharedDirectory.appendingPathComponent("config.json") }
}

// Phase E 诊断: 扩展进程把启动/openTun 全过程直接 append 到 App Group 文件, 经 devicectl 拉下来分析.
// 不用 NSLog(进不了 idevicesyslog) 也不靠 sing-box 自己的缓冲日志(实测只落 4 行). 线程安全用串行队列.
private let extLogQueue = DispatchQueue(label: "com.verstro.app.extlog")
func extLog(_ message: String) {
    extLogQueue.async {
        let url = FilePath.sharedDirectory.appendingPathComponent("verstro-ext.log")
        let line = "\(Date().timeIntervalSince1970) \(message)\n"
        guard let data = line.data(using: .utf8) else { return }
        if let handle = try? FileHandle(forWritingTo: url) {
            handle.seekToEndOfFile(); handle.write(data); try? handle.close()
        } else {
            try? data.write(to: url, options: .atomic)
        }
    }
}

// sing-box 服务就绪标记 (App Group 文件): 扩展在 startOrReloadService 返回后置 true, startTunnel
// 开头/stopTunnel 置 false. app 进程的 CommandClient 据此判断"何时连入命令服务器安全且有数据" ——
// 比等 iOS VPN status==connected 早得多 (status 实测可滞后 ~27s), 保证 groups 落进 updateGroups 重试窗口.
func setServiceReady(_ ready: Bool) {
    let url = FilePath.sharedDirectory.appendingPathComponent("service-ready")
    if ready {
        try? Data().write(to: url, options: .atomic)
    } else {
        try? FileManager.default.removeItem(at: url)
    }
}

private final class ResultBox<T> { var value: T? }

// 在同步的 libbox PlatformInterface 回调里跑 async 代码 ——
// setTunnelNetworkSettings / NEHotspotNetwork.fetchCurrent 等都是 async, 而 libbox 经
// gomobile 桥接调进来的 openTun/readWIFIState/clearDNSCache 是同步签名. 用信号量阻塞桥接.
// 移植自 sing-box-for-apple Extension+RunBlocking.swift.
func runBlocking<T>(_ operation: @escaping () async throws -> T) throws -> T {
    let semaphore = DispatchSemaphore(value: 0)
    let box = ResultBox<Result<T, Error>>()
    Task.detached {
        do { box.value = .success(try await operation()) } catch { box.value = .failure(error) }
        semaphore.signal()
    }
    semaphore.wait()
    return try box.value!.get()
}

func runBlocking<T>(_ operation: @escaping () async -> T) -> T {
    let semaphore = DispatchSemaphore(value: 0)
    let box = ResultBox<T>()
    Task.detached {
        box.value = await operation()
        semaphore.signal()
    }
    semaphore.wait()
    return box.value!
}
