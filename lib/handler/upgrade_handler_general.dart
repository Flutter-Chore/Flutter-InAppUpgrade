
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:upgrade/handler/upgrade_handler_interface.dart';
import 'package:upgrade/models/upgrade_status.dart';
import 'package:upgrade/utils/installer.dart';

class GeneralUpgradeHandler extends UpgradeHandler {
  GeneralUpgradeHandler.init({required super.state}) : super.init();

  @override
  void install({ String? filePath, required bool closeOnInstalling }) async {
    if (status != UpgradeStatus.readyToInstall) { return; }
    if (filePath == null) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager] There no install file.");
      return;
    }

    state.updateUpgradeStatus(status: UpgradeStatus.installing);
    final file = File(filePath);
    await Installer.open(file: file, onError: () {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
    });

    if (status == UpgradeStatus.installing && closeOnInstalling) {
      if (Platform.isAndroid) { SystemNavigator.pop(); } else { exit(0); }
    }
  }


}