
import 'package:flutter/material.dart';
import 'package:upgrade/handler/upgrade_handler_interface.dart';

class IosUpgradeHandler extends UpgradeHandler {
  IosUpgradeHandler.init({required super.state}) : super.init();

  @override
  void install(String? filePath, bool closeOnInstalling) {
    // TODO: implement install
  }

  @override
  void showUpgradeDialog({required BuildContext context, Widget? dialog}) {
    // TODO: implement showUpgradeDialog
  }


}