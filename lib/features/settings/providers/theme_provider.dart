import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app theme mode
class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'app_theme_mode';

  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Available theme modes with display info
  static const List<Map<String, dynamic>> availableThemeModes = [
    {
      'mode': ThemeMode.light,
      'name': 'فاتح',
      'nameEn': 'Light',
      'icon': Icons.light_mode,
      'value': 'light',
    },
    {
      'mode': ThemeMode.dark,
      'name': 'داكن',
      'nameEn': 'Dark',
      'icon': Icons.dark_mode,
      'value': 'dark',
    },
    {
      'mode': ThemeMode.system,
      'name': 'تلقائي (النظام)',
      'nameEn': 'System',
      'icon': Icons.brightness_auto,
      'value': 'system',
    },
  ];

  /// Initialize and load saved theme mode
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(_themeModeKey);

      if (savedThemeMode != null) {
        _themeMode = _parseThemeMode(savedThemeMode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved theme mode: $e');
    }
  }

  /// Change theme mode
  Future<void> changeThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return; // Already using this theme mode
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = _themeModeToString(mode);
      await prefs.setString(_themeModeKey, themeModeString);

      _themeMode = mode;
      notifyListeners();

      debugPrint('Theme mode changed to: $themeModeString');
    } catch (e) {
      debugPrint('Error changing theme mode: $e');
    }
  }

  /// Toggle between light and dark mode (ignores system)
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await changeThemeMode(newMode);
  }

  /// Check if theme mode is currently selected
  bool isThemeModeSelected(ThemeMode mode) {
    return _themeMode == mode;
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String value) {
    switch (value.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Convert theme mode to string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Get theme mode name in Arabic
  String getThemeModeName(ThemeMode mode) {
    final themeInfo = availableThemeModes.firstWhere(
      (info) => info['mode'] == mode,
      orElse: () => availableThemeModes.last,
    );
    return themeInfo['name'] as String;
  }

  /// Get theme mode icon
  IconData getThemeModeIcon(ThemeMode mode) {
    final themeInfo = availableThemeModes.firstWhere(
      (info) => info['mode'] == mode,
      orElse: () => availableThemeModes.last,
    );
    return themeInfo['icon'] as IconData;
  }
}
