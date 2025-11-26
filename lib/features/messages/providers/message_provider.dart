import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../repositories/message_repository.dart';

/// Provider for managing message/chat state
class MessageProvider extends ChangeNotifier {
  final MessageRepository _repository;

  MessageProvider({MessageRepository? repository})
      : _repository = repository ?? MessageRepository();

  // State
  List<Conversation> _conversations = [];
  Conversation? _selectedConversation;
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;
  String _searchQuery = '';

  // Getters
  List<Conversation> get conversations => _conversations;
  Conversation? get selectedConversation => _selectedConversation;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  String get currentUserId => _repository.currentUserId;

  /// Get filtered conversations based on search query
  List<Conversation> get filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;

    return _conversations.where((conversation) {
      final userName = conversation.userName.toLowerCase();
      final lastMessage = conversation.getLastMessagePreview().toLowerCase();
      final query = _searchQuery.toLowerCase();

      return userName.contains(query) || lastMessage.contains(query);
    }).toList();
  }

  /// Get total unread count
  int get totalUnreadCount {
    int total = 0;
    for (var conversation in _conversations) {
      total += conversation.getUnreadCount(currentUserId);
    }
    return total;
  }

  /// Load all conversations
  Future<void> loadConversations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _conversations = await _repository.getAllConversations();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في تحميل المحادثات: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Load a specific conversation by ID
  Future<void> loadConversationById(String conversationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedConversation = await _repository.getConversationById(conversationId);

      // Mark as read
      if (_selectedConversation != null) {
        await _repository.markConversationAsRead(conversationId);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في تحميل المحادثة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Set selected conversation
  void selectConversation(Conversation conversation) {
    _selectedConversation = conversation;
    notifyListeners();

    // Mark as read
    _repository.markConversationAsRead(conversation.id);
  }

  /// Clear selected conversation
  void clearSelectedConversation() {
    _selectedConversation = null;
    notifyListeners();
  }

  /// Send a message
  Future<bool> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    if (content.trim().isEmpty) return false;

    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.sendMessage(
        conversationId: conversationId,
        content: content.trim(),
        type: type,
      );

      _isSending = false;

      if (success) {
        // Reload the selected conversation to get the updated messages
        await loadConversationById(conversationId);
        // Reload conversations list to update preview
        await loadConversations();
      } else {
        _errorMessage = 'فشل في إرسال الرسالة';
      }

      notifyListeners();
      return success;
    } catch (e) {
      _isSending = false;
      _errorMessage = 'فشل في إرسال الرسالة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Create a new conversation
  Future<Conversation?> createConversation({
    required String userId,
    required String userName,
    String? userAvatarUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final conversation = await _repository.createConversation(
        userId: userId,
        userName: userName,
        userAvatarUrl: userAvatarUrl,
      );

      if (conversation != null) {
        _conversations.add(conversation);
        _selectedConversation = conversation;
      }

      _isLoading = false;
      notifyListeners();
      return conversation;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في إنشاء المحادثة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return null;
    }
  }

  /// Delete a conversation
  Future<bool> deleteConversation(String conversationId) async {
    _errorMessage = null;

    try {
      final success = await _repository.deleteConversation(conversationId);

      if (success) {
        _conversations.removeWhere((c) => c.id == conversationId);
        if (_selectedConversation?.id == conversationId) {
          _selectedConversation = null;
        }
        notifyListeners();
      } else {
        _errorMessage = 'فشل في حذف المحادثة';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = 'فشل في حذف المحادثة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Search conversations
  void searchConversations(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Set typing indicator
  void setTypingIndicator(String conversationId, bool isTyping) {
    _repository.setTypingIndicator(conversationId, isTyping);
    // Note: In production, this would trigger real-time updates
    // For now, the UI will update on next reload
  }

  /// Refresh conversations
  Future<void> refresh() async {
    await loadConversations();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
