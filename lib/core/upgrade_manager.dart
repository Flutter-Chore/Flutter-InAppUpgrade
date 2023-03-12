
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/handler/upgrade_handler_android.dart';
import 'package:upgrade/handler/upgrade_handler_general.dart';
import 'package:upgrade/handler/upgrade_handler_interface.dart';
import 'package:upgrade/handler/upgrade_handler_ios.dart';
import 'package:upgrade/models/upgrade_status.dart';
import 'package:upgrade/utils/current_version_manager.dart';

class UpgradeManager {

  UpgradeManager._init();
  static UpgradeManager? _instance;
  static UpgradeManager get instance => _getInstance();
  static UpgradeManager _getInstance() {
    _instance ??= UpgradeManager._init();
    return _instance!;
  }

  final UpgradeStateChangeNotifier _stateChangeNotifier = UpgradeStateChangeNotifier();
  UpgradeStateChangeNotifier get state => _stateChangeNotifier;
  UpgradeStatus get status => _stateChangeNotifier.status;

  late final UpgradeHandler _handler = (() {
    switch (Platform.operatingSystem) {
      case 'ios':
        return IosUpgradeHandler.init(state: _stateChangeNotifier);
      case 'android':
        return AndroidUpgradeHandler.init(state: _stateChangeNotifier);
      case 'macos':
      case 'linux':
      case 'windows':
      default:
        return GeneralUpgradeHandler.init(state: _stateChangeNotifier);
    }
  })();


  /// The upgrade appcast file url.
  late final String _url;

  /// If true, the app will be closed when the installer is launched.
  late final bool _closeOnInstalling;

  String? _filePath;

  init({
    required String url,
    required String currentVersionPath,
    bool closeOnInstalling = true,
  }) {
    _url = url;
    _closeOnInstalling = closeOnInstalling;

    CurrentVersionManager.load(currentVersionPath, (version) {
      state.updateCurrentVersion(version: version);
    });
  }

  void checkForUpdates() async {
    _handler.checkForUpdates(url: _url);
  }

  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool done)? onReceiveProgress,
    void Function()? onDone,
  }) async {
    _handler.download(
      url: url,
      file: file,
      onReceiveProgress: onReceiveProgress,
      onDone: (path) {
        _filePath = path;
        onDone?.call();
      },
    );

  }

  void showUpgradeDialog({ required BuildContext context, Widget? dialog }) {
    _handler.showUpgradeDialog(context: context, dialog: dialog);
  }

  Future<void> install() async {
    _handler.install(filePath: _filePath, closeOnInstalling: _closeOnInstalling);
  }

  void dismiss() {
    _handler.dismiss();
  }

  void addListener(void Function() listener) {
    _stateChangeNotifier.addListener(listener);
  }

  void removeListener(void Function() listener) {
    _stateChangeNotifier.removeListener(listener);
  }

}

