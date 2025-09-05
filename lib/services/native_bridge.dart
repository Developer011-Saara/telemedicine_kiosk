import 'package:flutter/services.dart';

class NativeBridge {
  static const MethodChannel _channel = MethodChannel('kioskModeLocked');

  static Future<void> enableKioskMode() async {
    await _channel.invokeMethod('startKioskMode');
  }

  static Future<void> disableKioskMode() async {
    await _channel.invokeMethod('stopKioskMode');
  }
}
