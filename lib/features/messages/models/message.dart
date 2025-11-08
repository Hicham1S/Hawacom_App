import 'package:equatable/equatable.dart';

/// Message types for future extensibility
enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}

/// Status of a message
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

/// Individual message in a conversation
class Message extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final String? mediaUrl; // For future image/video messages

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    required this.timestamp,
    this.mediaUrl,
  });

  /// Check if message was sent by current user
  bool isSentByMe(String currentUserId) => senderId == currentUserId;

  /// Check if message is read
  bool get isRead => status == MessageStatus.read;

  /// Copy with different properties
  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? mediaUrl,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'mediaUrl': mediaUrl,
    };
  }

  /// Create from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      mediaUrl: json['mediaUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [id];
}
