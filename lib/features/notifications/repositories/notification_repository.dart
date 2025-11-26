import 'package:flutter/foundation.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/notification_model.dart';

/// Repository for notification-related API calls
class NotificationRepository extends BaseRepository {
  NotificationRepository({super.apiClient});

  /// Get all user notifications
  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final response = await apiClient.get(
        'notifications',
        queryParameters: {
          'limit': 50,
          'fields': 'id;type;data;read_at;created_at',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) =>
                NotificationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting notifications: $e');
      return [];
    }
  }

  /// Get unread notifications count
  Future<int> getNotificationsCount() async {
    try {
      final response = await apiClient.get('notifications/count');

      if (response.success && response.data != null) {
        // Handle different response formats
        if (response.data is int) {
          return response.data;
        } else if (response.data is Map) {
          return response.data['count'] ?? 0;
        }
      }

      return 0;
    } catch (e) {
      debugPrint('Error getting notifications count: $e');
      return 0;
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await apiClient.put(
        'notifications/$notificationId',
        data: {'read_at': DateTime.now().toIso8601String()},
      );

      return response.success;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }

  /// Remove/delete notification
  Future<bool> removeNotification(String notificationId) async {
    try {
      final response = await apiClient.delete('notifications/$notificationId');
      return response.success;
    } catch (e) {
      debugPrint('Error removing notification: $e');
      return false;
    }
  }

  /// Send notification to users (admin feature)
  Future<bool> sendNotification({
    required List<String> userIds,
    required String type,
    required String text,
    String? relatedId,
  }) async {
    try {
      final response = await apiClient.post(
        'notifications',
        data: {
          'users': userIds,
          'type': type,
          'text': text,
          if (relatedId != null) 'id': relatedId,
        },
      );

      return response.success;
    } catch (e) {
      debugPrint('Error sending notification: $e');
      return false;
    }
  }
}
