
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:upgrade/core/installer.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/models/appcast.dart';
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

  final Map<String, InstallInitializer> _installInitializers = {};

  final UpgradeStateChangeNotifier _stateChangeNotifier = UpgradeStateChangeNotifier();
  UpgradeStateChangeNotifier get state => _stateChangeNotifier;
  UpgradeStatus get status => state.status;
  Iterator<Installer?>? _installers;

  Installer? get installer => _installers?.current;

  /// The upgrade appcast file url.
  late final String _url;

  init({
    required String url,
    required String currentVersionPath,
    List<InstallInitializer> customInstallInitializers = const [],
  }) {
    _url = url;

    _installInitializers.addAll({ for (var item in SystemInstaller.initializers) item.identifier: item });
    _installInitializers.addAll({ for (var item in customInstallInitializers) item.identifier: item });

    CurrentVersionManager.load(currentVersionPath, (version) {
      state.updateCurrentVersion(version: version);
    });
  }

  void checkForUpdates() async {
    state.updateUpgradeStatus(status: UpgradeStatus.checking);

    final uri = Uri.parse(_url);
    final response = await Client().get(uri, headers: {'Content-Type': 'application/json;charset=utf-8'});
    if (response.statusCode != 200) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager] Download Appcast from $_url error.");
      return;
    }

    final appcast = Appcast.fromJson(List<Map<String, dynamic>>.from(json.decode(response.body)));
    final best = appcast.best();
    if (best != null) {
      state.updateLatestVersion(version: best);
      initInstallers();
      nextInstaller();
    } else {
      state.updateUpgradeStatus(status: UpgradeStatus.upToDate);
    }
  }

  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool failed)? onReceiveProgress,
    void Function()? onDone,
  }) {
    if (installer == null || !installer!.hasDownload()) { return; }
    installer?.download(
      url: url,
      file: file,
      onReceiveProgress: onReceiveProgress,
      onDone: onDone,
    );
  }

  Future<bool> install() async {
    if (installer == null) { return false; }
    return await installer!.install();
  }

  void dismiss() {
    state.updateUpgradeStatus(status: UpgradeStatus.dismissed);
  }

  void addListener(void Function() listener) {
    _stateChangeNotifier.addListener(listener);
  }

  void removeListener(void Function() listener) {
    _stateChangeNotifier.removeListener(listener);
  }

  void initInstallers() {
    if (status != UpgradeStatus.available) { return; }

    _installers = state.latest?.installer(
        state: _stateChangeNotifier, initializers: _installInitializers).iterator;
  }

  bool nextInstaller() {
    return _installers?.moveNext() ?? false;
  }

}

