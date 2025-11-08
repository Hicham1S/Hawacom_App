import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/conversation.dart';

/// Chat header widget for chat screen
/// Shows user info, online status, and action buttons
class ChatHeader extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onBack;
  final VoidCallback? onMoreOptions;

  const ChatHeader({
    super.key,
    required this.conversation,
    this.onBack,
    this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.cardBackground,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: onBack ?? () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.textPrimary,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            const SizedBox(width: 12),

            // Avatar
            Stack(
              children: [
                _buildAvatar(),
                if (conversation.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
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

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.userName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: conversation.isOnline || conversation.isTyping
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // More options button
            IconButton(
              onPressed: onMoreOptions ?? () => _showMoreOptions(context),
              icon: Icon(
                Icons.more_vert,
                color: AppColors.textPrimary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (conversation.userAvatarUrl != null &&
        conversation.userAvatarUrl!.isNotEmpty) {
      if (conversation.userAvatarUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(conversation.userAvatarUrl!),
          backgroundColor: AppColors.cardBackground,
        );
      } else {
        return CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(conversation.userAvatarUrl!),
          backgroundColor: AppColors.cardBackground,
        );
      }
    } else {
      final initials = conversation.userName
          .split(' ')
          .take(2)
          .map((word) => word.isNotEmpty ? word[0] : '')
          .join()
          .toUpperCase();

      return CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primary,
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  String _getStatusText() {
    if (conversation.isTyping) {
      return 'يكتب...';
    } else if (conversation.isOnline) {
      return 'متصل الآن';
    } else if (conversation.lastSeen != null) {
      return _getFormattedLastSeen();
    }
    return 'غير متصل';
  }

  String _getFormattedLastSeen() {
    if (conversation.lastSeen == null) return '';

    final now = DateTime.now();
    final diff = now.difference(conversation.lastSeen!);

    if (diff.inMinutes < 1) {
      return 'آخر ظهور: الآن';
    } else if (diff.inHours < 1) {
      return 'آخر ظهور: منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inDays < 1) {
      return 'آخر ظهور: منذ ${diff.inHours} ساعة';
    } else if (diff.inDays == 1) {
      return 'آخر ظهور: أمس';
    } else if (diff.inDays < 7) {
      return 'آخر ظهور: منذ ${diff.inDays} أيام';
    } else {
      return 'آخر ظهور: ${conversation.lastSeen!.day}/${conversation.lastSeen!.month}';
    }
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.textPrimary),
              title: Text(
                'حذف المحادثة',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete conversation
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.notifications_off_outlined, color: AppColors.textPrimary),
              title: Text(
                'كتم الإشعارات',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement mute notifications
              },
            ),
            ListTile(
              leading: Icon(Icons.block_outlined, color: Colors.redAccent),
              title: const Text(
                'حظر المستخدم',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement block user
              },
            ),
          ],
        ),
      ),
    );
  }
}
