
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:upgrade/handler/upgrade_handler_interface.dart';
import 'package:upgrade/method_channel/upgrade_in_native.dart';
import 'package:upgrade/models/upgrade_status.dart';
import 'package:url_launcher/url_launcher.dart';

class IosUpgradeHandler extends UpgradeHandler {
  IosUpgradeHandler.init({required super.state}) : super.init();

  @override
  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool done)? onReceiveProgress,
    void Function(String filePath)? onDone}) {}

  @override
  void install({ required Map<String, dynamic> params }) async {
    final String appId = params['appId'];
    final bool inApp = params['inApp'];

    if (status != UpgradeStatus.available) { return; }
    if (inApp) {
      UpgradeInNative.openAppStoreInApp(appId);
    } else {
      _openAppStore(appId);
    }
  }

  void _openAppStore(String appId) async {
    final url = Uri.parse('itms-apps://itunes.apple.com/app/id$appId');
    if (!await launchUrl(url)) {
      debugPrint("[UpgradeManager] cannot open AppStore with appId: $appId");
    }
  }

}