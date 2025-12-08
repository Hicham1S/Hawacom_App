import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/conversation_firestore.dart';
import '../models/chat_message.dart';
import '../services/firestore_chat_service.dart';
import '../widgets/chat_message_bubble.dart';

/// Chat conversation screen showing messages with a user using Firestore
class ChatScreen extends StatefulWidget {
  final ConversationFirestore conversation;

  const ChatScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirestoreChatService _chatService = FirestoreChatService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  StreamSubscription<List<ChatMessage>>? _messageSubscription;
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isUploadingImage = false;

  String get _currentUserId => context.read<AuthProvider>().currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    setState(() {
      _isLoading = true;
    });

    // Listen to real-time messages from Firestore
    _messageSubscription = _chatService
        .listenToChatMessages(widget.conversation.id)
        .listen((messages) {
      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    }, onError: (error) {
      debugPrint('Error listening to messages: $error');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    // Mark conversation as read
    _chatService.markAsRead(widget.conversation.id, _currentUserId);
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

  Future<void> _handleSendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();

    final success = await _chatService.sendTextMessage(
      conversationId: widget.conversation.id,
      senderId: _currentUserId,
      messageText: text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.chatSendMessageFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleImagePicker(ImageSource source) async {
    Navigator.pop(context); // Close bottom sheet

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    // Convert XFile to File
    final file = File(image.path);

    final success = await _chatService.sendImageMessage(
      conversationId: widget.conversation.id,
      senderId: _currentUserId,
      imageFile: file,
    );

    setState(() {
      _isUploadingImage = false;
    });

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.chatSendImageFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.chatPhotoGallery),
                onTap: () => _handleImagePicker(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.chatCamera),
                onTap: () => _handleImagePicker(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = widget.conversation.getOtherUser(_currentUserId);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                backgroundImage: otherUser?.avatar != null &&
                        otherUser!.avatar!.isNotEmpty
                    ? NetworkImage(otherUser.avatar!)
                    : null,
                child: otherUser?.avatar == null || otherUser!.avatar!.isEmpty
                    ? Text(
                        otherUser?.name[0].toUpperCase() ?? '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  otherUser?.name ?? widget.conversation.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Upload progress
            if (_isUploadingImage)
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.primary.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.chatUploadingImage),
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
                      ? Center(
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
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            final isMe = message.isSentByMe(_currentUserId);

                            return ChatMessageBubble(
                              message: message,
                              isMe: isMe,
                              senderName: isMe ? 'أنت' : (otherUser?.name ?? ''),
                            );
                          },
                        ),
            ),

            // Input area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, -2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      // Attachment button
                      IconButton(
                        onPressed: _showImagePickerOptions,
                        icon: Icon(
                          Icons.attach_file,
                          color: AppColors.primary,
                        ),
                      ),

                      // Text field
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _textController,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              hintText: 'اكتب رسالة...',
                              hintStyle: TextStyle(color: AppColors.textSecondary),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            onSubmitted: (_) => _handleSendMessage(),
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
                          onPressed: _handleSendMessage,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
