
import 'package:upgrade/handler/upgrade_handler_interface.dart';
import 'package:upgrade/method_channel/upgrade_in_native.dart';
import 'package:upgrade/models/upgrade_status.dart';

class AndroidUpgradeHandler extends UpgradeHandler {
  AndroidUpgradeHandler.init({required super.state}) : super.init();

  @override
  void install({ required Map<String, dynamic> params }) {
    final String filePath = params["filePath"];

    state.updateUpgradeStatus(status: UpgradeStatus.installing);
    UpgradeInNative.installApk(filePath);
  }

}