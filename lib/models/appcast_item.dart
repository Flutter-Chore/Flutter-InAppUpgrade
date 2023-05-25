
import 'dart:io';

import 'package:version/version.dart';

class AppcastItem {
  final dynamic releaseNotes;
  final DateTime? date;
  final Version version;
  final String? displayVersionString;
  final OS? os;
  final String? minimumSystemVersion;
  final String? maximumSystemVersion;

  late List<Map<String, dynamic>> _installersConfig;
  List<Map<String, dynamic>> get installersConfig => _installersConfig;

  AppcastItem({
    this.releaseNotes,
    this.date,
    required this.version,
    this.displayVersionString,
    this.os,
    this.minimumSystemVersion,
    this.maximumSystemVersion,
    required List<Map<String, dynamic>> installersConfig,
  }) {
    _installersConfig = installersConfig;
  }

  bool isSupportingHost() => os?.name == Platform.operatingSystem;

  bool operator>(AppcastItem item) {
    if (version > item.version) { return true; }
    return false;
  }

  bool operator<=(AppcastItem item) {
    if (version <= item.version) { return true; }
    return false;
  }

  factory AppcastItem.fromJson(Map<String, dynamic> json) {
    return AppcastItem(
      releaseNotes: json['release_notes'],
      date: json['date'] != null ? DateTime.fromMillisecondsSinceEpoch(json['date'] as int) : null,
      version: json['version'] is String
          ? Version.parse(json['version'])
          : Version(
                json['version']['major'],
                json['version']['minor'],
                json['version']['patch'],
                preRelease: json['version']['pre_release']?.cast<String>(),
                build: json['version']['build'],
          ),
      displayVersionString: json['display_version_string'],
      os: json['os'] != null ? OS.get(json['os']) : null,
      minimumSystemVersion: json['minimum_system_version'],
      maximumSystemVersion: json['maximum_system_version'],
      installersConfig: List<Map<String, dynamic>>.from(json['installers'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["release_notes"] = releaseNotes;
    map["date"] = date?.millisecondsSinceEpoch;
    map["version"] = version.toString();
    map["display_version_string"] = displayVersionString;
    map["os"] = os?.name;
    map["minimum_system_version"] = minimumSystemVersion;
    map["maximum_system_version"] = maximumSystemVersion;
    map["installers"] = installersConfig;
    return map;
  }
}


enum OS {
  android('android'),
  ios("ios"),
  macos("macos"),
  linux("linux"),
  windows("windows");

  final String name;

  const OS(this.name);

  static get(String os) => OS.values.firstWhere((element) => element.name == os);
}

