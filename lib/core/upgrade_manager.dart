

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/models/upgrade_status.dart';

class UpgradeManager {

  UpgradeManager._init();
  static UpgradeManager? _instance;
  static UpgradeManager get instance => _getInstance();
  static UpgradeManager _getInstance() {
    _instance ??= UpgradeManager._init();
    return _instance!;
  }

  late final UpgradeStateChangeNotifier _stateChangeNotifier;
  UpgradeStateChangeNotifier get state => _stateChangeNotifier;
  UpgradeStatus get status => _stateChangeNotifier.status;

  /// The name of the app.
  late final String _appName;

  /// The upgrade appcast file url.
  late final String _url;

  /// Current app version config file path.
  late final String _currentVersionPath;

  /// If true, the installer will be opened when the upgrade package is downloaded.
  late final bool _openOnDownloaded;

  /// If true, the app will be closed when the installer is launched.
  late final bool _closeOnInstalling;

  init({
    required String appName,
    required String url,
    required String currentVersionPath,
    bool openOnDownloaded = true,
    bool closeOnInstalling = true,
  }) {
    _appName = appName;
    _url = url;
    _currentVersionPath = currentVersionPath;
    _openOnDownloaded = openOnDownloaded;
    _closeOnInstalling = closeOnInstalling;

    _stateChangeNotifier = UpgradeStateChangeNotifier();
    _loadCurrentVersion();
  }

  void checkForUpdates() {

  }

  void showInstaller() {

  }

  void install() {

  }

  void addListener(void Function() listener) {
    _stateChangeNotifier.addListener(listener);
  }

  void removeListener(void Function() listener) {
    _stateChangeNotifier.removeListener(listener);
  }

  void _loadCurrentVersion() {
    rootBundle.loadString(_currentVersionPath).then((value) {
      print(value);
    }).catchError((_) {
      debugPrint("Cannot load current version info from path: $_currentVersionPath");
      if (Platform.isAndroid) { SystemNavigator.pop(); } else { exit(0); }
    });
  }

}

