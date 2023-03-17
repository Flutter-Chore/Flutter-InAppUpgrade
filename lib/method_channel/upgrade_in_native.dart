import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';



/// An implementation of [UpgradePlatform] that uses method channels.
class UpgradeInNative {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const MethodChannel methodChannel = MethodChannel('io.verse.upgrade/in_app_upgrade');

  /// Only for ios, should check platform before use.
  static Future<FlutterError?> openAppStoreInApp(String appId) async {
    return methodChannel.invokeMethod("openAppStoreInApp", { "appId": appId });
  }

  static Future<FlutterError?> installApk(String filePath) async {
    return methodChannel.invokeMethod("installApk", { "filePath": filePath });
  }
}
