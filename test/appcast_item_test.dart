
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:upgrade/models/appcast_item.dart';

void main() {

  test("Test string parse is Correct.", () {
    final time = DateTime.now();
    final jsonStr = '''
    {
      "title": "Noob",
      "tags": ["hello", "world"],
      "date": ${time.millisecondsSinceEpoch},
      "version": "1.9.8-beta+nvidia",
      "os": "android"
    }
    ''';

    final item = AppcastItem.fromJson(json.decode(jsonStr));

    expect(item.title, "Noob");
    expect(item.description, null);
    expect(item.tags, ["hello", "world"]);
    expect(item.os!.name, OS.android.name);
    expect(item.date!.millisecondsSinceEpoch, time.millisecondsSinceEpoch);
    expect(item.version.minor, 9);
    expect(item.version.preRelease, ["beta"]);
    expect(item.version.build, "nvidia");
  });
}