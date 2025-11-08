import '../models/conversation.dart';
import '../models/message.dart';

/// Mock conversations data for development and testing
class MockConversations {
  static const String currentUserId = 'user_001'; // Current user (Hicham)

  /// Get all conversations for testing
  static List<Conversation> getAllConversations() {
    return [
      // Conversation with Amina
      Conversation(
        id: 'conv_001',
        userId: 'user_002',
        userName: 'أمينة الهاجري',
        userAvatarUrl: 'assets/images/Amina.png',
        isOnline: true,
        messages: [
          Message(
            id: 'msg_001',
            senderId: 'user_002',
            receiverId: currentUserId,
            content: 'مرحباً! كيف حالك؟',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_002',
            senderId: currentUserId,
            receiverId: 'user_002',
            content: 'الحمد لله، وأنتِ كيف حالك؟',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_003',
            senderId: 'user_002',
            receiverId: currentUserId,
            content: 'بخير، شكراً لك 😊 شفت المشروع الجديد؟',
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
            status: MessageStatus.delivered,
          ),
        ],
      ),

      // Conversation with Ahmed
      Conversation(
        id: 'conv_002',
        userId: 'user_003',
        userName: 'أحمد الشهري',
        userAvatarUrl: null,
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
        messages: [
          Message(
            id: 'msg_004',
            senderId: 'user_003',
            receiverId: currentUserId,
            content: 'متى موعد الاجتماع القادم؟',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_005',
            senderId: currentUserId,
            receiverId: 'user_003',
            content: 'الاجتماع غداً الساعة 10 صباحاً',
            timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 45)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_006',
            senderId: 'user_003',
            receiverId: currentUserId,
            content: 'تمام، شكراً 👍',
            timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 40)),
            status: MessageStatus.read,
          ),
        ],
      ),

      // Conversation with Fatima (has unread messages)
      Conversation(
        id: 'conv_003',
        userId: 'user_004',
        userName: 'فاطمة العتيبي',
        userAvatarUrl: null,
        isOnline: true,
        isTyping: false,
        messages: [
          Message(
            id: 'msg_007',
            senderId: currentUserId,
            receiverId: 'user_004',
            content: 'هل انتهيتي من التصميم؟',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_008',
            senderId: 'user_004',
            receiverId: currentUserId,
            content: 'نعم، انتهيت منه بالأمس',
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
            status: MessageStatus.sent,
          ),
          Message(
            id: 'msg_009',
            senderId: 'user_004',
            receiverId: currentUserId,
            content: 'أرسلت لك الملفات على الإيميل',
            timestamp: DateTime.now().subtract(const Duration(minutes: 44)),
            status: MessageStatus.sent,
          ),
          Message(
            id: 'msg_010',
            senderId: 'user_004',
            receiverId: currentUserId,
            content: 'تحقق منها وأخبرني برأيك 📧',
            timestamp: DateTime.now().subtract(const Duration(minutes: 43)),
            status: MessageStatus.sent,
          ),
        ],
      ),

      // Conversation with Mohammad
      Conversation(
        id: 'conv_004',
        userId: 'user_005',
        userName: 'محمد الدوسري',
        userAvatarUrl: null,
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(days: 2)),
        messages: [
          Message(
            id: 'msg_011',
            senderId: currentUserId,
            receiverId: 'user_005',
            content: 'شكراً على المساعدة في المشروع',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_012',
            senderId: 'user_005',
            receiverId: currentUserId,
            content: 'العفو، دائماً في الخدمة 😊',
            timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 20)),
            status: MessageStatus.read,
          ),
        ],
      ),

      // Conversation with Sara
      Conversation(
        id: 'conv_005',
        userId: 'user_006',
        userName: 'سارة المالكي',
        userAvatarUrl: null,
        isOnline: true,
        messages: [
          Message(
            id: 'msg_013',
            senderId: 'user_006',
            receiverId: currentUserId,
            content: 'السلام عليكم',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_014',
            senderId: currentUserId,
            receiverId: 'user_006',
            content: 'وعليكم السلام ورحمة الله',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
            status: MessageStatus.read,
          ),
          Message(
            id: 'msg_015',
            senderId: 'user_006',
            receiverId: currentUserId,
            content: 'عندي استفسار بخصوص الديكور',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3, minutes: 55)),
            status: MessageStatus.read,
          ),
        ],
      ),

      // Conversation with Noura (recent, has unread)
      Conversation(
        id: 'conv_006',
        userId: 'user_007',
        userName: 'نورة القحطاني',
        userAvatarUrl: null,
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
        messages: [
          Message(
            id: 'msg_016',
            senderId: 'user_007',
            receiverId: currentUserId,
            content: 'هل يمكنك مراجعة التصميم الجديد؟',
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
            status: MessageStatus.sent,
          ),
          Message(
            id: 'msg_017',
            senderId: 'user_007',
            receiverId: currentUserId,
            content: 'محتاجة رأيك بأسرع وقت ممكن 🙏',
            timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
            status: MessageStatus.sent,
          ),
        ],
      ),
    ];
  }

  /// Get a specific conversation by ID
  static Conversation? getConversationById(String conversationId) {
    try {
      return getAllConversations().firstWhere((c) => c.id == conversationId);
    } catch (e) {
      return null;
    }
  }

  /// Get a conversation by user ID
  static Conversation? getConversationByUserId(String userId) {
    try {
      return getAllConversations().firstWhere((c) => c.userId == userId);
    } catch (e) {
      return null;
    }
  }
}
