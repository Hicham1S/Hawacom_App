import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/firebase_storage_service.dart';
import '../models/conversation.dart';
import '../models/message.dart';

/// Service for handling chat operations with Firebase Realtime Database
class FirebaseChatService {
  static final FirebaseChatService _instance = FirebaseChatService._internal();
  factory FirebaseChatService() => _instance;
  FirebaseChatService._internal();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseStorageService _storageService = FirebaseStorageService();

  // Stream controllers for real-time updates
  final Map<String, StreamController<List<Message>>> _messageStreamControllers = {};
  final Map<String, StreamSubscription> _messageSubscriptions = {};

  /// Get reference to conversations node
  DatabaseReference _conversationsRef(String userId) {
    return _database.child('conversations').child(userId);
  }

  /// Get reference to messages node
  DatabaseReference _messagesRef(String conversationId) {
    return _database.child('messages').child(conversationId);
  }

  /// Get all conversations for a user
  Future<List<Conversation>> getAllConversations(String userId) async {
    try {
      final snapshot = await _conversationsRef(userId).get();

      if (!snapshot.exists) {
        return [];
      }

      final Map<dynamic, dynamic> conversationsData = snapshot.value as Map;
      final List<Conversation> conversations = [];

      for (var entry in conversationsData.entries) {
        try {
          final conversationId = entry.key as String;
          final data = Map<String, dynamic>.from(entry.value as Map);

          // Fetch last few messages for this conversation
          final messages = await _getRecentMessages(conversationId, limit: 1);

          conversations.add(Conversation(
            id: conversationId,
            userId: data['userId'] ?? '',
            userName: data['userName'] ?? 'Unknown',
            userAvatarUrl: data['userAvatarUrl'],
            messages: messages,
            isTyping: false,
          ));
        } catch (e) {
          debugPrint('Error parsing conversation: $e');
        }
      }

      return conversations;
    } catch (e) {
      debugPrint('Error getting conversations: $e');
      return [];
    }
  }

  /// Get recent messages for a conversation
  Future<List<Message>> _getRecentMessages(String conversationId, {int limit = 50}) async {
    try {
      final snapshot = await _messagesRef(conversationId)
          .orderByChild('timestamp')
          .limitToLast(limit)
          .get();

      if (!snapshot.exists) {
        return [];
      }

      final Map<dynamic, dynamic> messagesData = snapshot.value as Map;
      final List<Message> messages = [];

      for (var entry in messagesData.entries) {
        try {
          final data = Map<String, dynamic>.from(entry.value as Map);
          messages.add(Message.fromJson(data));
        } catch (e) {
          debugPrint('Error parsing message: $e');
        }
      }

      // Sort by timestamp
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return messages;
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return [];
    }
  }

