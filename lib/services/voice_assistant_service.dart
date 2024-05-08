import 'package:flutter/services.dart';

class SiriShortcutHelper {
  static const platform = MethodChannel('com.swift.voicecommands/commands');

  static Future<void> createShortcut(String intentType) async {
    try {
      print('intentType: $intentType');
      final String result = await platform
          .invokeMethod('createShortcut', {'intentType': intentType});
      print('result: $result');
    } on PlatformException catch (e) {
      print("Failed to create shortcut: ${e.message}");
    }
  }
}
