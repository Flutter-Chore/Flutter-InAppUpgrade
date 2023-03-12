
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/default/default_file_location.dart';
import 'package:upgrade/default/default_upgrade_dialog.dart';
import 'package:upgrade/models/appcast.dart';
import 'package:upgrade/models/upgrade_status.dart';

abstract class UpgradeHandler {

  late UpgradeStateChangeNotifier _stateChangeNotifier;
  UpgradeStateChangeNotifier get state => _stateChangeNotifier;
  UpgradeStatus get status => _stateChangeNotifier.status;

  UpgradeHandler.init({required UpgradeStateChangeNotifier state}) {
    _stateChangeNotifier = state;
  }

  void checkForUpdates({ required String url }) async {
    state.updateUpgradeStatus(status: UpgradeStatus.checking);

    final uri = Uri.parse(url);
    final response = await Client().get(uri, headers: {'Content-Type': 'application/json;charset=utf-8'});
    if (response.statusCode != 200) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager] Download Appcast from $url error.");
      return;
    }

    final appcast = Appcast.fromJson(List<Map<String, dynamic>>.from(json.decode(response.body)));
    final best = appcast.best();
    if (best != null) {
      state.updateLatestVersion(version: best);
    } else {
      state.updateUpgradeStatus(status: UpgradeStatus.upToDate);
    }
  }

  void showUpgradeDialog({ required BuildContext context, Widget? dialog }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog ?? const DefaultUpgradeDialog();
      },
    );
  }

  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool done)? onReceiveProgress,
    void Function(String filePath)? onDone,
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

    response.stream.listen((bytes) async {
      buffer.addAll(bytes);
      onReceiveProgress?.call(buffer.length, contentLength, false);
    },
      onDone: () async {
        file ??= await defaultFileLocation(uri.pathSegments.last);
        await file!.writeAsBytes(buffer);
        _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.readyToInstall);
        onReceiveProgress?.call(contentLength, contentLength, true);
        onDone?.call(file!.absolute.path);
      },
      onError: (e) {
        _stateChangeNotifier.updateUpgradeStatus(status: UpgradeStatus.error);
        debugPrint("[UpgradeManager] Downloading Error: ${e.toString()}");
      },
      cancelOnError: true,
    );
  }

  void install({ String? filePath, required bool closeOnInstalling });

  void dismiss() {
    state.updateUpgradeStatus(status: UpgradeStatus.dismissed);
  }
}

