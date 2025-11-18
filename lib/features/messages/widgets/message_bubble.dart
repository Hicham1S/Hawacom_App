import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/message.dart';

/// Message bubble widget for chat screen
/// Shows individual message with different styles for sent/received
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: message.type == MessageType.image
                ? const EdgeInsets.all(4)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.cardBackground,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe
                    ? const Radius.circular(16)
                    : const Radius.circular(4),
                bottomRight: isMe
                    ? const Radius.circular(4)
                    : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image message
                if (message.type == MessageType.image && message.mediaUrl != null)
                  _buildImageMessage(context),

                // Text content (for text messages or image captions)
                if (message.type == MessageType.text ||
                    (message.type == MessageType.image && message.content.isNotEmpty))
                  Padding(
                    padding: message.type == MessageType.image
                        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                        : EdgeInsets.zero,
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.textPrimary,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),

                if (message.type == MessageType.text)
                  const SizedBox(height: 4),

                // Time and status
                Padding(
                  padding: message.type == MessageType.image
                      ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                      : EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getFormattedTime(),
                        style: TextStyle(
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePreview(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
            maxHeight: 250,
          ),
          child: Image.network(
            message.mediaUrl!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Container(
                width: 200,
                height: 200,
                color: Colors.grey.withValues(alpha: 0.2),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isMe ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 200,
                height: 200,
                color: Colors.grey.withValues(alpha: 0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'فشل تحميل الصورة',
                      style: TextStyle(
                        color: Colors.grey.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  message.mediaUrl!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
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
