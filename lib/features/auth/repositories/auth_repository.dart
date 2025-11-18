import '../../../core/repositories/base_repository.dart';
import '../../../core/config/api_config.dart';
import '../models/user_model_enhanced.dart';

/// Repository for authentication API calls
class AuthRepository extends BaseRepository {
  AuthRepository({super.apiClient});

  /// Login with email and password
  Future<UserModelEnhanced?> login({
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
        ApiConfig.login,
        data: data,
      );

      if (response.success && response.data is Map) {
        return UserModelEnhanced.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Register new user
  Future<UserModelEnhanced?> register({
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
        'password_confirmation': password, // Laravel typically requires this
        'position': isDesigner, // Designer flag
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
        ApiConfig.register,
        data: data,
      );

      if (response.success && response.data is Map) {
        return UserModelEnhanced.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user profile
  Future<UserModelEnhanced?> getCurrentUser() async {
    try {
      final response = await apiClient.get(ApiConfig.user);

      if (response.success && response.data is Map) {
        return UserModelEnhanced.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Get user by email/phone using legacy PHP endpoint
  /// This endpoint returns user data including avatar with full Media object
  Future<UserModelEnhanced?> getUserByEmailOrPhone(String emailOrPhone) async {
    try {
      final response = await apiClient.get(
        ApiConfig.getUserPhp,
        queryParameters: {'email': emailOrPhone},
      );

      if (response.success && response.data is Map) {
        return UserModelEnhanced.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  Future<UserModelEnhanced?> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    String? bio,
    String? photoUrl,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (address != null) data['address'] = address;
      if (bio != null) data['bio'] = bio;
      if (photoUrl != null) data['avatar'] = photoUrl;

      final response = await apiClient.put(
        ApiConfig.user,
        data: data,
      );

      if (response.success && response.data is Map) {
        return UserModelEnhanced.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  Future<bool> logout() async {
    try {
      final response = await apiClient.post(ApiConfig.logout);
      return response.success;
    } catch (e) {
      rethrow;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      final response = await apiClient.post(
        ApiConfig.sendResetLinkEmail,
        data: {'email': email},
      );
      return response.success;
    } catch (e) {
      rethrow;
    }
  }
}
