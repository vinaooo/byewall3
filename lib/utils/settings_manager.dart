import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static Future<void> clearAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static void closeApp() {
    SystemNavigator.pop(); // Fecha o aplicativo
  }
}
