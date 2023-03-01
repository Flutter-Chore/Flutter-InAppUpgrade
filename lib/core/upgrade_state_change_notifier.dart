
import 'package:flutter/material.dart';
import 'package:upgrade/models/upgrade_status.dart';

class UpgradeStateChangeNotifier extends ChangeNotifier {

  var status = UpgradeStatus.idle;
  String? currentVersion;
  String? latestVersion;

  void updateUpgradeStatus({ required UpgradeStatus status }) {
    this.status = status;
    notifyListeners();
  }

  void updateLatestVersion({ required String version }) {
    latestVersion = version;
    notifyListeners();
  }

  void updateCurrentVersion({ required String version }) {
    currentVersion = version;
    notifyListeners();
  }

}