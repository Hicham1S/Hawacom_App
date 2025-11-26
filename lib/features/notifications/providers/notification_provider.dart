import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

/// Provider for managing notifications state
class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationProvider({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository();

  // State
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Get unread notifications
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.read).toList();

  /// Get read notifications
  List<NotificationModel> get readNotifications =>
      _notifications.where((n) => n.read).toList();

  /// Load all notifications
  Future<void> loadNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _repository.getAllNotifications();
      _unreadCount = _notifications.where((n) => !n.read).length;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في تحميل الإشعارات: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Load notifications count only
  Future<void> loadNotificationsCount() async {
    try {
      _unreadCount = await _repository.getNotificationsCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notifications count: $e');
    }
  }

  /// Refresh notifications
  Future<void> refresh() async {
    await loadNotifications();
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    _errorMessage = null;

    try {
      final success = await _repository.markAsRead(notificationId);

      if (success) {
        // Update local state
        final index =
            _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(read: true);
          _unreadCount = _notifications.where((n) => !n.read).length;
          notifyListeners();
        }
      } else {
        _errorMessage = 'فشل في تحديث حالة الإشعار';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = 'فشل في تحديث حالة الإشعار: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Remove notification
  Future<bool> removeNotification(String notificationId) async {
    _errorMessage = null;

    try {
      final success = await _repository.removeNotification(notificationId);

      if (success) {
        // Remove from local list
        final notification =
            _notifications.firstWhere((n) => n.id == notificationId);
        _notifications.removeWhere((n) => n.id == notificationId);

        // Update unread count if it was unread
        if (!notification.read) {
          _unreadCount = _notifications.where((n) => !n.read).length;
        }

        notifyListeners();
      } else {
        _errorMessage = 'فشل في حذف الإشعار';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = 'فشل في حذف الإشعار: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final unread = unreadNotifications;

    for (final notification in unread) {
      await markAsRead(notification.id);
    }
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    for (final notification in _notifications) {
      await removeNotification(notification.id);
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
