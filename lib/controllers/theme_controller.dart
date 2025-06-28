import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/_themes.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_preference';

  final RxBool _isDarkMode = false.obs;
  final RxBool _isSystemTheme = true.obs;

  bool get isDarkMode => _isDarkMode.value;
  bool get isSystemTheme => _isSystemTheme.value;

  ThemeMode get themeMode {
    if (_isSystemTheme.value) {
      return ThemeMode.system;
    }
    return _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      if (savedTheme == null) {
        // First time, use system theme
        _useSystemTheme();
      } else if (savedTheme == 'system') {
        _useSystemTheme();
      } else {
        _isSystemTheme.value = false;
        _isDarkMode.value = savedTheme == 'dark';
      }

      // Apply theme after loading preferences
      _applyTheme();
    } catch (e) {
      log('Error loading theme preference: $e');
      _useSystemTheme();
    }
  }

  Future<void> _saveThemeToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_isSystemTheme.value) {
        await prefs.setString(_themeKey, 'system');
      } else {
        await prefs.setString(_themeKey, _isDarkMode.value ? 'dark' : 'light');
      }
    } catch (e) {
      log('Error saving theme preference: $e');
    }
  }

  void toggleTheme() {
    if (_isSystemTheme.value) {
      // If currently using system theme, switch to opposite of current system theme
      _isSystemTheme.value = false;
      _isDarkMode.value = !_isDarkMode.value;
    } else {
      // If using manual theme, just toggle
      _isDarkMode.value = !_isDarkMode.value;
    }

    _applyTheme();
    _saveThemeToPrefs();

    Get.snackbar(
      'Theme Changed',
      _isDarkMode.value ? 'Dark theme enabled' : 'Light theme enabled',
      duration: const Duration(seconds: 1),
      backgroundColor: primaryColor.withValues(alpha: 0.1),
      colorText: primaryColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void useSystemTheme() {
    _useSystemTheme();
    _applyTheme();
    _saveThemeToPrefs();

    Get.snackbar(
      'Theme Changed',
      'Using system theme',
      duration: const Duration(seconds: 1),
      backgroundColor: primaryColor.withValues(alpha: 0.1),
      colorText: primaryColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setLightTheme() {
    _isSystemTheme.value = false;
    _isDarkMode.value = false;
    _applyTheme();
    _saveThemeToPrefs();

    Get.snackbar(
      'Theme Changed',
      'Light theme enabled',
      duration: const Duration(seconds: 1),
      backgroundColor: primaryColor.withValues(alpha: 0.1),
      colorText: primaryColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setDarkTheme() {
    _isSystemTheme.value = false;
    _isDarkMode.value = true;
    _applyTheme();
    _saveThemeToPrefs();

    Get.snackbar(
      'Theme Changed',
      'Dark theme enabled',
      duration: const Duration(seconds: 1),
      backgroundColor: primaryColor.withValues(alpha: 0.1),
      colorText: primaryColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _useSystemTheme() {
    _isSystemTheme.value = true;
    _updateThemeBasedOnSystem();
  }

  void _updateThemeBasedOnSystem() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _isDarkMode.value = brightness == Brightness.dark;
  }

  void _applyTheme() {
    // Force update theme mode
    Get.changeThemeMode(themeMode);
  }

  // Method to get theme status text for UI
  String get themeStatusText {
    if (_isSystemTheme.value) {
      return 'System (${_isDarkMode.value ? 'Dark' : 'Light'})';
    }
    return _isDarkMode.value ? 'Dark' : 'Light';
  }

  // Method to get appropriate icon for current theme
  IconData get themeIcon {
    if (_isSystemTheme.value) {
      return Icons.brightness_auto;
    }
    return _isDarkMode.value ? Icons.dark_mode : Icons.light_mode;
  }

  // Listen to system theme changes when using system theme
  void onSystemThemeChanged() {
    if (_isSystemTheme.value) {
      _updateThemeBasedOnSystem();
      _applyTheme();
    }
  }

  // For debugging
  void printThemeStatus() {
    log('Theme Status:');
    log('  - Is System Theme: ${_isSystemTheme.value}');
    log('  - Is Dark Mode: ${_isDarkMode.value}');
    log('  - Theme Mode: $themeMode');
  }

  @override
  void onClose() {
    // Save theme preference when controller is disposed
    _saveThemeToPrefs();
    super.onClose();
  }
}
