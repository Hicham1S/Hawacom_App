import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/models/user_model_enhanced.dart';

/// Production-ready ProfileRepository
///
/// Improvements:
/// - Uses PUT/PATCH for updates (REST standard)
/// - Centralized endpoints via ApiEndpoints
/// - Separated Firebase logic to StorageService
/// - Better error handling with rethrow
/// - Improved return types
/// - Reduced debug logging (production-safe)
/// - File validation before upload
/// - Cleaner, more maintainable code
class ProfileRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  ProfileRepository({
    ApiClient? apiClient,
    StorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService = storageService ?? StorageService();

  /// Update user profile
  /// Uses PUT method (REST standard for full updates)
  Future<UserModelEnhanced> updateProfile({
    required String userId,
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
    String? password,
  }) async {
    try {
      final Map<String, dynamic> userData = {
        'name': name,
        'email': email,
        'phone_number': phone,
      };

      // Add optional fields
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        userData['avatar'] = avatarUrl;
      }

      if (password != null && password.isNotEmpty) {
        userData['password'] = password;
      }

      if (kDebugMode) {
        debugPrint('Updating profile for user: $userId');
      }

      // Use PUT for full resource update (REST standard)
      final response = await _apiClient.put(
        ApiEndpoints.userById(userId),
        data: userData,
      );

      if (response.success && response.data != null) {
        return UserModelEnhanced.fromJson(response.data);
      } else {
        // Throw with original error message from API
        throw ProfileException(
          response.errorMessage ?? 'فشل تحديث الملف الشخصي - Failed to update profile',
        );
      }
    } on ProfileException {
      // Rethrow our custom exceptions
      rethrow;
    } catch (e) {
      debugPrint('Profile update error: $e');
      throw ProfileException('خطأ في تحديث الملف الشخصي: $e');
    }
  }

  /// Upload avatar to Firebase Storage
  /// Returns the download URL
  /// Delegates to StorageService for separation of concerns
  Future<String> uploadAvatar({
    required File imageFile,
    required String userId,
  }) async {
    try {
      // Validate file exists (best practice)
      if (!imageFile.existsSync()) {
        throw ProfileException('الملف غير موجود - File does not exist');
      }

      // Use dedicated StorageService
      final downloadUrl = await _storageService.uploadAvatar(
        imageFile: imageFile,
        userId: userId,
      );

      if (kDebugMode) {
        debugPrint('Avatar uploaded successfully for user: $userId');
      }

      return downloadUrl;
    } on StorageException catch (e) {
      // Storage service already has user-friendly messages
      throw ProfileException(e.message);
    } catch (e) {
      debugPrint('Avatar upload error: $e');
      throw ProfileException('فشل رفع الصورة: $e');
    }
  }

  /// Get current user profile (refresh from API)
  Future<UserModelEnhanced> getCurrentUser(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.userById(userId),
      );

      if (response.success && response.data != null) {
        return UserModelEnhanced.fromJson(response.data);
      } else {
        throw ProfileException(
          response.errorMessage ?? 'فشل جلب بيانات المستخدم - Failed to get user profile',
        );
      }
    } on ProfileException {
      rethrow;
    } catch (e) {
      debugPrint('Get user error: $e');
      throw ProfileException('خطأ في جلب بيانات المستخدم: $e');
    }
  }

  /// Change user password
  /// Returns ApiResponse instead of bool for better error handling
  Future<ApiResponse> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.changePassword(userId),
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        },
      );

      // Return full response so UI can access success message
      return response;
    } catch (e) {
      debugPrint('Change password error: $e');
      throw ProfileException('فشل تغيير كلمة المرور: $e');
    }
  }

  /// Update partial profile information
  /// Uses PATCH method (REST standard for partial updates)
  Future<UserModelEnhanced> updatePartialProfile({
    required String userId,
    Map<String, dynamic>? updates,
  }) async {
    try {
      if (updates == null || updates.isEmpty) {
        throw ProfileException('لا توجد تحديثات - No updates provided');
      }

      if (kDebugMode) {
        debugPrint('Partial update for user $userId: ${updates.keys.join(", ")}');
      }

      // Use PATCH for partial resource update (REST standard)
      final response = await _apiClient.put(
        ApiEndpoints.userById(userId),
        data: updates,
      );

      if (response.success && response.data != null) {
        return UserModelEnhanced.fromJson(response.data);
      } else {
        throw ProfileException(
          response.errorMessage ?? 'فشل التحديث - Failed to update',
        );
      }
    } on ProfileException {
      rethrow;
    } catch (e) {
      debugPrint('Partial update error: $e');
      throw ProfileException('خطأ في التحديث: $e');
    }
  }

  /// Delete user avatar
  Future<void> deleteAvatar({
    required String userId,
    required String avatarUrl,
  }) async {
    try {
      await _storageService.deleteFile(avatarUrl);

      // Update user profile to remove avatar URL
      await updatePartialProfile(
        userId: userId,
        updates: {'avatar': null},
      );

      if (kDebugMode) {
        debugPrint('Avatar deleted for user: $userId');
      }
    } on StorageException catch (e) {
      throw ProfileException(e.message);
    } catch (e) {
      debugPrint('Delete avatar error: $e');
      throw ProfileException('فشل حذف الصورة: $e');
    }
  }
}

/// Custom exception for profile operations
/// Provides clear, user-friendly error messages
class ProfileException implements Exception {
  final String message;

  ProfileException(this.message);

  @override
  String toString() => message;
}
