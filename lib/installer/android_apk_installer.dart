
import 'package:flutter/foundation.dart';
import 'package:upgrade/core/installer.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/installer/file_installer.dart';
import 'package:upgrade/method_channel/upgrade_in_native.dart';
import 'package:upgrade/models/upgrade_status.dart';

class AndroidApkInstallerInitializer extends InstallInitializer {

  @override
  String get identifier => "android_apk";

  @override
  Installer init({required UpgradeStateChangeNotifier state, required Map<String, dynamic> data}) {
    return AndroidApkInstaller(state: state, fileURL: data['file_url']);
  }

}

class AndroidApkInstaller extends FileInstaller {

  AndroidApkInstaller({
    required super.state,
    required super.fileURL,
    super.closeOnInstalling = false,
  });

  @override
  Future<bool> install() async {
    state.updateUpgradeStatus(status: UpgradeStatus.installing);

    if (filePath == null) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager:AndroidApkInstaller] Install file doesn't exists at $filePath.");
      return false;
    }

    final err = await UpgradeInNative.installApk(filePath!);
    if (err != null) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager:AndroidApkInstaller] Cannot install the file at $filePath.");
      return false;
    }

    return true;
  }


}