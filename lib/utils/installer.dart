
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Installer {

  static Future<void> open({required File file, void Function()? onError}) async {
    if (!file.existsSync()) {
      onError?.call();
      debugPrint("[UpgradeManager:Installer] Install file does not exists, you should download it first.");
      return;
    }

    final uri = Uri(path: file.absolute.path, scheme: 'file');
    if (!await canLaunchUrl(uri)) {
      onError?.call();
      debugPrint("[UpgradeManager:Installer] Cannot install the file at ${uri.path}.");
      return;
    }
    await launchUrl(uri);
  }

}