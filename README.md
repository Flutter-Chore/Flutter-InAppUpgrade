# In App Upgrade

A Flutter plugin for prompting and help users to upgrade when there is a newer version of this app in the app store or server repository.

## Platform Support
|Platform|Open App Store|Download/Install Installer|Third-party App Store|
|:---:|---|---|---|
|iOS|✅Yes|❌No||
|android|✅Yes|✅Yes|Google Play, 酷安, 应用宝, 百度手机助手, 360手机助手, 豌豆荚|
|macOS|✅Yes|✅Yes||
|linux|❌No|✅Yes||
|windows|❌No|✅Yes||

## ⚠️ Disclaimer

## How it work?

## How to use?

## Config Before Use

### Android

1. Create `file_provider_path.xml` at `android/app/src/main/res/xml`, and add below content:
```xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <files-path name="files" path="." />
    <cache-path name="cache" path="." />
    <external-path name="external" path="." />
    <external-cache-path name="cache" path="." />
    <external-files-path name="files" path="." />
</paths>
```
2. Add below attributes in `android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="your.package">
    <!--other attributes-->

    <!--(if you want to upload google store,can not add this permission)-->
    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

    <application>
        <!--other attributes-->
        <provider
            android:authorities="${applicationId}.fileProvider"
            android:name="androidx.core.content.FileProvider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_provider_path"/>
        </provider>
    </application>
</manifest>
```

### MacOS

You should set below attributes in *.entitlements
```xml
<dict>
    <!--other attributes-->
    <key>com.apple.security.network.client</key>
    <true/>
    <key>com.apple.security.files.downloads.read-write</key>
    <true/>
</dict>
```