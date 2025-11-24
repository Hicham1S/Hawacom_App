import 'package:dio/dio.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/user_model.dart';

/// Production-ready AuthRepository
/// Uses centralized ApiEndpoints for all endpoints
class AuthRepository extends BaseRepository {
  AuthRepository({super.apiClient});

  /// Login with email and password
  /// Returns UserModel with api_token on success
  Future<UserModel?> login({
    required String email,
    required String password,
    String? firebaseToken,
  }) async {
    try {
      final data = {
        'email': email,
        'password': password,
      };

      if (firebaseToken != null) {
        data['firebase_token'] = firebaseToken;
      }

      final response = await apiClient.post(
        ApiEndpoints.login,
        data: data,
      );

      if (response.success && response.data is Map) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Register new user
  /// Returns UserModel with api_token on success
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
    bool isDesigner = false,
    String? firebaseUid,
    String? firebaseToken,
  }) async {
    try {
      final data = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'position': isDesigner,
      };

      if (phoneNumber != null) {
        data['phone_number'] = phoneNumber;
      }

      if (firebaseUid != null) {
        data['firebase_uid'] = firebaseUid;
      }

      if (firebaseToken != null) {
        data['firebase_token'] = firebaseToken;
      }

      final response = await apiClient.post(
        ApiEndpoints.register,
        data: data,
      );

      if (response.success && response.data is Map) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user profile
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await apiClient.get(ApiEndpoints.user);

      if (response.success && response.data is Map) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  Future<bool> logout() async {
    try {
      final response = await apiClient.post(ApiEndpoints.logout);
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      return response.success;
    } catch (e) {
      rethrow;
    }
  }

  /// Get user email by phone number
  /// Used for phone login - like old getuseremail.php
  Future<String?> getUserEmailByPhone(String phoneNumber) async {
    try {
      // Clean phone number
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

      // Try the legacy endpoint - it's at /admin/api/ not /admin/public/api/
      // Use Dio directly since it's a different base path
      final dio = Dio();

      // Try different phone formats (some might be stored with + prefix)
      final formats = [
        cleanPhone,                    // 966812190671
        '+$cleanPhone',                // +966812190671
        cleanPhone.substring(3),       // 812190671 (without country code)
      ];

      for (final phone in formats) {
        final url = 'https://hawacom.sa/admin/api/getuseremail.php?email=$phone';

        try {
          final response = await dio.get(url);

          if (response.statusCode == 200 && response.data is Map) {
            final email = response.data['email'];
            // Make sure email is a valid string, not false/null/empty
            if (email != null && email is String && email.isNotEmpty && email != 'false') {
              return email;
            }
          }
        } catch (_) {
          // Try next format
          continue;
        }
      }

      return null;
    } catch (e) {
      // If legacy endpoint fails, return null (user doesn't exist)
      return null;
    }
  }

  /// Login with phone number
  /// First gets email by phone, then logs in
  Future<UserModel?> loginWithPhone({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      // Get user's actual email by phone number
      final email = await getUserEmailByPhone(phoneNumber);

      if (email == null || email.isEmpty) {
        // User not found
        return null;
      }

      // Login with the actual email
      return await login(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
