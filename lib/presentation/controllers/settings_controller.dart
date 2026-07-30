import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_config.dart';

/// Manages user-facing settings: app locale and theme mode.
///
/// Preferences are persisted in [SharedPreferences] and applied immediately
/// via [Get.updateLocale] / [Get.changeThemeMode].
class SettingsController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Locale> locale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _loadPreferences() {
    // Restore theme
    final themePref = AppConfig.prefs.getString('theme_mode') ?? 'system';
    final restoredTheme = switch (themePref) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    themeMode.value = restoredTheme;
    Get.changeThemeMode(restoredTheme);

    // Restore locale
    final langCode = AppConfig.prefs.getString('locale_language') ?? 'en';
    final countryCode = AppConfig.prefs.getString('locale_country') ?? 'US';
    final restoredLocale = Locale(langCode, countryCode);
    locale.value = restoredLocale;
    Get.updateLocale(restoredLocale);
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Returns a human-readable label for the current theme mode.
  String get themeModeLabel => switch (themeMode.value) {
        ThemeMode.light => 'theme_light'.tr,
        ThemeMode.dark => 'theme_dark'.tr,
        _ => 'theme_system'.tr,
      };

  /// Returns a human-readable label for the current locale.
  String get localeLabel => locale.value.languageCode == 'id'
      ? 'lang_indonesian'.tr
      : 'lang_english'.tr;

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    final key = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await AppConfig.prefs.setString('theme_mode', key);
  }

  Future<void> setLocale(Locale newLocale) async {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
    await AppConfig.prefs.setString(
        'locale_language', newLocale.languageCode);
    await AppConfig.prefs.setString(
        'locale_country', newLocale.countryCode ?? '');
  }

  /// Cycles through: English → Bahasa Indonesia → back to English.
  Future<void> toggleLocale() async {
    final next = locale.value.languageCode == 'en'
        ? const Locale('id', 'ID')
        : const Locale('en', 'US');
    await setLocale(next);
  }
}
