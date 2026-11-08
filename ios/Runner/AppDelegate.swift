import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(name: "alisters/storage", binaryMessenger: engineBridge.applicationRegistrar.messenger())
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "read": result(UserDefaults.standard.string(forKey: "alisters.entries"))
      case "write":
        guard let value = call.arguments as? String else { result(FlutterError(code: "invalid", message: "Dados inválidos", details: nil)); return }
        UserDefaults.standard.set(value, forKey: "alisters.entries")
        result(nil)
      default: result(FlutterMethodNotImplemented)
      }
    }
  }
}
