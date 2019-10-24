import 'dart:async';

import 'package:flutter/services.dart';

class ImagePickers {
  static const MethodChannel _channel =
      const MethodChannel('image_pickers');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
