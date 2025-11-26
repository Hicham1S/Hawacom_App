import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app language/locale
class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  Locale _currentLocale = const Locale('ar'); // Default to Arabic

  Locale get currentLocale => _currentLocale;

  String get currentLanguageCode => _currentLocale.languageCode;

  /// Available languages
  static const List<Map<String, String>> availableLanguages = [
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  ];

  /// Initialize and load saved language
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);

      if (savedLanguage != null) {
        _currentLocale = Locale(savedLanguage);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }

  /// Change app language
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) {
      return; // Already using this language
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      _currentLocale = Locale(languageCode);
      notifyListeners();

      debugPrint('Language changed to: $languageCode');
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  /// Check if language is currently selected
  bool isLanguageSelected(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }

  /// Get language name by code
  String getLanguageName(String languageCode) {
    final language = availableLanguages.firstWhere(
      (lang) => lang['code'] == languageCode,
      orElse: () => availableLanguages.first,
    );
    return language['name'] ?? '';
  }

  /// Get language flag by code
  String getLanguageFlag(String languageCode) {
    final language = availableLanguages.firstWhere(
      (lang) => lang['code'] == languageCode,
      orElse: () => availableLanguages.first,
    );
    return language['flag'] ?? '';
  }
}
