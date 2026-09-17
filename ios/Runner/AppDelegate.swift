import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // The Secure Enclave key behind biometric sign-in. Registered here rather than as a
    // plugin because it is one file that belongs to this app, not something to publish.
    if let controller = window?.rootViewController as? FlutterViewController {
      BiometricKeyBridge.register(with: controller.binaryMessenger)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
