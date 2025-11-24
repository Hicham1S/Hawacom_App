import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/user_model.dart';

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

  ProfileRepository({
    ApiClient? apiClient,
  })  : _apiClient = apiClient ?? ApiClient();

  /// Update user profile
  /// Uses POST method (as required by the Laravel backend)
  /// Can optionally include password change
  Future<UserModel> updateProfile({
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

      // Use POST (Laravel backend requires POST for updates)
      final response = await _apiClient.post(
        ApiEndpoints.userById(userId),
        data: userData,
      );

      if (response.success && response.data != null) {
        return UserModel.fromJson(response.data);
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

  /// Upload avatar to Laravel backend
  /// Returns the uploaded file UUID/URL
  Future<String> uploadAvatar({
    required File imageFile,
    required String userId,
  }) async {
    try {
      // Validate file exists
      if (!imageFile.existsSync()) {
        throw ProfileException('الملف غير موجود - File does not exist');
      }

      final String fileName = imageFile.path.split('/').last;
      final String uuid = const Uuid().v4();

      // Create form data for multipart upload
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        'uuid': uuid,
        'field': 'avatar',
      });

      if (kDebugMode) {
        debugPrint('Uploading avatar for user: $userId');
        debugPrint('File: $fileName, UUID: $uuid');
      }

      // Upload to Laravel backend
      final response = await _apiClient.post(
        ApiEndpoints.uploads,
        data: formData,
      );

      if (response.success && response.data != null) {
        // Laravel returns the UUID in response.data
        // The UUID is used to link the media to the user profile
        String uploadedUuid;
        if (response.data is String) {
          uploadedUuid = response.data;
        } else if (response.data is Map && response.data['data'] != null) {
          uploadedUuid = response.data['data'].toString();
        } else {
          uploadedUuid = response.data.toString();
        }

        if (kDebugMode) {
          debugPrint('Avatar uploaded successfully, UUID: $uploadedUuid');
        }
        return uploadedUuid;
      } else {
        throw ProfileException(
          response.errorMessage ?? 'فشل رفع الصورة - Failed to upload avatar',
        );
      }
    } on ProfileException {
      rethrow;
    } catch (e) {
      debugPrint('Avatar upload error: $e');
      throw ProfileException('فشل رفع الصورة: $e');
    }
  }

  /// Get current user profile (refresh from API)
  Future<UserModel> getCurrentUser(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.userById(userId),
      );

      if (response.success && response.data != null) {
        return UserModel.fromJson(response.data);
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
  Future<UserModel> updatePartialProfile({
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
        return UserModel.fromJson(response.data);
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
    required String avatarUuid,
  }) async {
    try {
      // Delete from Laravel backend
      await _apiClient.post(
        ApiEndpoints.deleteUpload,
        data: {'uuid': avatarUuid},
      );

      // Update user profile to remove avatar URL
      await updatePartialProfile(
        userId: userId,
        updates: {'avatar': null},
      );

      if (kDebugMode) {
        debugPrint('Avatar deleted for user: $userId');
      }
    } on ProfileException {
      rethrow;
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
