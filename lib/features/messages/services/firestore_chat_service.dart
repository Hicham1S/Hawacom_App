import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/conversation_firestore.dart';
import '../models/chat_message.dart';

/// Service for handling chat operations with Firestore
/// Compatible with old GetX implementation
class FirestoreChatService {
  static final FirestoreChatService _instance = FirestoreChatService._internal();
  factory FirestoreChatService() => _instance;
  FirestoreChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Get messages collection (these are conversations in the old system)
  CollectionReference get _messagesCollection => _firestore.collection('messages');

  /// Get all conversations for a user
  /// In the old system, these were called "messages" but they're actually conversations
  Future<List<ConversationFirestore>> getAllConversations(String userId) async {
    try {
      final QuerySnapshot snapshot = await _messagesCollection
          .where('visible_to_users', arrayContains: userId)
          .orderBy('time', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ConversationFirestore.fromDocument(doc))
          .toList();
    } catch (e) {
      debugPrint('Error getting conversations: $e');
      return [];
    }
  }

  /// Listen to conversations in real-time
  Stream<List<ConversationFirestore>> listenToConversations(String userId) {
    try {
      return _messagesCollection
          .where('visible_to_users', arrayContains: userId)
          .orderBy('time', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ConversationFirestore.fromDocument(doc))
            .toList();
      });
    } catch (e) {
      debugPrint('Error listening to conversations: $e');
      return Stream.value([]);
    }
  }

  /// Get chat messages for a conversation
  /// In Firestore: /messages/{conversationId}/chats
  Stream<List<ChatMessage>> listenToChatMessages(String conversationId) {
    try {
      return _messagesCollection
          .doc(conversationId)
          .collection('chats')
          .orderBy('time', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ChatMessage.fromDocument(doc))
            .toList();
      });
    } catch (e) {
      debugPrint('Error listening to chat messages: $e');
      return Stream.value([]);
    }
  }

  /// Send a text message
  Future<bool> sendTextMessage({
    required String conversationId,
    required String senderId,
    required String messageText,
    String? price,
  }) async {
    try {
      final chatMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: messageText,
        time: DateTime.now().millisecondsSinceEpoch,
        userId: senderId,
        price: price ?? '',
      );

      // Add message to subcollection
      await _messagesCollection
          .doc(conversationId)
          .collection('chats')
          .add(chatMessage.toJson());

      // Update conversation metadata
      await _messagesCollection.doc(conversationId).update({
        'message': messageText,
        'time': chatMessage.time,
        'read_by_users': [senderId],
      });

      return true;
    } catch (e) {
      debugPrint('Error sending text message: $e');
      return false;
    }
  }

  /// Send an image message
  Future<bool> sendImageMessage({
    required String conversationId,
    required String senderId,
    required File imageFile,
    String? caption,
  }) async {
    try {
      // Upload image to Firebase Storage
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final String path = 'chat_images/$conversationId/$fileName';

      final Reference ref = _storage.ref().child(path);
      final UploadTask task = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await task;
      final String imageUrl = await snapshot.ref.getDownloadURL();

      // Send as text message with image URL
      return await sendTextMessage(
        conversationId: conversationId,
        senderId: senderId,
        messageText: imageUrl,
      );
    } catch (e) {
      debugPrint('Error sending image message: $e');
      return false;
    }
  }

  /// Upload file and return URL
  Future<String?> uploadFile(File file) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final String path = 'chat_files/$fileName';

      final Reference ref = _storage.ref().child(path);
      final UploadTask task = ref.putFile(file);
      final TaskSnapshot snapshot = await task;
      final String fileUrl = await snapshot.ref.getDownloadURL();

      return fileUrl;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }

  /// Create a new conversation
  Future<String?> createConversation({
    required String currentUserId,
    required String currentUserName,
    required String currentUserAvatar,
    required String otherUserId,
    required String otherUserName,
    required String otherUserAvatar,
    required String conversationName,
  }) async {
    try {
      // Create conversation data matching old format
      final conversationData = {
        'name': conversationName,
        'users': [
          {
            'id': currentUserId,
            'name': currentUserName,
            'thumb': currentUserAvatar,
          },
          {
            'id': otherUserId,
            'name': otherUserName,
            'thumb': otherUserAvatar,
          },
        ],
        'visible_to_users': [currentUserId, otherUserId],
        'read_by_users': [],
        'message': '',
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      final docRef = await _messagesCollection.add(conversationData);
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating conversation: $e');
      return null;
    }
  }

  /// Mark conversation as read
  Future<void> markAsRead(String conversationId, String userId) async {
    try {
      final doc = await _messagesCollection.doc(conversationId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final List<String> readByUsers = List<String>.from(data['read_by_users'] ?? []);

        if (!readByUsers.contains(userId)) {
          readByUsers.add(userId);
          await _messagesCollection.doc(conversationId).update({
            'read_by_users': readByUsers,
          });
        }
      }
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  /// Delete a conversation
  Future<bool> deleteConversation(String conversationId) async {
    try {
      // Delete all chat messages first
      final chatsSnapshot = await _messagesCollection
          .doc(conversationId)
          .collection('chats')
          .get();

      for (var doc in chatsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete conversation
      await _messagesCollection.doc(conversationId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting conversation: $e');
      return false;
    }
  }

  /// Get conversation by ID
  Future<ConversationFirestore?> getConversation(String conversationId) async {
    try {
      final doc = await _messagesCollection.doc(conversationId).get();
      if (doc.exists) {
        return ConversationFirestore.fromDocument(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting conversation: $e');
      return null;
    }
  }

  /// Check if conversation exists between two users
  Future<String?> findExistingConversation(String userId1, String userId2) async {
    try {
      final QuerySnapshot snapshot = await _messagesCollection
          .where('visible_to_users', arrayContains: userId1)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List<String> visibleTo = List<String>.from(data['visible_to_users'] ?? []);

        if (visibleTo.contains(userId2)) {
          return doc.id;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error finding existing conversation: $e');
      return null;
    }
  }
}
