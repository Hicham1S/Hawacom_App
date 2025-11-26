import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../models/conversation.dart';
import '../providers/message_provider.dart';
import '../widgets/message_bubble.dart';

/// Chat screen using Provider pattern
class ChatScreenProvider extends StatefulWidget {
  final Conversation conversation;

  const ChatScreenProvider({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatScreenProvider> createState() => _ChatScreenProviderState();
}

class _ChatScreenProviderState extends State<ChatScreenProvider> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load conversation details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageProvider>().loadConversationById(widget.conversation.id);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _sendMessage(MessageProvider provider) async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    // Clear input immediately
    _messageController.clear();

    // Send message
    final success = await provider.sendMessage(
      conversationId: widget.conversation.id,
      content: content,
    );

    if (success) {
      // Scroll to bottom after sending
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'فشل في إرسال الرسالة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Consumer<MessageProvider>(
          builder: (context, provider, child) {
            final conversation = provider.selectedConversation ?? widget.conversation;

            return Column(
              children: [
                // Messages list
                Expanded(
                  child: conversation.messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 60,
                                color: AppColors.textSecondary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد رسائل',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
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
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: conversation.messages.length,
                          itemBuilder: (context, index) {
                            final message = conversation.messages[index];
                            final isMe = message.senderId == provider.currentUserId;
                            return MessageBubble(
                              message: message,
                              isMe: isMe,
                            );
                          },
                        ),
                ),

                // Message input
                _buildMessageInput(provider),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            child: widget.conversation.userAvatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      widget.conversation.userAvatarUrl!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarFallback();
                      },
                    ),
                  )
                : _buildAvatarFallback(),
          ),
          const SizedBox(width: 12),
          // Name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.conversation.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.conversation.isOnline)
                  const Text(
                    'متصل الآن',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  )
                else if (widget.conversation.lastSeen != null)
                  Text(
                    'آخر ظهور ${_formatLastSeen(widget.conversation.lastSeen!)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            // TODO: Implement actions
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('حذف المحادثة', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'mute',
              child: Row(
                children: [
                  Icon(Icons.notifications_off_outlined),
                  SizedBox(width: 8),
                  Text('كتم الإشعارات'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  Icon(Icons.block_outlined),
                  SizedBox(width: 8),
                  Text('حظر المستخدم'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarFallback() {
    return Center(
      child: Text(
        widget.conversation.userName.isNotEmpty
            ? widget.conversation.userName[0].toUpperCase()
            : '؟',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMessageInput(MessageProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: (_) => _sendMessage(provider),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: provider.isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: provider.isSending ? null : () => _sendMessage(provider),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final diff = now.difference(lastSeen);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inDays < 1) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return 'منذ ${(diff.inDays / 7).floor()} أسبوع';
    }
  }
}
