
import 'package:flutter/material.dart';
import 'package:upgrade/models/appcast_item.dart';
import 'package:upgrade/models/upgrade_status.dart';

class UpgradeStateChangeNotifier extends ChangeNotifier {

  var status = UpgradeStatus.loadingLocalConfig;
  AppcastItem? current;
  AppcastItem? latest;

  void updateUpgradeStatus({ required UpgradeStatus status }) {
    this.status = status;
    notifyListeners();
  }

  void updateLatestVersion({ required AppcastItem version }) {
    latest = version;
    _checkAvailable();
    notifyListeners();
  }

  void updateCurrentVersion({ required AppcastItem version }) {
    current = version;
    _checkAvailable();
    notifyListeners();
  }

  bool currentStatusIs({ required UpgradeStatus status }) {
    return this.status == status;
  }

  void _checkAvailable() {
    if (current != null && latest != null && latest! > current!) {
      updateUpgradeStatus(status: UpgradeStatus.available);
    }
  }

}