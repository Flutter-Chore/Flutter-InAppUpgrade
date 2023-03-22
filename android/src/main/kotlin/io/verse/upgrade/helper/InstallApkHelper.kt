package io.verse.upgrade.helper

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import java.io.File

class InstallApkHelper {

    companion object {

        fun installApk(context: Context, activity: Activity, filePath: String) {
            if (!hasInstallPermission(context, activity)) { return }

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

        private fun hasInstallPermission(context: Context, activity: Activity): Boolean {
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

}