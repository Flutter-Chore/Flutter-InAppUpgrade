package io.verse.upgrade

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.verse.upgrade.helper.AppMarketHelper
import io.verse.upgrade.helper.InstallApkHelper

/**
 * UpgradePlugin
 *
 * Reference:
 *    [How to install an apk file?](https://www.jianshu.com/p/6b7bd2a59096)
 *    [How to handle activity callback?](https://csdcorp.com/blog/coding/handling-permission-requests-in-android-for-flutter-plugins/)
 * */

class UpgradePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "io.verse.upgrade/in_app_upgrade")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "installApk" -> InstallApkHelper.installApk(context, activity, call.argument<String>("filePath")!!)
      "openAppMarket" -> AppMarketHelper.openAppMarket(context, AppMarketHelper.Companion.Market.init(call.argument<String>("market")!!))
      else -> result.notImplemented()
    }
  }

}
