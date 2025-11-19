import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Represents an individual chat message in Firestore
/// Compatible with old GetX "Chat" model
class ChatMessage extends Equatable {
  final String id;
  final String text; // Message content or URL (for images/files)
  final int time; // milliseconds since epoch
  final String userId; // Sender's ID
  final String price; // For bill messages

  const ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.userId,
    this.price = '',
  });

  /// Create from Firestore DocumentSnapshot
  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      return ChatMessage(
        id: doc.id,
        text: data['text']?.toString() ?? '',
        time: data['time'] as int? ?? 0,
        userId: data['user']?.toString() ?? '',
        price: data['price']?.toString() ?? '',
      );
    } catch (e) {
      return ChatMessage(
        id: doc.id,
        text: '',
        time: 0,
        userId: '',
        price: '',
      );
    }
  }

  /// Convert to Firestore map
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'time': time,
      'user': userId,
      'price': price,
    };
  }

  /// Check if this is an image message (URL contains image extensions or Firebase Storage URL)
  bool get isImage {
    final lowerText = text.toLowerCase();
    return lowerText.contains('.jpg') ||
        lowerText.contains('.jpeg') ||
        lowerText.contains('.png') ||
        lowerText.contains('.gif') ||
        lowerText.contains('firebasestorage.googleapis.com');
  }

  /// Check if this is an audio message
  bool get isAudio {
    final lowerText = text.toLowerCase();
    return lowerText.contains('.mp3') ||
        lowerText.contains('.m4a') ||
        lowerText.contains('audio');
  }

  /// Check if this is a file message
  bool get isFile {
    final lowerText = text.toLowerCase();
    return lowerText.contains('.pdf') ||
        lowerText.contains('.doc') ||
        lowerText.contains('.zip') ||
        (lowerText.contains('firebasestorage.googleapis.com') &&
         !isImage && !isAudio);
  }

  /// Check if this is a bill message
  bool get isBill {
    return price.isNotEmpty && price != '0' && price != '';
  }

  /// Check if message is sent by current user
  bool isSentByMe(String currentUserId) {
    return userId == currentUserId;
  }

  /// Get formatted time
  String getFormattedTime() {
    final DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(time);
    final int hour = messageTime.hour;
    final int minute = messageTime.minute;

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [id];
}
