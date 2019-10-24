import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_pickers/image_pickers.dart';

void main() {
  const MethodChannel channel = MethodChannel('image_pickers');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ImagePickers.platformVersion, '42');
  });
}
