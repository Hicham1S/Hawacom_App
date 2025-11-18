import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Session manager for persisting user authentication state
class SessionManager {
  // Singleton pattern
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  // Keys for SharedPreferences
  static const String _keyUser = 'user_data';
  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyIsLoggedIn = 'is_logged_in';

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await initialize();
    }
    return _prefs!;
  }

  /// Save user data
  Future<bool> saveUser(Map<String, dynamic> userData) async {
    try {
      final prefs = await _preferences;
      final userJson = json.encode(userData);
      await prefs.setString(_keyUser, userJson);
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  /// Get saved user data
  Future<Map<String, dynamic>?> getUser() async {
    try {
      final prefs = await _preferences;
      final userJson = prefs.getString(_keyUser);
      if (userJson != null) {
        return Map<String, dynamic>.from(json.decode(userJson));
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Save auth token
  Future<bool> saveToken(String token) async {
    try {
      final prefs = await _preferences;
      return await prefs.setString(_keyToken, token);
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  /// Get saved auth token
  Future<String?> getToken() async {
    try {
      final prefs = await _preferences;
      return prefs.getString(_keyToken);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Save refresh token
  Future<bool> saveRefreshToken(String refreshToken) async {
    try {
      final prefs = await _preferences;
      return await prefs.setString(_keyRefreshToken, refreshToken);
    } catch (e) {
      print('Error saving refresh token: $e');
      return false;
    }
  }

  /// Get saved refresh token
  Future<String?> getRefreshToken() async {
    try {
      final prefs = await _preferences;
      return prefs.getString(_keyRefreshToken);
    } catch (e) {
      print('Error getting refresh token: $e');
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await _preferences;
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Clear all session data (logout)
  Future<bool> clearSession() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(_keyUser);
      await prefs.remove(_keyToken);
      await prefs.remove(_keyRefreshToken);
      await prefs.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      print('Error clearing session: $e');
      return false;
    }
  }

  /// Clear all data
  Future<bool> clearAll() async {
    try {
      final prefs = await _preferences;
      return await prefs.clear();
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }
}
