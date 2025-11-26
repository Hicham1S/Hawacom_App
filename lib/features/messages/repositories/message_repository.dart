import 'package:flutter/foundation.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../services/firestore_chat_service.dart';
import '../services/chat_service.dart';

/// Repository for message-related operations
/// Abstracts data source (Firestore/Mock) from business logic
class MessageRepository {
  final bool _useFirestore;

  MessageRepository({
    FirestoreChatService? firestoreService,
    bool useFirestore = true,
  })  : _useFirestore = useFirestore;

  /// Get all conversations
  /// If useFirestore is false, uses mock data
  Future<List<Conversation>> getAllConversations() async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        // For now, fallback to mock data
        return ChatService.getAllConversations();
      } else {
        return ChatService.getAllConversations();
      }
    } catch (e) {
      debugPrint('Error getting conversations: $e');
      return [];
    }
  }

  /// Get conversation by ID
  Future<Conversation?> getConversationById(String conversationId) async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        return ChatService.getConversationById(conversationId);
      } else {
        return ChatService.getConversationById(conversationId);
      }
    } catch (e) {
      debugPrint('Error getting conversation $conversationId: $e');
      return null;
    }
  }

  /// Get conversation by user ID
  Future<Conversation?> getConversationByUserId(String userId) async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        return ChatService.getConversationByUserId(userId);
      } else {
        return ChatService.getConversationByUserId(userId);
      }
    } catch (e) {
      debugPrint('Error getting conversation for user $userId: $e');
      return null;
    }
  }

  /// Send a message
  Future<bool> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        return await ChatService.sendMessage(
          conversationId: conversationId,
          content: content,
          type: type,
        );
      } else {
        return await ChatService.sendMessage(
          conversationId: conversationId,
          content: content,
          type: type,
        );
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  /// Mark conversation as read
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        await ChatService.markConversationAsRead(conversationId);
      } else {
        await ChatService.markConversationAsRead(conversationId);
      }
    } catch (e) {
      debugPrint('Error marking conversation as read: $e');
    }
  }

  /// Get total unread count
  Future<int> getTotalUnreadCount() async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        return ChatService.getTotalUnreadCount();
      } else {
        return ChatService.getTotalUnreadCount();
      }
    } catch (e) {
      debugPrint('Error getting unread count: $e');
      return 0;
    }
  }

  /// Create a new conversation
  Future<Conversation?> createConversation({
    required String userId,
    required String userName,
    String? userAvatarUrl,
  }) async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        return await ChatService.createConversation(
          userId: userId,
          userName: userName,
          userAvatarUrl: userAvatarUrl,
        );
      } else {
        return await ChatService.createConversation(
          userId: userId,
          userName: userName,
          userAvatarUrl: userAvatarUrl,
        );
      }
    } catch (e) {
      debugPrint('Error creating conversation: $e');
      return null;
    }
  }

  /// Delete a conversation
  Future<bool> deleteConversation(String conversationId) async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        return await ChatService.deleteConversation(conversationId);
      } else {
        return await ChatService.deleteConversation(conversationId);
      }
    } catch (e) {
      debugPrint('Error deleting conversation: $e');
      return false;
    }
  }

  /// Search conversations
  Future<List<Conversation>> searchConversations(String query) async {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        return ChatService.searchConversations(query);
      } else {
        return ChatService.searchConversations(query);
      }
    } catch (e) {
      debugPrint('Error searching conversations: $e');
      return [];
    }
  }

  /// Set typing indicator
  void setTypingIndicator(String conversationId, bool isTyping) {
    try {
      if (_useFirestore) {
        // Firestore implementation would go here
        ChatService.setTypingIndicator(conversationId, isTyping);
      } else {
        ChatService.setTypingIndicator(conversationId, isTyping);
      }
    } catch (e) {
      debugPrint('Error setting typing indicator: $e');
    }
  }

  /// Get current user ID
  String get currentUserId => ChatService.currentUserId;
}
