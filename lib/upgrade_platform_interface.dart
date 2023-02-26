import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'upgrade_method_channel.dart';

abstract class UpgradePlatform extends PlatformInterface {
  /// Constructs a UpgradePlatform.
  UpgradePlatform() : super(token: _token);

  static final Object _token = Object();

  static UpgradePlatform _instance = MethodChannelUpgrade();

  /// The default instance of [UpgradePlatform] to use.
  ///
  /// Defaults to [MethodChannelUpgrade].
  static UpgradePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UpgradePlatform] when
  /// they register themselves.
  static set instance(UpgradePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
