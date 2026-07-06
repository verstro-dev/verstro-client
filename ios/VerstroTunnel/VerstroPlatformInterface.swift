import Foundation
import Libbox
import Network
import NetworkExtension

// libbox 的 PlatformInterface + CommandServerHandler 实现. libbox (Go) 经 gomobile 桥接回调
// 这里的方法. 协议面由 v1.13.13 libbox 头文件决定 (25 个 PlatformInterface 方法 + 7 个 Handler
// 方法). Verstro 只用 VLESS-Reality + Shadowsocks, 故除 openTun (唯一实方法, 把 packetFlow
// 桥成 tun fd) 与默认接口监控外, 其余 (tailscale/SSH/shell/邻居监控/系统代理...) 均最小 stub.
// openTun 映射照搬 sing-box-for-apple ExtensionPlatformInterface.
final class VerstroPlatformInterface: NSObject, LibboxPlatformInterfaceProtocol, LibboxCommandServerHandlerProtocol {
    private unowned let tunnel: PacketTunnelProvider
    private var networkSettings: NEPacketTunnelNetworkSettings?
    private var nwMonitor: NWPathMonitor?
    private let errDomain = "VerstroPlatformInterface"

    init(_ tunnel: PacketTunnelProvider) {
        self.tunnel = tunnel
    }

    func reset() {
        nwMonitor?.cancel()
        nwMonitor = nil
        networkSettings = nil
    }

