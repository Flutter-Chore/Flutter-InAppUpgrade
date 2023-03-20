package io.verse.upgrade

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

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

  private lateinit var filePath: String

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

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "installApk" -> {
        filePath = call.argument<String>("filePath")!!
        installApk()
      }
      "openAppMarket" -> {}
      else -> result.notImplemented()
    }
  }

  private fun installApk() {
    if (!hasInstallPermission()) { return }

    val file = File(filePath)
    val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
       FileProvider.getUriForFile(context, context.packageName + ".fileProvider", file) else Uri.fromFile(file)
    val intent = Intent(Intent.ACTION_VIEW)
    intent.putExtra(Intent.EXTRA_NOT_UNKNOWN_SOURCE, true)
    intent.flags = Intent.FLAG_ACTIVITY_CLEAR_TASK or
            Intent.FLAG_ACTIVITY_NEW_TASK or
            Intent.FLAG_GRANT_READ_URI_PERMISSION
    intent.setDataAndType(uri, "application/vnd.android.package-archive")
    context.startActivity(intent)
  }

  private fun hasInstallPermission(): Boolean {
    var isGranted = true
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      isGranted = context.packageManager.canRequestPackageInstalls()
      if (!isGranted) {
        AlertDialog.Builder(activity)
          .setCancelable(true)
          .setTitle("安装应用需要打开未知来源权限，请去设置中开启权限")
          .setPositiveButton("确定") { _, _ ->
            val uri = Uri.parse("package:${context.packageName}")
            val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, uri)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            activity.startActivity(intent)
          }
          .show()
      }
    }
    return isGranted
  }

}
