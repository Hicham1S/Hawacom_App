import 'package:equatable/equatable.dart';
import 'message.dart';

/// Represents a conversation/chat with another user
class Conversation extends Equatable {
  final String id;
  final String userId; // The other user's ID
  final String userName;
  final String? userAvatarUrl;
  final List<Message> messages;
  final bool isOnline;
  final DateTime? lastSeen;
  final bool isTyping;

  const Conversation({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.messages = const [],
    this.isOnline = false,
    this.lastSeen,
    this.isTyping = false,
  });

  /// Get last message in conversation
  Message? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  /// Get unread messages count
  int getUnreadCount(String currentUserId) {
    return messages
        .where((msg) => msg.receiverId == currentUserId && !msg.isRead)
        .length;
  }

  /// Get formatted last message preview
  String getLastMessagePreview() {
    if (messages.isEmpty) return 'لا توجد رسائل';
    final last = lastMessage!;

    switch (last.type) {
      case MessageType.text:
        return last.content;
      case MessageType.image:
        return '📷 صورة';
      case MessageType.video:
        return '🎥 فيديو';
      case MessageType.audio:
        return '🎵 تسجيل صوتي';
      case MessageType.file:
        return '📎 ملف';
    }
  }

  /// Get formatted last message time
  String getFormattedLastMessageTime() {
    if (messages.isEmpty) return '';
    final last = lastMessage!;
    final now = DateTime.now();
    final diff = now.difference(last.timestamp);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} د';
    } else if (diff.inDays < 1) {
      return '${diff.inHours} س';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} يوم';
    } else {
      return '${last.timestamp.day}/${last.timestamp.month}';
    }
  }

  /// Copy with different properties
  Conversation copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    List<Message>? messages,
    bool? isOnline,
    DateTime? lastSeen,
    bool? isTyping,
  }) {
    return Conversation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      messages: messages ?? this.messages,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'messages': messages.map((m) => m.toJson()).toList(),
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      'isTyping': isTyping,
    };
  }

  /// Create from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((m) => Message.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      isTyping: json['isTyping'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id];
}
