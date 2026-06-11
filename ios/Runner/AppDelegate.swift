import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Verstro iOS: 注册 VPN 控制 method channel (NETunnelProviderManager 装/起/停 VerstroTunnel)
    if let controller = window?.rootViewController as? FlutterViewController {
      VPNManager.shared.register(messenger: controller.binaryMessenger)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
