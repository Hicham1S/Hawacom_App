import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/conversation_firestore.dart';
import '../services/firestore_chat_service.dart';
import '../widgets/conversation_list_tile.dart';
import 'chat_screen.dart';

/// Messages list screen showing all conversations from Firestore
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final FirestoreChatService _chatService = FirestoreChatService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String get _currentUserId => context.read<AuthProvider>().currentUser?.id ?? '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChat(ConversationFirestore conversation) async {
    // Mark as read
    await _chatService.markAsRead(conversation.id, _currentUserId);

    if (!mounted) return;

    // Navigate to chat screen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(conversation: conversation),
      ),
    );
  }

  List<ConversationFirestore> _filterConversations(
      List<ConversationFirestore> conversations) {
    if (_searchQuery.isEmpty) return conversations;

    return conversations.where((conv) {
      final otherUser = conv.getOtherUser(_currentUserId);
      if (otherUser == null) return false;

      return otherUser.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          conv.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'المحادثات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ابحث في المحادثات',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.textSecondary,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),

            // Conversations list from Firestore
            Expanded(
              child: StreamBuilder<List<ConversationFirestore>>(
                stream: _chatService.listenToConversations(_currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'خطأ في تحميل المحادثات',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final conversations = snapshot.data ?? [];
                  final filteredConversations = _filterConversations(conversations);

                  if (filteredConversations.isEmpty) {
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
                            _searchQuery.isEmpty
                                ? 'لا توجد محادثات'
                                : 'لا توجد نتائج',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 18,
                            ),
                          ),
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'ستظهر محادثاتك هنا',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredConversations.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final conversation = filteredConversations[index];
                      return ConversationListTile(
                        conversation: conversation,
                        currentUserId: _currentUserId,
                        onTap: () => _openChat(conversation),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
