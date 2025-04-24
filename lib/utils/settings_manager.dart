import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  Future<void> clearAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void closeApp() {
    SystemNavigator.pop(); // Fecha o aplicativo
  }
}
