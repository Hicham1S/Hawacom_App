import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Service for handling Firebase Storage operations
/// Separates storage logic from repositories
class StorageService {
  final FirebaseStorage _storage;

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  StorageService._internal() : _storage = FirebaseStorage.instance;

  /// Upload avatar image for a user
  /// Returns the download URL if successful
  /// Throws StorageException on failure
  Future<String> uploadAvatar({
    required File imageFile,
    required String userId,
  }) async {
    return _uploadFile(
      file: imageFile,
      storagePath: _getAvatarPath(userId),
      contentType: 'image/jpeg',
      metadata: {
        'userId': userId,
        'uploadedAt': DateTime.now().toIso8601String(),
        'type': 'avatar',
      },
    );
  }

  /// Upload general image file
  Future<String> uploadImage({
    required File imageFile,
    required String path,
    Map<String, String>? metadata,
  }) async {
    return _uploadFile(
      file: imageFile,
      storagePath: path,
      contentType: 'image/jpeg',
      metadata: metadata,
    );
  }

  /// Upload any file type
  Future<String> uploadFile({
    required File file,
    required String path,
    String? contentType,
    Map<String, String>? metadata,
  }) async {
    return _uploadFile(
      file: file,
      storagePath: path,
      contentType: contentType,
      metadata: metadata,
    );
  }

  /// Delete file from Firebase Storage
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      debugPrint('File deleted successfully: $downloadUrl');
    } catch (e) {
      throw StorageException('Failed to delete file: $e');
    }
  }

  /// Generic file upload method
  Future<String> _uploadFile({
    required File file,
    required String storagePath,
    String? contentType,
    Map<String, String>? metadata,
  }) async {
    try {
      // Validate file exists
      if (!file.existsSync()) {
        throw StorageException('File does not exist: ${file.path}');
      }

      // Validate file size (max 10MB)
      final fileSize = file.lengthSync();
      if (fileSize > 10 * 1024 * 1024) {
        throw StorageException('File too large. Maximum size is 10MB');
      }

      debugPrint('Uploading file to: $storagePath');

      final ref = _storage.ref().child(storagePath);
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: contentType ?? 'application/octet-stream',
          customMetadata: metadata,
        ),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes * 100;
        debugPrint('Upload progress: ${progress.toStringAsFixed(1)}%');
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('Upload successful: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      debugPrint('Firebase Storage error: ${e.code} - ${e.message}');
      throw StorageException(_mapFirebaseError(e.code));
    } catch (e) {
      debugPrint('Storage upload error: $e');
      throw StorageException('Failed to upload file: $e');
    }
  }

  /// Generate avatar storage path
  String _getAvatarPath(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'avatars/$userId/avatar_$timestamp.jpg';
  }

  /// Map Firebase error codes to user-friendly messages
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'storage/unauthorized':
        return 'غير مصرح بالوصول - Unauthorized';
      case 'storage/canceled':
        return 'تم إلغاء الرفع - Upload canceled';
      case 'storage/unknown':
        return 'خطأ غير معروف - Unknown error';
      case 'storage/object-not-found':
        return 'الملف غير موجود - File not found';
      case 'storage/bucket-not-found':
        return 'التخزين غير متاح - Storage not found';
      case 'storage/quota-exceeded':
        return 'تم تجاوز حد التخزين - Storage quota exceeded';
      case 'storage/unauthenticated':
        return 'يجب تسجيل الدخول - Authentication required';
      case 'storage/retry-limit-exceeded':
        return 'فشل الرفع. حاول مرة أخرى - Upload failed, retry';
      case 'storage/invalid-checksum':
        return 'الملف تالف - File corrupted';
      default:
        return 'خطأ في الرفع: $code';
    }
  }
}

/// Custom exception for storage operations
class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
