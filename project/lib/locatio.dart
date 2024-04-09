import 'package:flutter/services.dart';

class LocationService {
  static const MethodChannel _channel = MethodChannel('location_service');

  static Future<void> startListening() async {
    try {
      await _channel.invokeMethod('startListening');
    } on PlatformException catch (e) {
      print("Failed to start listening: '${e.message}'.");
    }
  }

  static Future<void> stopListening() async {
    try {
      await _channel.invokeMethod('stopListening');
    } on PlatformException catch (e) {
      print("Failed to stop listening: '${e.message}'.");
    }
  }
}
