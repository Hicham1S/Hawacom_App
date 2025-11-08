import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/conversation.dart';
import '../services/chat_service.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

/// Chat conversation screen showing messages with a user
class ChatScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Conversation _conversation;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
    _loadMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Mark messages as read
    await ChatService.markConversationAsRead(_conversation.id);

    // Refresh conversation
    final updatedConversation =
        ChatService.getConversationById(_conversation.id);

    if (updatedConversation != null) {
      setState(() {
        _conversation = updatedConversation;
        _isLoading = false;
      });

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Send message
    final success = await ChatService.sendMessage(
      conversationId: _conversation.id,
      content: content,
    );

    if (success) {
      // Reload conversation
      final updated = ChatService.getConversationById(_conversation.id);
      if (updated != null) {
        setState(() {
          _conversation = updated;
        });

        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    }
  }

  void _handleAttachment() {
    // TODO: Implement attachment picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('إرفاق الملفات قريباً'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Header
            ChatHeader(conversation: _conversation),

            // Messages list
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _conversation.messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: _conversation.messages.length,
                          itemBuilder: (context, index) {
                            final message = _conversation.messages[index];
                            return MessageBubble(message: message);
                          },
                        ),
            ),

            // Input
            ChatInput(
              onSendMessage: _handleSendMessage,
              onAttachment: _handleAttachment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد رسائل',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ المحادثة بإرسال رسالة',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
