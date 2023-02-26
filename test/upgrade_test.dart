import 'package:flutter_test/flutter_test.dart';
import 'package:upgrade/upgrade.dart';
import 'package:upgrade/upgrade_platform_interface.dart';
import 'package:upgrade/upgrade_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUpgradePlatform
    with MockPlatformInterfaceMixin
    implements UpgradePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UpgradePlatform initialPlatform = UpgradePlatform.instance;

  test('$MethodChannelUpgrade is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUpgrade>());
  });

  test('getPlatformVersion', () async {
    Upgrade upgradePlugin = Upgrade();
    MockUpgradePlatform fakePlatform = MockUpgradePlatform();
    UpgradePlatform.instance = fakePlatform;

    expect(await upgradePlugin.getPlatformVersion(), '42');
  });
}
