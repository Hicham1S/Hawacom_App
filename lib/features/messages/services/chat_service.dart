import '../models/conversation.dart';
import '../models/message.dart';
import '../data/mock_conversations.dart';

/// Service for handling chat/messaging operations
/// Separates business logic from UI
class ChatService {
  static const String currentUserId = MockConversations.currentUserId;

  // In-memory storage (replace with backend/database later)
  static final List<Conversation> _conversations =
      MockConversations.getAllConversations();

  /// Get all conversations sorted by last message time
  static List<Conversation> getAllConversations() {
    // Sort by last message timestamp (most recent first)
    final sorted = List<Conversation>.from(_conversations);
    sorted.sort((a, b) {
      final aTime = a.lastMessage?.timestamp ?? DateTime(2000);
      final bTime = b.lastMessage?.timestamp ?? DateTime(2000);
      return bTime.compareTo(aTime);
    });
    return sorted;
  }

  /// Get a specific conversation by ID
  static Conversation? getConversationById(String conversationId) {
    try {
      return _conversations.firstWhere((c) => c.id == conversationId);
    } catch (e) {
      return null;
    }
  }

  /// Get conversation by user ID (find existing chat with a user)
  static Conversation? getConversationByUserId(String userId) {
    try {
      return _conversations.firstWhere((c) => c.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Send a new message
  static Future<bool> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final conversation = getConversationById(conversationId);
      if (conversation == null) return false;

      final newMessage = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: currentUserId,
        receiverId: conversation.userId,
        content: content,
        type: type,
        status: MessageStatus.sent,
        timestamp: DateTime.now(),
      );

      // Update conversation with new message
      final updatedMessages = List<Message>.from(conversation.messages)
        ..add(newMessage);
      final updatedConversation = conversation.copyWith(
        messages: updatedMessages,
        isTyping: false,
      );

      // Replace conversation in list
      final index = _conversations.indexWhere((c) => c.id == conversationId);
      if (index != -1) {
        _conversations[index] = updatedConversation;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mark all messages in a conversation as read
  static Future<void> markConversationAsRead(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final conversation = getConversationById(conversationId);
    if (conversation == null) return;

    final updatedMessages = conversation.messages.map((msg) {
      if (msg.receiverId == currentUserId && !msg.isRead) {
        return msg.copyWith(status: MessageStatus.read);
      }
      return msg;
    }).toList();

    final updatedConversation = conversation.copyWith(messages: updatedMessages);
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = updatedConversation;
    }
  }

  /// Get total unread messages count across all conversations
  static int getTotalUnreadCount() {
    int total = 0;
    for (var conversation in _conversations) {
      total += conversation.getUnreadCount(currentUserId);
    }
    return total;
  }

  /// Set typing indicator for a conversation
  static void setTypingIndicator(String conversationId, bool isTyping) {
    final conversation = getConversationById(conversationId);
    if (conversation == null) return;

    final updatedConversation = conversation.copyWith(isTyping: isTyping);
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = updatedConversation;
    }
  }

  /// Create a new conversation with a user
  static Future<Conversation?> createConversation({
    required String userId,
    required String userName,
    String? userAvatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Check if conversation already exists
    final existing = getConversationByUserId(userId);
    if (existing != null) return existing;

    final newConversation = Conversation(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      messages: [],
    );

    _conversations.add(newConversation);
    return newConversation;
  }

  /// Delete a conversation
  static Future<bool> deleteConversation(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      _conversations.removeWhere((c) => c.id == conversationId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Search conversations by user name
  static List<Conversation> searchConversations(String query) {
    if (query.isEmpty) return getAllConversations();

    return _conversations
        .where((c) => c.userName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Simulate receiving a new message (for demo purposes)
  static void simulateIncomingMessage(String conversationId, String content) {
    final conversation = getConversationById(conversationId);
    if (conversation == null) return;

    final newMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: conversation.userId,
      receiverId: currentUserId,
      content: content,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    final updatedMessages = List<Message>.from(conversation.messages)
      ..add(newMessage);
    final updatedConversation = conversation.copyWith(messages: updatedMessages);

    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = updatedConversation;
    }
  }
}
