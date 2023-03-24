
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:upgrade/core/installer.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/method_channel/upgrade_in_native.dart';
import 'package:upgrade/models/app_market.dart';
import 'package:upgrade/models/upgrade_status.dart';

class AndroidAppMarketInstallerInitializer extends InstallInitializer {

  @override
  String get identifier => "android_app_market";

  @override
  Installer init({
    required UpgradeStateChangeNotifier state,
    required Map<String, dynamic> data,
  }) {
    return AndroidAppMarketInstaller(
      state: state,
      market: AppMarket.init(data['market']),
    );
  }

}

class AndroidAppMarketInstaller extends Installer {

  AppMarket market;

  AndroidAppMarketInstaller({
    required super.state,
    this.market = AppMarket.official,
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
    state.updateUpgradeStatus(status: UpgradeStatus.installing);

    final err = await UpgradeInNative.openAppMarket(market: market);
    if (err != null) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager:AndroidAppMarketInstaller] Cannot install app from ${market.name} market.");
      return false;
    }

    return true;
  }


}