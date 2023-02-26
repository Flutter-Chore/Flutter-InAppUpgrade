import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upgrade/upgrade_method_channel.dart';

void main() {
  MethodChannelUpgrade platform = MethodChannelUpgrade();
  const MethodChannel channel = MethodChannel('upgrade');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
