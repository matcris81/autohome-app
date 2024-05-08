import UIKit
import Flutter
import Intents
import IntentsUI


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, INUIAddVoiceShortcutViewControllerDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        let channel = FlutterMethodChannel(name: "com.swift.voicecommands/commands", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "createShortcut" {
                self?.presentAddVoiceShortcutViewController(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func presentAddVoiceShortcutViewController(result: @escaping FlutterResult) {
        let intent = DoorIntent()
        intent.suggestedInvocationPhrase = "Default phrase"
        if let shortcut = INShortcut(intent: intent) {
            let siriViewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            siriViewController.delegate = self
            self.window?.rootViewController?.present(siriViewController, animated: true, completion: nil)
            result("Shortcut view controller presented")
        } else {
            result(FlutterError(code: "UNAVAILABLE", message: "Cannot create shortcut", details: nil))
        }
    }

    // Siri Shortcut Delegate Methods
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true) {
            self.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true) {
            self.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
