import Flutter
import UIKit
import StoreKit

public class SwiftUpgradePlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "io.verse.upgrade/in_app_upgrade", binaryMessenger: registrar.messenger())
        let instance = SwiftUpgradePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openAppStoreInApp":
            guard let productId = (call.arguments as? Dictionary<String, Any>)?["appId"] as? String else {
                result(FlutterError(code: "ErrParams", message: "You should provide an available App Id.", details: nil))
                return
            }
            openAppStoreInApp(of: productId)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func openAppStoreInApp(of productId: String) {
        print("open app with: \(productId)");
        let storeProductVC = StoreKit.SKStoreProductViewController()
        storeProductVC.delegate = self
        storeProductVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: productId]) { (result, error) in
            guard error == nil else { return }
        }
        UIApplication.shared.delegate?.window??.rootViewController?.present(storeProductVC, animated: true, completion: nil)
    }
    
}

extension SwiftUpgradePlugin: SKStoreProductViewControllerDelegate {
    
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
