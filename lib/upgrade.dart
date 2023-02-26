
import 'upgrade_platform_interface.dart';

class Upgrade {
  Future<String?> getPlatformVersion() {
    return UpgradePlatform.instance.getPlatformVersion();
  }
}
