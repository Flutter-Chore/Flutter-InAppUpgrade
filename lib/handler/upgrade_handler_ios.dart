
import 'dart:io';

import 'package:upgrade/handler/upgrade_handler_interface.dart';

class IosUpgradeHandler extends UpgradeHandler {
  IosUpgradeHandler.init({required super.state}) : super.init();

  @override
  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool done)? onReceiveProgress,
    void Function(String filePath)? onDone}) {}

  @override
  void install({ String? filePath, required bool closeOnInstalling }) {

  }



}