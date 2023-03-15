# In App Upgrade

A Flutter plugin for prompting and help users to upgrade when there is a newer version of this app in the store or repository.

## Platform Support
|Platform|App Store|In App Upgrade|Third-party App Store|
|:---:|---|---|---|
|iOS|✅Yes|❌No||
|android|✅Yes|✅Yes||
|macOS|❌No|✅Yes||
|linux|❌No|✅Yes||
|windows|❌No|✅Yes||

## MacOS

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