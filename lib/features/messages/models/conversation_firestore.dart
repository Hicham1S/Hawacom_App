import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// User data in conversation (simplified from old system)
class ConversationUser {
  final String id;
  final String name;
  final String? avatar;

  const ConversationUser({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory ConversationUser.fromJson(Map<String, dynamic> json) {
    return ConversationUser(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      avatar: json['thumb']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumb': avatar,
    };
  }
}

/// Represents a conversation in Firestore
/// Compatible with old GetX "Message" model (which was actually a conversation)
class ConversationFirestore extends Equatable {
  final String id;
  final String name; // Conversation name
  final List<ConversationUser> users;
  final List<String> visibleToUsers;
  final List<String> readByUsers;
  final String lastMessage;
  final int lastMessageTime; // milliseconds since epoch

  const ConversationFirestore({
    required this.id,
    required this.name,
    required this.users,
    required this.visibleToUsers,
    required this.readByUsers,
    this.lastMessage = '',
    this.lastMessageTime = 0,
  });

  /// Create from Firestore DocumentSnapshot
  factory ConversationFirestore.fromDocument(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      return ConversationFirestore(
        id: doc.id,
        name: data['name']?.toString() ?? '',
        users: (data['users'] as List<dynamic>?)
                ?.map((u) => ConversationUser.fromJson(u as Map<String, dynamic>))
                .toList() ??
            [],
        visibleToUsers: List<String>.from(data['visible_to_users'] ?? []),
        readByUsers: List<String>.from(data['read_by_users'] ?? []),
        lastMessage: data['message']?.toString() ?? '',
        lastMessageTime: data['time'] as int? ?? 0,
      );
    } catch (e) {
      return ConversationFirestore(
        id: doc.id,
        name: '',
        users: [],
        visibleToUsers: [],
        readByUsers: [],
        lastMessage: '',
        lastMessageTime: 0,
      );
    }
  }

  /// Convert to Firestore map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'users': users.map((u) => u.toJson()).toList(),
      'visible_to_users': visibleToUsers,
      'read_by_users': readByUsers,
      'message': lastMessage,
      'time': lastMessageTime,
    };
  }

  /// Get the other user in conversation (for 1-on-1 chats)
  ConversationUser? getOtherUser(String currentUserId) {
    try {
      return users.firstWhere((u) => u.id != currentUserId);
    } catch (e) {
      return null;
    }
  }

  /// Check if conversation is unread for user
  bool isUnread(String userId) {
    return !readByUsers.contains(userId);
  }

  /// Get formatted time
  String getFormattedTime() {
    if (lastMessageTime == 0) return '';

    final DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(lastMessageTime);
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(messageTime);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} د';
    } else if (diff.inDays < 1) {
      return '${diff.inHours} س';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} يوم';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }

  @override
  List<Object?> get props => [id];
}
