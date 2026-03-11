import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Application-wide configuration and initialization.
class AppConfig {
  AppConfig._();

  static late SharedPreferences _prefs;

  static SharedPreferences get prefs => _prefs;

  static const String appName = 'SkyCrew';
  static const String appVersion = '1.0.0';

  static const bool isFirebaseEnabled = false; // Set to true when Firebase is configured

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isLoggedIn => _prefs.getBool('is_logged_in') ?? false;

  static Future<void> setLoggedIn({required bool value}) async {
    await _prefs.setBool('is_logged_in', value);
  }

  static String? get currentUserId => _prefs.getString('current_user_id');

  static Future<void> setCurrentUserId(String? userId) async {
    if (userId == null) {
      await _prefs.remove('current_user_id');
    } else {
      await _prefs.setString('current_user_id', userId);
    }
  }

  static Future<void> clearSession() async {
    await _prefs.remove('is_logged_in');
    await _prefs.remove('current_user_id');
  }
}
