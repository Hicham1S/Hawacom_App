import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/message.dart';
import '../services/chat_service.dart';

/// Message bubble widget for chat screen
/// Shows individual message with different styles for sent/received
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  bool get isSentByMe => message.isSentByMe(ChatService.currentUserId);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSentByMe ? AppColors.primary : AppColors.cardBackground,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isSentByMe
                    ? const Radius.circular(16)
                    : const Radius.circular(4),
                bottomRight: isSentByMe
                    ? const Radius.circular(4)
                    : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message content
                Text(
                  message.content,
                  style: TextStyle(
                    color: isSentByMe ? Colors.white : AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 4),

                // Time and status
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getFormattedTime(),
                      style: TextStyle(
                        color: isSentByMe
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    if (isSentByMe) ...[
                      const SizedBox(width: 4),
                      _buildStatusIcon(),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedTime() {
    final hour = message.timestamp.hour;
    final minute = message.timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (message.status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = Colors.white.withValues(alpha: 0.6);
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.white.withValues(alpha: 0.8);
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.white.withValues(alpha: 0.8);
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.lightBlueAccent;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = Colors.redAccent;
        break;
    }

    return Icon(
      icon,
      size: 14,
      color: color,
    );
  }
}
