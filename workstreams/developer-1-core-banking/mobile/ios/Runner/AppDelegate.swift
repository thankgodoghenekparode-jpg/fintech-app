import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var cardPrivacyChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "yourapp/card_privacy",
      binaryMessenger: engineBridge.binaryMessenger
    )
    cardPrivacyChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "enable":
        // UIKit exposes screen-recording and post-screenshot notifications,
        // but neither prevents a screenshot from containing sensitive values.
        // Keep reveal disabled on iOS until a supported capture-blocking path
        // is available for this application.
        result(false)
      case "disable":
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
