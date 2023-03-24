
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:upgrade/core/installer.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/models/upgrade_status.dart';
import 'package:url_launcher/url_launcher.dart';

class MacOSAppStoreInstallerInitializer extends InstallInitializer {

  @override
  String get identifier => "macos_app_store";

  @override
  Installer init({required UpgradeStateChangeNotifier state, required Map<String, dynamic> data}) {
    return MacOSAppStoreInstaller(
      state: state,
      appId: data['app_id'],
    );
  }
}

class MacOSAppStoreInstaller extends Installer {

  final String appId;

  MacOSAppStoreInstaller({
    required super.state,
    required this.appId,
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
    return _openAppStore();
  }

  Future<bool> _openAppStore() async {
    final url = Uri.parse('macappstore://itunes.apple.com/app/id$appId?mt=12');
    if (!await canLaunchUrl(url)) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager] cannot open AppStore with appId: $appId");
      return false;
    }
    await launchUrl(url);
    return true;
  }
}