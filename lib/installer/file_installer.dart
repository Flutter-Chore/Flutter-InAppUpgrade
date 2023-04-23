
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:upgrade/core/installer.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/models/upgrade_status.dart';
import 'package:upgrade/utils/default_file_location.dart';
import 'package:url_launcher/url_launcher.dart';

class FileInstallerInitializer extends InstallInitializer {

  @override
  String get identifier => "file";

  @override
  Installer init({
    required UpgradeStateChangeNotifier state,
    required Map<String, dynamic> data,
  }) {
    return FileInstaller(
      state: state,
      fileURL: data['file_url'],
      closeOnInstalling: data['close_on_installing'] ?? true,
    );
  }

}

class FileInstaller extends Installer {

  String fileURL;
  bool closeOnInstalling;
  String? filePath;

  FileInstaller({
    required super.state,
    required this.fileURL,
    required this.closeOnInstalling,
  }) : super.init();

  @override
  bool hasDownload() => true;

  @override
  void download({
    String? url,
    File? file,
    void Function(int received, int total, bool failed)? onReceiveProgress,
    void Function()? onDone,
  }) async {
    if (status != UpgradeStatus.available) {
      debugPrint("[UpgradeManager] The update is not available.");
      return;
    }

    final uri = Uri.parse(url ?? fileURL);

    state.updateUpgradeStatus(status: UpgradeStatus.downloading);

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
        filePath = file!.absolute.path;
        state.updateUpgradeStatus(status: UpgradeStatus.readyToInstall);
        onReceiveProgress?.call(contentLength, contentLength, false);
        onDone?.call();
      },
      onError: (e) {
        onReceiveProgress?.call(buffer.length, contentLength, true);
        state.updateUpgradeStatus(status: UpgradeStatus.error);
        debugPrint("[UpgradeManager] Downloading Error: ${e.toString()}");
      },
      cancelOnError: true,
    );
  }

  @override
  Future<bool> install() async {
    if (!state.currentStatusIs(status: UpgradeStatus.readyToInstall)) { return false; }
    if (filePath == null) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager:FileInstaller] Install file doesn't exists at $filePath.");
      return false;
    }

    state.updateUpgradeStatus(status: UpgradeStatus.installing);

    final file = File(filePath!);
    if (!file.existsSync()) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager.FileInstaller] Install file does not exists, you should download it first.");
      return false;
    }

    final uri = Uri(path: file.absolute.path, scheme: 'file');
    if (!await canLaunchUrl(uri)) {
      state.updateUpgradeStatus(status: UpgradeStatus.error);
      debugPrint("[UpgradeManager:FileInstaller] Cannot install the file at ${uri.path}.");
      return false;
    }
    await launchUrl(uri);

    return true;
  }


}