  /// Listen to messages in real-time
  Stream<List<Message>> listenToMessages(String conversationId) {
    // Return existing stream if already listening
    if (_messageStreamControllers.containsKey(conversationId)) {
      return _messageStreamControllers[conversationId]!.stream;
    }

    // Create new stream controller
    final controller = StreamController<List<Message>>.broadcast();
    _messageStreamControllers[conversationId] = controller;

    // Listen to Firebase changes
    final subscription = _messagesRef(conversationId)
        .orderByChild('timestamp')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic> messagesData = event.snapshot.value as Map;
        final List<Message> messages = [];

        for (var entry in messagesData.entries) {
          try {
            final data = Map<String, dynamic>.from(entry.value as Map);
            messages.add(Message.fromJson(data));
          } catch (e) {
            debugPrint('Error parsing message: $e');
          }
        }

        // Sort by timestamp
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        if (!controller.isClosed) {
          controller.add(messages);
        }
      } else {
        if (!controller.isClosed) {
          controller.add([]);
        }
      }
    }, onError: (error) {
      debugPrint('Error listening to messages: $error');
      if (!controller.isClosed) {
        controller.addError(error);
      }
    });

    _messageSubscriptions[conversationId] = subscription;

    return controller.stream;
  }

  /// Stop listening to messages
  void stopListeningToMessages(String conversationId) {
    _messageSubscriptions[conversationId]?.cancel();
    _messageSubscriptions.remove(conversationId);

    _messageStreamControllers[conversationId]?.close();
    _messageStreamControllers.remove(conversationId);
  }

  /// Send a text message
  Future<bool> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    try {
      final messageId = _messagesRef(conversationId).push().key;
      if (messageId == null) return false;

      final message = Message(
        id: messageId,
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        type: type,
        status: MessageStatus.sent,
        timestamp: DateTime.now(),
      );

      // Save message to Firebase
      await _messagesRef(conversationId).child(messageId).set(message.toJson());

      // Update conversation metadata for both users
      await _updateConversationMetadata(conversationId, senderId, receiverId, message);

      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  /// Send an image message
  Future<bool> sendImageMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required File imageFile,
    String content = '',
    Function(double)? onUploadProgress,
  }) async {
    try {
      // Generate message ID first
      final messageId = _messagesRef(conversationId).push().key;
      if (messageId == null) return false;

      // Upload image to Firebase Storage
      final imageUrl = await _storageService.uploadChatImage(
        imageFile: imageFile,
        conversationId: conversationId,
        messageId: messageId,
        onProgress: onUploadProgress,
      );

      if (imageUrl == null) {
        debugPrint('Failed to upload image');
        return false;
      }

      // Create message with image URL
      final message = Message(
        id: messageId,
        senderId: senderId,
        receiverId: receiverId,
        content: content.isEmpty ? 'صورة' : content,
        type: MessageType.image,
        status: MessageStatus.sent,
        timestamp: DateTime.now(),
        mediaUrl: imageUrl,
      );

      // Save message to Firebase
      await _messagesRef(conversationId).child(messageId).set(message.toJson());

      // Update conversation metadata
      await _updateConversationMetadata(conversationId, senderId, receiverId, message);

      return true;
    } catch (e) {
      debugPrint('Error sending image message: $e');
      return false;
    }
  }

  /// Update conversation metadata (last message, timestamp)
  Future<void> _updateConversationMetadata(
    String conversationId,
    String senderId,
    String receiverId,
    Message message,
  ) async {
    try {
      final updateData = {
        'lastMessage': message.content,
        'lastMessageTime': message.timestamp.toIso8601String(),
        'lastMessageType': message.type.name,
      };

      // Update for sender
      await _conversationsRef(senderId)
          .child(conversationId)
          .update(updateData);

      // Update for receiver
      await _conversationsRef(receiverId)
          .child(conversationId)
          .update(updateData);
    } catch (e) {
      debugPrint('Error updating conversation metadata: $e');
    }
  }

  /// Create or get existing conversation
  Future<String?> createConversation({
    required String userId,
    required String otherUserId,
    required String otherUserName,
    String? otherUserAvatarUrl,
  }) async {
    try {
      // Generate conversation ID (use sorted user IDs to ensure consistency)
      final List<String> userIds = [userId, otherUserId]..sort();
      final conversationId = '${userIds[0]}_${userIds[1]}';

      // Check if conversation already exists
      final snapshot = await _conversationsRef(userId).child(conversationId).get();

      if (snapshot.exists) {
        return conversationId;
      }

      // Create conversation for current user
      await _conversationsRef(userId).child(conversationId).set({
        'userId': otherUserId,
        'userName': otherUserName,
        'userAvatarUrl': otherUserAvatarUrl,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Create conversation for other user (they would see current user's info)
      // Note: You'd need to pass current user's info here
      await _conversationsRef(otherUserId).child(conversationId).set({
        'userId': userId,
        'userName': 'Current User', // TODO: Pass current user name
        'userAvatarUrl': null, // TODO: Pass current user avatar
        'createdAt': DateTime.now().toIso8601String(),
      });

      return conversationId;
    } catch (e) {
      debugPrint('Error creating conversation: $e');
      return null;
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      final snapshot = await _messagesRef(conversationId)
          .orderByChild('receiverId')
          .equalTo(userId)
          .get();

      if (!snapshot.exists) return;

      final Map<dynamic, dynamic> messagesData = snapshot.value as Map;
      final updates = <String, dynamic>{};

      for (var entry in messagesData.entries) {
        final messageId = entry.key as String;
        final data = Map<String, dynamic>.from(entry.value as Map);

        if (data['status'] != MessageStatus.read.name) {
          updates['$messageId/status'] = MessageStatus.read.name;
        }
      }

      if (updates.isNotEmpty) {
        await _messagesRef(conversationId).update(updates);
      }
    } catch (e) {
      debugPrint('Error marking messages as read: $e');
    }
  }

  /// Delete a conversation
  Future<bool> deleteConversation({
    required String userId,
    required String conversationId,
  }) async {
    try {
      // Delete conversation reference for user
      await _conversationsRef(userId).child(conversationId).remove();

      // Note: Messages are not deleted as the other user might still need them
      // If you want to delete messages when both users delete, you'd need additional logic

      return true;
    } catch (e) {
      debugPrint('Error deleting conversation: $e');
      return false;
    }
  }

  /// Cleanup: Close all streams
  void dispose() {
    for (var subscription in _messageSubscriptions.values) {
      subscription.cancel();
    }
    _messageSubscriptions.clear();

    for (var controller in _messageStreamControllers.values) {
      controller.close();
    }
    _messageStreamControllers.clear();
  }
}
