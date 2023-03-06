
import 'package:flutter/material.dart';
import 'package:upgrade/models/appcast_item.dart';
import 'package:upgrade/models/upgrade_status.dart';

class UpgradeStateChangeNotifier extends ChangeNotifier {

  var status = UpgradeStatus.idle;
  AppcastItem? current;
  AppcastItem? latest;

  void updateUpgradeStatus({ required UpgradeStatus status }) {
    this.status = status;
    notifyListeners();
  }

  void updateLatestVersion({ required AppcastItem version }) {
    latest = version;
    checkAvailable();
    notifyListeners();
  }

  void updateCurrentVersion({ required AppcastItem version }) {
    current = version;
    checkAvailable();
    notifyListeners();
  }

  void checkAvailable() {
    if (current != null && latest != null && latest! > current!) {
      debugPrint('available');
      updateUpgradeStatus(status: UpgradeStatus.available);
    }
  }

}