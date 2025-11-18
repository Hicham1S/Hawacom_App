import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Service for uploading files to Firebase Storage
class FirebaseStorageService {
  static final FirebaseStorageService _instance = FirebaseStorageService._internal();
  factory FirebaseStorageService() => _instance;
  FirebaseStorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload image file to Firebase Storage
  /// Returns the download URL if successful, null otherwise
  Future<String?> uploadChatImage({
    required File imageFile,
    required String conversationId,
    required String messageId,
    Function(double)? onProgress,
  }) async {
    try {
      // Create a unique path for the image
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final String path = 'chat_images/$conversationId/$fileName';

      // Create reference to the file location
      final Reference ref = _storage.ref().child(path);

      // Upload file
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'messageId': messageId,
            'conversationId': conversationId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  /// Upload user avatar to Firebase Storage
  Future<String?> uploadUserAvatar({
    required File imageFile,
    required String userId,
    Function(double)? onProgress,
  }) async {
    try {
      final String fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = 'user_avatars/$userId/$fileName';

      final Reference ref = _storage.ref().child(path);

      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('Avatar uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      return null;
    }
  }

  /// Delete an image from Firebase Storage
  Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract path from URL
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      debugPrint('Image deleted successfully: $imageUrl');
      return true;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Get metadata of an uploaded file
  Future<FullMetadata?> getFileMetadata(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      final FullMetadata metadata = await ref.getMetadata();
      return metadata;
    } catch (e) {
      debugPrint('Error getting metadata: $e');
      return null;
    }
  }
}
