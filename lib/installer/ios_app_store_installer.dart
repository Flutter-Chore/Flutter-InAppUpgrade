
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:upgrade/core/installer.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/method_channel/upgrade_in_native.dart';
import 'package:upgrade/models/upgrade_status.dart';
import 'package:url_launcher/url_launcher.dart';

class IosAppStoreInstallerInitializer extends InstallInitializer {

  @override
  String get identifier => "ios_app_store";

  @override
  Installer init({required UpgradeStateChangeNotifier state, required Map<String, dynamic> data}) {
    return IosAppStoreInstaller(
      state: state,
      appId: data['app_id'],
      inApp: data['in_app'] ?? false,
    );
  }
}

class IosAppStoreInstaller extends Installer {

  String appId;
  bool inApp;

  IosAppStoreInstaller({
    required super.state,
    required this.appId,
    required this.inApp,
  }) : super.init();


  @override
  bool hasDownload() => false;

  @override
  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool failed)? onReceiveProgress,
    void Function()? onDone}) {}

  @override
  Future<bool> install() async {
    if (status != UpgradeStatus.available) { return false; }

    state.updateUpgradeStatus(status: UpgradeStatus.installing);
    if (inApp) {
      final err = await UpgradeInNative.openAppStoreInApp(appId);
      if (err != null) {
        state.updateUpgradeStatus(status: UpgradeStatus.error);
        return false;
      }
      return true;
    }

    return _openAppStore();
  }

  Future<bool> _openAppStore() async {
    final url = Uri.parse('itms-apps://itunes.apple.com/app/id$appId');
    if (!await canLaunchUrl(url)) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager] cannot open AppStore with appId: $appId");
      return false;
    }
    await launchUrl(url);
    return true;
  }
}