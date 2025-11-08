import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/conversation.dart';
import '../services/chat_service.dart';

/// Chat list tile widget for messages list screen
/// Shows user avatar, name, last message, time, and unread count
class ChatListTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ChatListTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount = conversation.getUnreadCount(ChatService.currentUserId);
    final hasUnread = unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasUnread
              ? AppColors.cardBackground.withValues(alpha: 0.5)
              : Colors.transparent,
          border: const Border(
            bottom: BorderSide(
              color: AppColors.cardBackground,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                _buildAvatar(),
                if (conversation.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // User info and last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.userName,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight:
                              hasUnread ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      Text(
                        conversation.getFormattedLastMessageTime(),
                        style: TextStyle(
                          color: hasUnread
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Last message preview and unread badge
                  Row(
                    children: [
                      Expanded(
                        child: conversation.isTyping
                            ? _buildTypingIndicator()
                            : Text(
                                conversation.getLastMessagePreview(),
                                style: TextStyle(
                                  color: hasUnread
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: hasUnread
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (conversation.userAvatarUrl != null &&
        conversation.userAvatarUrl!.isNotEmpty) {
      // Try to load image
      if (conversation.userAvatarUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(conversation.userAvatarUrl!),
          backgroundColor: AppColors.cardBackground,
        );
      } else {
        return CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(conversation.userAvatarUrl!),
          backgroundColor: AppColors.cardBackground,
        );
      }
    } else {
      // Initials placeholder
      final initials = conversation.userName
          .split(' ')
          .take(2)
          .map((word) => word.isNotEmpty ? word[0] : '')
          .join()
          .toUpperCase();

      return CircleAvatar(
        radius: 28,
        backgroundColor: AppColors.primary,
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        Text(
          'يكتب',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 20,
          height: 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) => Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
