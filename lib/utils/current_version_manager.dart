
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrade/models/appcast.dart';
import 'package:upgrade/models/appcast_item.dart';

class CurrentVersionManager {

  static void load(String path, bool crashIfNoLegalConfigFile, void Function(AppcastItem? version) onDone) {
    rootBundle.loadString(path).then((value) {
      final appcast = Appcast.fromJson(List<Map<String, dynamic>>.from(json.decode(value)));
      onDone.call(appcast.best()!);
    }).catchError((err) {
      debugPrint("[UpgradeManager] Cannot load current version info from path: $path, with error: ${err.toString()}");
      if (!crashIfNoLegalConfigFile) {
        onDone.call(null);
        return;
      }
      if (Platform.isAndroid) { SystemNavigator.pop(); } else { exit(0); }
    });
  }
}