import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsStorage {
  static const _themeKey = 'is_dark_theme';
  static const _fromRandomTestKey = 'from_random_test';

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, mode == ThemeMode.dark);
  }

  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey);
    if (isDark == null) return ThemeMode.system;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> setFromRandomTest(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fromRandomTestKey, value);
  }

  static Future<bool> getFromRandomTest() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_fromRandomTestKey);
    debugPrint('📦 SettingsStorage.getFromRandomTest() = $value');
    return value ?? false;
  }

  static Future<void> clearFromRandomTest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fromRandomTestKey);
  }

  /// Получает булевое значение по ключу из SharedPreferences.
  /// Получает булевое значение по ключу из SharedPreferences.
  static Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(key) ?? false; // ⬅️ добавили fallback
    debugPrint('📦 SettingsStorage.getBool($key) = $value');
    return value;
  }
}
