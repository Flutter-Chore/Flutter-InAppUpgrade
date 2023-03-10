# In App Upgrade

A Flutter plugin for prompting and help users to upgrade when there is a newer version of this app in the store or repository.

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