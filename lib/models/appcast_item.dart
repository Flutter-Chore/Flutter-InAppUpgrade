
import 'dart:io';

import 'package:version/version.dart';

class AppcastItem {
  final String? title;
  final String? description;
  final String? releaseNotes;
  final DateTime? date;
  final Version version;
  final String? displayVersionString;
  final OS? os;
  final String? minimumSystemVersion;
  final String? maximumSystemVersion;
  final String? fileURL;

  AppcastItem({
    this.title,
    this.description,
    this.releaseNotes,
    this.date,
    required this.version,
    this.displayVersionString,
    this.os,
    this.minimumSystemVersion,
    this.maximumSystemVersion,
    this.fileURL,
  });

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
      title: json['title'],
      description: json['description'],
      releaseNotes: json['releaseNotes'],
      date: json['date'] != null ? DateTime.fromMillisecondsSinceEpoch(json['date'] as int) : null,
      version: json['version'] is String
          ? Version.parse(json['version'])
          : Version(
                json['version']['major'],
                json['version']['minor'],
                json['version']['patch'],
                preRelease: json['version']['preRelease']?.cast<String>(),
                build: json['version']['build'],
          ),
      displayVersionString: json['displayVersionString'],
      os: json['os'] != null ? OS.get(json['os']) : null,
      minimumSystemVersion: json['minimumSystemVersion'],
      maximumSystemVersion: json['maximumSystemVersion'],
      fileURL: json['fileURL'],
    );
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

