
import 'package:flutter/foundation.dart';
import 'package:upgrade/handler/upgrade_handler_interface.dart';
import 'package:upgrade/models/upgrade_status.dart';
import 'package:url_launcher/url_launcher.dart';

class MacOSUpgradeHandler extends UpgradeHandler {
  MacOSUpgradeHandler.init({required super.state}) : super.init();

  @override
  void install({required Map<String, dynamic> params}) {
    final String appId = params["appId"];

    if (status != UpgradeStatus.available) { return; }
    _openAppStore(appId);
  }

  void _openAppStore(String appId) async {
    final url = Uri.parse('macappstore://itunes.apple.com/app/id$appId?mt=12');
    if (!await launchUrl(url)) {
      debugPrint("[UpgradeManager] cannot open AppStore with appId: $appId");
    }
  }
}