    private func notImplemented() -> NSError {
        NSError(domain: errDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "not implemented on iOS"])
    }

    // MARK: - openTun (核心: LibboxTunOptions → NEPacketTunnelNetworkSettings + 取 tun fd)

    func openTun(_ options: LibboxTunOptionsProtocol?, ret0_: UnsafeMutablePointer<Int32>?) throws {
        extLog("openTun OUTER begin (before runBlocking)")
        defer { extLog("openTun OUTER end") }
        try runBlocking { [self] in
            try await openTun0(options, ret0_)
        }
    }

    private func openTun0(_ options: LibboxTunOptionsProtocol?, _ ret0_: UnsafeMutablePointer<Int32>?) async throws {
        extLog("openTun BEGIN")
        guard let options else { extLog("openTun: nil options"); throw NSError(domain: errDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "nil tun options"]) }
        guard let ret0_ else { extLog("openTun: nil ret ptr"); throw NSError(domain: errDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "nil return pointer"]) }
        extLog("openTun autoRoute=\(options.getAutoRoute()) mtu=\(options.getMTU())")

        // Verstro 不用 sing-box-for-apple 的 OverridePreferences, 全默认 (全局路由, 不排除).
        let autoRouteUseSubRangesByDefault = false
        let excludeAPNs = false
        let excludeDefaultRoute = false
        let systemProxyEnabled = true

        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
        if options.getAutoRoute() {
            settings.mtu = NSNumber(value: options.getMTU())

            var dnsSettings: NEDNSSettings?
            if let dnsMode = options.getDNSMode(), dnsMode.value != LibboxDNSModeDisabled {
                let dnsServerIterator = try options.getDNSServerAddress()
                var dnsServers: [String] = []
                while dnsServerIterator.hasNext() {
                    dnsServers.append(dnsServerIterator.next())
                }
                if !dnsServers.isEmpty {
                    let newDNSSettings = NEDNSSettings(servers: dnsServers)
                    settings.dnsSettings = newDNSSettings
                    dnsSettings = newDNSSettings
                }
            }

            // IPv4
            var ipv4Address: [String] = []
            var ipv4Mask: [String] = []
            let ipv4AddressIterator = options.getInet4Address()!
            while ipv4AddressIterator.hasNext() {
                let ipv4Prefix = ipv4AddressIterator.next()!
                ipv4Address.append(ipv4Prefix.address())
                ipv4Mask.append(ipv4Prefix.mask())
            }
            let ipv4Settings = NEIPv4Settings(addresses: ipv4Address, subnetMasks: ipv4Mask)
            var ipv4Routes: [NEIPv4Route] = []
            var ipv4ExcludeRoutes: [NEIPv4Route] = []
            let inet4RouteAddressIterator = options.getInet4RouteAddress()!
            if inet4RouteAddressIterator.hasNext() {
                while inet4RouteAddressIterator.hasNext() {
                    let p = inet4RouteAddressIterator.next()!
                    ipv4Routes.append(NEIPv4Route(destinationAddress: p.address(), subnetMask: p.mask()))
                }
            } else if autoRouteUseSubRangesByDefault {
                ipv4Routes.append(NEIPv4Route(destinationAddress: "1.0.0.0", subnetMask: "255.0.0.0"))
                ipv4Routes.append(NEIPv4Route(destinationAddress: "2.0.0.0", subnetMask: "254.0.0.0"))
                ipv4Routes.append(NEIPv4Route(destinationAddress: "4.0.0.0", subnetMask: "252.0.0.0"))
                ipv4Routes.append(NEIPv4Route(destinationAddress: "8.0.0.0", subnetMask: "248.0.0.0"))
                ipv4Routes.append(NEIPv4Route(destinationAddress: "16.0.0.0", subnetMask: "240.0.0.0"))
                ipv4Routes.append(NEIPv4Route(destinationAddress: "32.0.0.0", subnetMask: "224.0.0.0"))
                ipv4Routes.append(NEIPv4Route(destinationAddress: "64.0.0.0", subnetMask: "192.0.0.0"))
                ipv4Routes.append(NEIPv4Route(destinationAddress: "128.0.0.0", subnetMask: "128.0.0.0"))
            } else {
                ipv4Routes.append(NEIPv4Route.default())
            }
            let inet4RouteExcludeIterator = options.getInet4RouteExcludeAddress()!
            while inet4RouteExcludeIterator.hasNext() {
                let p = inet4RouteExcludeIterator.next()!
                ipv4ExcludeRoutes.append(NEIPv4Route(destinationAddress: p.address(), subnetMask: p.mask()))
            }
            if excludeDefaultRoute, !ipv4Routes.isEmpty {
                ipv4ExcludeRoutes.append(NEIPv4Route(destinationAddress: "0.0.0.0", subnetMask: "255.255.255.254"))
            }
            if excludeAPNs, !ipv4Routes.isEmpty {
                ipv4ExcludeRoutes.append(NEIPv4Route(destinationAddress: "17.0.0.0", subnetMask: "255.0.0.0"))
            }
            ipv4Settings.includedRoutes = ipv4Routes
            ipv4Settings.excludedRoutes = ipv4ExcludeRoutes
            settings.ipv4Settings = ipv4Settings

            // IPv6
            var ipv6Address: [String] = []
            var ipv6Prefixes: [NSNumber] = []
            let ipv6AddressIterator = options.getInet6Address()!
            while ipv6AddressIterator.hasNext() {
                let p = ipv6AddressIterator.next()!
                ipv6Address.append(p.address())
                ipv6Prefixes.append(NSNumber(value: p.prefix()))
            }
            let ipv6Settings = NEIPv6Settings(addresses: ipv6Address, networkPrefixLengths: ipv6Prefixes)
            var ipv6Routes: [NEIPv6Route] = []
            var ipv6ExcludeRoutes: [NEIPv6Route] = []
            let inet6RouteAddressIterator = options.getInet6RouteAddress()!
            if inet6RouteAddressIterator.hasNext() {
                while inet6RouteAddressIterator.hasNext() {
                    let p = inet6RouteAddressIterator.next()!
                    ipv6Routes.append(NEIPv6Route(destinationAddress: p.address(), networkPrefixLength: NSNumber(value: p.prefix())))
                }
            } else if autoRouteUseSubRangesByDefault {
                ipv6Routes.append(NEIPv6Route(destinationAddress: "100::", networkPrefixLength: 8))
                ipv6Routes.append(NEIPv6Route(destinationAddress: "200::", networkPrefixLength: 7))
                ipv6Routes.append(NEIPv6Route(destinationAddress: "400::", networkPrefixLength: 6))
                ipv6Routes.append(NEIPv6Route(destinationAddress: "800::", networkPrefixLength: 5))
                ipv6Routes.append(NEIPv6Route(destinationAddress: "1000::", networkPrefixLength: 4))
                ipv6Routes.append(NEIPv6Route(destinationAddress: "2000::", networkPrefixLength: 3))
                ipv6Routes.append(NEIPv6Route(destinationAddress: "4000::", networkPrefixLength: 2))
                ipv6Routes.append(NEIPv6Route(destinationAddress: "8000::", networkPrefixLength: 1))
            } else {
                ipv6Routes.append(NEIPv6Route.default())
            }
            let inet6RouteExcludeIterator = options.getInet6RouteExcludeAddress()!
            while inet6RouteExcludeIterator.hasNext() {
                let p = inet6RouteExcludeIterator.next()!
                ipv6ExcludeRoutes.append(NEIPv6Route(destinationAddress: p.address(), networkPrefixLength: NSNumber(value: p.prefix())))
            }
            if excludeDefaultRoute, !ipv6Routes.isEmpty {
                ipv6ExcludeRoutes.append(NEIPv6Route(destinationAddress: "::", networkPrefixLength: 127))
            }
            ipv6Settings.includedRoutes = ipv6Routes
            ipv6Settings.excludedRoutes = ipv6ExcludeRoutes
            settings.ipv6Settings = ipv6Settings

            let hasDefaultRoute = ipv4Routes.contains { $0.destinationAddress == "0.0.0.0" && $0.destinationSubnetMask == "0.0.0.0" }
            if !hasDefaultRoute {
                dnsSettings?.matchDomains = [""]
                dnsSettings?.matchDomainsNoSearch = true
            }
        }

        if options.isHTTPProxyEnabled() {
            let proxySettings = NEProxySettings()
            let proxyServer = NEProxyServer(address: options.getHTTPProxyServer(), port: Int(options.getHTTPProxyServerPort()))
            proxySettings.httpServer = proxyServer
            proxySettings.httpsServer = proxyServer
            if systemProxyEnabled {
                proxySettings.httpEnabled = true
                proxySettings.httpsEnabled = true
            }
            var bypassDomains: [String] = []
            if let it = options.getHTTPProxyBypassDomain() {
                while it.hasNext() { bypassDomains.append(it.next()) }
            }
            if !bypassDomains.isEmpty { proxySettings.exceptionList = bypassDomains }
            var matchDomains: [String] = []
            if let it = options.getHTTPProxyMatchDomain() {
                while it.hasNext() { matchDomains.append(it.next()) }
            }
            if !matchDomains.isEmpty { proxySettings.matchDomains = matchDomains }
            settings.proxySettings = proxySettings
        }

        networkSettings = settings
        let v4 = settings.ipv4Settings?.includedRoutes ?? []
        let hasDefault = v4.contains { $0.destinationAddress == "0.0.0.0" && $0.destinationSubnetMask == "0.0.0.0" }
        extLog("openTun setTunnelNetworkSettings begin; ipv4 includedRoutes=\(v4.count) hasDefault=\(hasDefault) dns=\(settings.dnsSettings?.servers ?? [])")
        try await tunnel.setTunnelNetworkSettings(settings)
        extLog("openTun setTunnelNetworkSettings done")

        // 取 utun fd: 私有 KVC 主路径 + libbox 扫 fd 回退 (照搬 sing-box-for-apple).
        if let tunFd = tunnel.packetFlow.value(forKeyPath: "socket.fileDescriptor") as? Int32 {
            extLog("openTun fd via KVC = \(tunFd); RETURN")
            ret0_.pointee = tunFd
            return
        }
        let tunFdFromLoop = LibboxGetTunnelFileDescriptor()
        if tunFdFromLoop != -1 {
            extLog("openTun fd via LibboxGetTunnelFileDescriptor = \(tunFdFromLoop); RETURN")
            ret0_.pointee = tunFdFromLoop
        } else {
            extLog("openTun MISSING tun fd (KVC nil + loop -1)")
            throw NSError(domain: errDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "missing tun file descriptor"])
        }
    }

    // MARK: - 默认接口监控 (sing-box 自动选出口接口要用)

    func startDefaultInterfaceMonitor(_ listener: LibboxInterfaceUpdateListenerProtocol?) throws {
        extLog("startDefaultInterfaceMonitor BEGIN")
        guard let listener else { extLog("startDefaultInterfaceMonitor nil listener"); return }
        let monitor = NWPathMonitor()
        nwMonitor = monitor
        let semaphore = DispatchSemaphore(value: 0)
        monitor.pathUpdateHandler = { path in
            self.onUpdateDefaultInterface(listener, path)
            semaphore.signal()
            monitor.pathUpdateHandler = { path in self.onUpdateDefaultInterface(listener, path) }
        }
        monitor.start(queue: DispatchQueue.global())
        // ⚠️ 不能无限阻塞 libbox 启动线程: NE 进程内首个 NWPath 更新偶尔很慢/卡, 无超时的
        // semaphore.wait() 会让 startTunnel 卡满 ~30s → 触发 iOS NE 启动看门狗 SIGKILL.
        // 等满 5s 就放行 (handler 已重挂, 后续 path 更新照常回调 libbox).
        let waitResult = semaphore.wait(timeout: .now() + 5)
        extLog("startDefaultInterfaceMonitor first-path: \(waitResult == .success ? "got" : "TIMEOUT-5s-proceed")")
    }

    private func onUpdateDefaultInterface(_ listener: LibboxInterfaceUpdateListenerProtocol, _ path: Network.NWPath) {
        guard path.status != .unsatisfied, let iface = path.availableInterfaces.first else {
            listener.updateDefaultInterface("", interfaceIndex: -1, isExpensive: false, isConstrained: false)
            return
        }
        listener.updateDefaultInterface(iface.name, interfaceIndex: Int32(iface.index), isExpensive: path.isExpensive, isConstrained: path.isConstrained)
    }

    func closeDefaultInterfaceMonitor(_: LibboxInterfaceUpdateListenerProtocol?) throws {
        nwMonitor?.cancel()
        nwMonitor = nil
    }

    func getInterfaces() throws -> LibboxNetworkInterfaceIteratorProtocol {
        extLog("getInterfaces begin")
        guard let nwMonitor else { extLog("getInterfaces: monitor not started"); throw NSError(domain: errDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "monitor not started"]) }
        let path = nwMonitor.currentPath
        if path.status == .unsatisfied { return NetworkInterfaceArray([]) }
        var interfaces: [LibboxNetworkInterface] = []
        for it in path.availableInterfaces {
            let i = LibboxNetworkInterface()
            i.name = it.name
            i.index = Int32(it.index)
            switch it.type {
            case .wifi: i.type = LibboxInterfaceTypeWIFI
            case .cellular: i.type = LibboxInterfaceTypeCellular
            case .wiredEthernet: i.type = LibboxInterfaceTypeEthernet
            default: i.type = LibboxInterfaceTypeOther
            }
            interfaces.append(i)
        }
        return NetworkInterfaceArray(interfaces)
    }

    final class NetworkInterfaceArray: NSObject, LibboxNetworkInterfaceIteratorProtocol {
        private var iterator: IndexingIterator<[LibboxNetworkInterface]>
        private var nextValue: LibboxNetworkInterface?
        init(_ array: [LibboxNetworkInterface]) { iterator = array.makeIterator() }
        func hasNext() -> Bool { nextValue = iterator.next(); return nextValue != nil }
        func next() -> LibboxNetworkInterface? { nextValue }
    }

    // MARK: - 网络环境查询

    func underNetworkExtension() -> Bool { extLog("underNetworkExtension"); return true }
    func includeAllNetworks() -> Bool { false }
    func useProcFS() -> Bool { false }

    func clearDNSCache() {
        guard let networkSettings else { return }
        runBlocking {
            self.tunnel.reasserting = true
            defer { self.tunnel.reasserting = false }
            await withCheckedContinuation { c in self.tunnel.setTunnelNetworkSettings(nil) { _ in c.resume() } }
            await withCheckedContinuation { c in self.tunnel.setTunnelNetworkSettings(networkSettings) { _ in c.resume() } }
        }
    }

    func readWIFIState() -> LibboxWIFIState? {
        extLog("readWIFIState begin (runBlocking NEHotspotNetwork.fetchCurrent)")
        let network = runBlocking { await NEHotspotNetwork.fetchCurrent() }
        extLog("readWIFIState end (network=\(network != nil))")
        guard let network else { return nil }
        return LibboxWIFIState(network.ssid, wifiBSSID: network.bssid)
    }

    func findConnectionOwner(_: Int32, sourceAddress _: String?, sourcePort _: Int32, destinationAddress _: String?, destinationPort _: Int32) throws -> LibboxConnectionOwner {
        throw notImplemented()
    }

    // MARK: - 接口自动探测 / 平台 shell (Verstro 不用, stub)

    // 注: bridged Swift 名去掉了 "Interface" (gomobile NS_SWIFT_NAME), 与 Obj-C 字面名不同
    func usePlatformAutoDetectControl() -> Bool { false }
    func autoDetectControl(_: Int32) throws {}
    func usePlatformShell() -> Bool { false }
    func checkPlatformShell() throws {}
    func openShellSession(_: LibboxPlatformUser?, command _: String?, environ _: LibboxStringIteratorProtocol?, term _: String?, rows _: Int32, cols _: Int32) throws -> LibboxShellSessionProtocol { throw notImplemented() }
    // 注: 返回 _Nonnull NSString + error 参数 → bridged 成 (NSErrorPointer)->String, 非 throws
    func readSystemSSHHostKey(_ error: NSErrorPointer) -> String { error?.pointee = notImplemented(); return "" }
    func lookupSFTPServer(_ error: NSErrorPointer) -> String { error?.pointee = notImplemented(); return "" }
    func lookupUser(_: String?) throws -> LibboxPlatformUser { throw notImplemented() }

    // MARK: - tailscale / 邻居监控 / DNS transport / 证书 / 通知 (Verstro 不用, stub)

    func tailscaleHostname() -> String { "" }
    func registerMyInterface(_: String?) {}
    func startNeighborMonitor(_: LibboxNeighborUpdateListenerProtocol?) throws {}
    func closeNeighborMonitor(_: LibboxNeighborUpdateListenerProtocol?) throws {}
    func localDNSTransport() -> LibboxLocalDNSTransportProtocol? { extLog("localDNSTransport"); return nil }
    func systemCertificates() -> LibboxStringIteratorProtocol? { extLog("systemCertificates"); return nil }
    func send(_: LibboxNotification?) throws {} // bridged 名 (Obj-C: sendNotification:error:)

    // MARK: - LibboxCommandServerHandler (app↔扩展命令; Verstro 多为 stub)

    func serviceReload() throws {}
    func serviceStop() throws { tunnel.cancelTunnelWithError(nil) }
    func getSystemProxyStatus() throws -> LibboxSystemProxyStatus {
        let status = LibboxSystemProxyStatus()
        status.available = false
        status.enabled = false
        return status
    }
    func setSystemProxyEnabled(_: Bool) throws {}
    func connectSSHAgent(_: UnsafeMutablePointer<Int32>?) throws { throw notImplemented() }
    func triggerNativeCrash() throws {}
    func writeDebugMessage(_ message: String?) { if let message { tunnel.writeMessage(message) } }
}
