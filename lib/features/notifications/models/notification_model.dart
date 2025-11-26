import 'package:equatable/equatable.dart';

/// Model representing a user notification
class NotificationModel extends Equatable {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final bool read;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.data,
    required this.read,
    required this.createdAt,
  });

  /// Create from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? json['data']
          : <String, dynamic>{},
      read: json['read_at'] != null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON for marking as read
  Map<String, dynamic> markReadMap() {
    return {
      'id': id,
      'read_at': !read,
    };
  }

  /// Get notification message based on type
  String getMessage() {
    if (type.contains('NewMessage') && data['from'] != null) {
      return '${data['from']} أرسل رسالة جديدة';
    } else if (data['booking_id'] != null) {
      return '#${data['booking_id']} - إشعار حجز';
    } else if (type.contains('NewBooking')) {
      return 'حجز جديد';
    } else if (type.contains('StatusChanged')) {
      return 'تغيرت حالة الحجز';
    } else {
      // Extract readable text from type
      final typeText = type.split('\\').last;
      return typeText;
    }
  }

  /// Get notification icon based on type
  String getNotificationType() {
    if (type.contains('NewMessage')) {
      return 'message';
    } else if (type.contains('Booking')) {
      return 'booking';
    } else {
      return 'general';
    }
  }

  /// Copy with method for updating specific fields
  NotificationModel copyWith({
    String? id,
    String? type,
    Map<String, dynamic>? data,
    bool? read,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, type, data, read, createdAt];
}
