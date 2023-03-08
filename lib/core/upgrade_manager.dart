
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/default/default_file_location.dart';
import 'package:upgrade/default/default_upgrade_dialog.dart';
import 'package:upgrade/models/appcast.dart';
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


  /// The upgrade appcast file url.
  late final String _url;

  /// Current app version config file path.
  late final String _currentVersionPath;

  /// If true, the app will be closed when the installer is launched.
  late final bool _closeOnInstalling;

  init({
    required String url,
    required String currentVersionPath,
    bool closeOnInstalling = true,
  }) {
    _url = url;
    _currentVersionPath = currentVersionPath;
    _closeOnInstalling = closeOnInstalling;

    _stateChangeNotifier = UpgradeStateChangeNotifier();
    _loadCurrentVersion();
  }

  void checkForUpdates() async {
    _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.checking);

    final uri = Uri.parse(_url);
    final response = await Client().get(uri, headers: {'Content-Type': 'application/json;charset=utf-8'});
    if (response.statusCode != 200) {
      _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager] Download Appcast from $_url error.");
      return;
    }

    final appcast = Appcast.fromJson(List<Map<String, dynamic>>.from(json.decode(response.body)));
    final best = appcast.best();
    if (best != null) {
      _stateChangeNotifier.updateLatestVersion(version: best);
    } else {
      _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.upToDate);
    }
  }

  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool done)? onReceiveProgress,
    void Function()? done,
  }) async {
    if (status != UpgradeStatus.available) { return; }
    if (state.latest!.fileURL == null) {
      debugPrint("[UpgradeManager] There is no latest version download url in latest config file.");
      return;
    }

    final uri = Uri.parse(url ?? state.latest!.fileURL!);

    _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.downloading);

    final StreamedResponse response = await Client().send(Request('GET', uri));
    final contentLength = response.contentLength ?? 1;

    List<int> buffer = [];

    response.stream.listen((List<int> bytes) {
        buffer.addAll(bytes);
        onReceiveProgress?.call(buffer.length, contentLength, false);
      },
      onDone: () async {
        file ??= await defaultFileLocation(uri.pathSegments.last);
        await file!.writeAsBytes(buffer);
        debugPrint(file!.path);
        onReceiveProgress?.call(contentLength, contentLength, true);
        _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.readyToInstall);
        done?.call();
      },
      onError: (e) {
        _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.error);
        debugPrint("UpgradeManager: Downloading Error: ${e.toString()}");
      },
      cancelOnError: true,
    );
  }

  void showUpgradeDialog({ required BuildContext context, Widget? dialog }) {
    if (status != UpgradeStatus.readyToInstall) { return; }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog ?? const DefaultUpgradeDialog();
      },
    );
  }

  void install() {

    if (_closeOnInstalling) {
      if (Platform.isAndroid) { SystemNavigator.pop(); } else { exit(0); }
    }
  }

  void dismiss() {
    _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.dismissed);
  }

  void addListener(void Function() listener) {
    _stateChangeNotifier.addListener(listener);
  }

  void removeListener(void Function() listener) {
    _stateChangeNotifier.removeListener(listener);
  }

  void _loadCurrentVersion() {
    rootBundle.loadString(_currentVersionPath).then((value) {
      final appcast = Appcast.fromJson(List<Map<String, dynamic>>.from(json.decode(value)));
      _stateChangeNotifier.updateCurrentVersion(version: appcast.best()!);
    }).catchError((err) {
      debugPrint("[UpgradeManager] Cannot load current version info from path: $_currentVersionPath, with error: ${err.toString()}");
      if (Platform.isAndroid) { SystemNavigator.pop(); } else { exit(0); }
    });
  }

}

