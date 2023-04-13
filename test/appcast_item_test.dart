
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:upgrade/models/appcast_item.dart';

void main() {

  test("Test string parse is Correct.", () {
    final time = DateTime.now();
    final jsonStr = '''
    {
      "date": ${time.millisecondsSinceEpoch},
      "version": "1.9.8-beta+nvidia",
      "os": "android",
      "installers": [{
        "initializer": "android_app_market",
        "market": "official"
      }]
    }
    ''';

    final item = AppcastItem.fromJson(json.decode(jsonStr));


    expect(item.os!.name, OS.android.name);
    expect(item.date!.millisecondsSinceEpoch, time.millisecondsSinceEpoch);
    expect(item.version.minor, 9);
    expect(item.version.preRelease, ["beta"]);
    expect(item.version.build, "nvidia");
  });
}