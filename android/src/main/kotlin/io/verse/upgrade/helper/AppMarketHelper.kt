package io.verse.upgrade.helper

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build

class AppMarketHelper {

    companion object {
        enum class Market(val packageName: String?) {
            OFFICIAL(currentDeviceOfficialMarketPackage()),
            GOOGLE_PLAY("com.android.vending"),
            COOL("com.coolapk.market"),
            TENCENT("com.tencent.android.qqdownloader"),
            BAIDU("com.baidu.appsearch"),
            QIHOO("com.qihoo.appstore"),
            WANDOUJIA("com.wandoujia.phoenix2"),
            UNKNOWN(null);

            companion object {
                fun init(name: String): Market {
                    return when (name) {
                        "official" -> OFFICIAL
                        "google_play" -> GOOGLE_PLAY
                        "cool" -> COOL
                        "tencent" -> TENCENT
                        "baidu" -> BAIDU
                        "360" -> QIHOO
                        "wandoujia" -> WANDOUJIA
                        else -> UNKNOWN
                    }
                }
            }
        }

        fun openAppMarket(context: Context, market: Market): Boolean {
            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = Uri.parse("market://details?id=${context.packageName}")
            intent.`package` = market.packageName
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(intent)
            return true
        }

        private fun hasMarket(context: Context, packageName: String): Boolean {
            return context.packageManager
                .getInstalledPackages(0)
                .map { item -> item.packageName }
                .contains(packageName)
        }

        private fun currentDeviceOfficialMarketPackage(): String? {
            return when (Build.BRAND.lowercase()) {
                "huawei", "honor", "nova" -> "com.huawei.appmarket"
                "xiaomi" -> "com.xiaomi.market"
                "oppo" -> "com.oppo.market"
                "vivo" -> "com.bbk.appstore"
                "samsung" -> "com.sec.android.app.samsungapps"
                "meizu" -> "com.meizu.mstore"
                "lenovo" -> "com.lenovo.leos.appstore"
                "zte" -> "zte.com.market"
                "nubia" -> "com.nubia.neostore"
                "google" -> "com.android.vending"
                else -> null
            }
        }

    }
}