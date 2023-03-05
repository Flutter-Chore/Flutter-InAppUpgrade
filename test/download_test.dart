
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("Test and verify Uri.parse", () {
    expect(Uri.parse("https://ganwuxi.com/v3/noob-1.4.5_beta+macos.apk").pathSegments.last, "noob-1.4.5_beta+macos.apk");
  });
}