import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../providers/message_provider.dart';
import '../widgets/chat_list_tile.dart';
import 'chat_screen_provider.dart';

/// Messages list screen using Provider pattern
class MessagesScreenProvider extends StatefulWidget {
  const MessagesScreenProvider({super.key});

  @override
  State<MessagesScreenProvider> createState() => _MessagesScreenProviderState();
}

class _MessagesScreenProviderState extends State<MessagesScreenProvider> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load conversations when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageProvider>().loadConversations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<MessageProvider>().refresh();
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
                child: Consumer<MessageProvider>(
                  builder: (context, provider, child) {
                    return TextField(
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
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  provider.clearSearch();
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
                        provider.searchConversations(value);
                      },
                    );
                  },
                ),
              ),
            ),

            // Conversations list
            Expanded(
              child: Consumer<MessageProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (provider.hasError) {
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
                            provider.errorMessage ?? '',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.loadConversations(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  final conversations = provider.filteredConversations;

                  if (conversations.isEmpty) {
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
                            _searchController.text.isEmpty
                                ? 'لا توجد محادثات'
                                : 'لا توجد نتائج',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 18,
                            ),
                          ),
                          if (_searchController.text.isEmpty) ...[
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

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.primary,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: conversations.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final conversation = conversations[index];
                        return ChatListTile(
                          conversation: conversation,
                          onTap: () {
                            // Select conversation and navigate
                            provider.selectConversation(conversation);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreenProvider(
                                  conversation: conversation,
                                ),
                              ),
                            ).then((_) {
                              // Refresh conversations when returning
                              provider.loadConversations();
                            });
                          },
                        );
                      },
                    ),
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
