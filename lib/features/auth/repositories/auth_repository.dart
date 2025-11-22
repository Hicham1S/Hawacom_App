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
}
