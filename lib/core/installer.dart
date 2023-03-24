

import 'dart:io';

import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/installer/android_apk_installer.dart';
import 'package:upgrade/installer/android_app_market_installer.dart';
import 'package:upgrade/installer/file_installer.dart';
import 'package:upgrade/installer/ios_app_store_installer.dart';
import 'package:upgrade/installer/macos_app_store_installer.dart';
import 'package:upgrade/models/upgrade_status.dart';

class SystemInstaller {

  static List<InstallInitializer> initializers = [
    AndroidApkInstallerInitializer(),
    AndroidAppMarketInstallerInitializer(),
    FileInstallerInitializer(),
    IosAppStoreInstallerInitializer(),
    MacOSAppStoreInstallerInitializer(),
  ];
}

abstract class InstallInitializer {

  late String identifier;
  Installer init({ required UpgradeStateChangeNotifier state, required Map<String, dynamic> data });

}

abstract class Installer {

  late UpgradeStateChangeNotifier _stateChangeNotifier;
  UpgradeStateChangeNotifier get state => _stateChangeNotifier;
  UpgradeStatus get status => _stateChangeNotifier.status;

  Installer.init({ required UpgradeStateChangeNotifier state }) {
    _stateChangeNotifier = state;
  }

  bool hasDownload() => false;

  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool failed)? onReceiveProgress,
    void Function()? onDone,
  });

  Future<bool> install();

  static T from<T extends Installer>(
      UpgradeStateChangeNotifier state,
      Map<String, dynamic> json,
      T Function(UpgradeStateChangeNotifier state, Map<String, dynamic> data) factory,) {
    return factory(state, json);
  }

}