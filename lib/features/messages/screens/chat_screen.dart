import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/image_picker_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../services/firebase_chat_service.dart';
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
  final FirebaseChatService _chatService = FirebaseChatService();
  final ImagePickerService _imagePickerService = ImagePickerService();
  final ScrollController _scrollController = ScrollController();

  StreamSubscription<List<Message>>? _messageSubscription;
  List<Message> _messages = [];
  bool _isLoading = true;
  bool _isUploadingImage = false;
  double _uploadProgress = 0.0;

  String get _currentUserId => context.read<AuthProvider>().currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _chatService.stopListeningToMessages(widget.conversation.id);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    // Mark messages as read
    await _chatService.markMessagesAsRead(
      conversationId: widget.conversation.id,
      userId: _currentUserId,
    );

    // Listen to real-time messages
    _messageSubscription = _chatService
        .listenToMessages(widget.conversation.id)
        .listen((messages) {
      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });

        // Scroll to bottom when new message arrives
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل الرسائل: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
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
    final success = await _chatService.sendMessage(
      conversationId: widget.conversation.id,
      senderId: _currentUserId,
      receiverId: widget.conversation.userId,
      content: content,
      type: MessageType.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل إرسال الرسالة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleAttachment() async {
    // Show image picker
    final File? imageFile = await _imagePickerService.showImageSourcePicker(context);

    if (imageFile == null) return;

    setState(() {
      _isUploadingImage = true;
      _uploadProgress = 0.0;
    });

    // Send image message
    final success = await _chatService.sendImageMessage(
      conversationId: widget.conversation.id,
      senderId: _currentUserId,
      receiverId: widget.conversation.userId,
      imageFile: imageFile,
      content: '', // Optional: could ask user for caption
      onUploadProgress: (progress) {
        if (mounted) {
          setState(() {
            _uploadProgress = progress;
          });
        }
      },
    );

    setState(() {
      _isUploadingImage = false;
      _uploadProgress = 0.0;
    });

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل إرسال الصورة'),
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
        body: Column(
          children: [
            // Header
            ChatHeader(conversation: widget.conversation),

            // Upload progress indicator
            if (_isUploadingImage)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.primary.withOpacity(0.1),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'جاري رفع الصورة...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: _uploadProgress,
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(_uploadProgress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

            // Messages list
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            final isMe = message.senderId == _currentUserId;
                            return MessageBubble(
                              message: message,
                              isMe: isMe,
                            );
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
            color: AppColors.textSecondary.withOpacity(0.5),
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
