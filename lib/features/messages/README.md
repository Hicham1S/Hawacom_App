# Messages Feature

A complete messaging/chat feature for the Hawacom app, built following best practices and the project's feature-based architecture.

## Features

### ✅ Implemented
- **Messages List Screen**: View all conversations sorted by most recent
- **Chat Screen**: One-on-one conversations with users
- **Real-time UI Updates**: Messages, online status, typing indicators
- **Message Status**: Sent, delivered, read indicators
- **Unread Count**: Badge showing unread messages per conversation
- **Search**: Search conversations by user name
- **Online Status**: Green indicator for online users
- **Last Seen**: Shows when user was last active
- **Pull to Refresh**: Refresh conversations list
- **Empty States**: User-friendly empty state screens
- **RTL Support**: Full right-to-left Arabic language support
- **Localization**: Both Arabic and English translations

### 🔜 Future Enhancements
- [ ] Image/video attachments
- [ ] Voice messages
- [ ] Message reactions (like, love, etc.)
- [ ] Group chats
- [ ] Message forwarding
- [ ] Delete messages
- [ ] Edit sent messages
- [ ] Push notifications
- [ ] Backend integration (Firebase/API)
- [ ] Message encryption
- [ ] Read receipts toggle
- [ ] Block/unblock users
- [ ] Mute conversations
- [ ] Archive conversations

## Architecture

```
features/messages/
├── data/
│   └── mock_conversations.dart     # Mock data for testing
├── models/
│   ├── conversation.dart           # Conversation/chat model
│   └── message.dart                # Individual message model
├── screens/
│   ├── messages_screen.dart        # All conversations list
│   └── chat_screen.dart            # Chat conversation
├── services/
│   └── chat_service.dart           # Business logic layer
└── widgets/
    ├── chat_header.dart            # Chat screen header
    ├── chat_input.dart             # Message input field
    ├── chat_list_tile.dart         # Conversation preview tile
    └── message_bubble.dart         # Individual message bubble
```

## Models

### Message
Represents an individual message in a conversation.

**Properties:**
- `id`: Unique message identifier
- `senderId`: User who sent the message
- `receiverId`: User who receives the message
- `content`: Message text content
- `type`: Message type (text, image, video, audio, file)
- `status`: Message status (sending, sent, delivered, read, failed)
- `timestamp`: When message was sent
- `mediaUrl`: URL for media messages (optional)

**Message Types:**
- `text`: Regular text message
- `image`: Image attachment
- `video`: Video attachment
- `audio`: Voice message
- `file`: File attachment

**Message Status:**
- `sending`: Message being sent
- `sent`: Message sent successfully
- `delivered`: Message delivered to recipient
- `read`: Message read by recipient
- `failed`: Message failed to send

### Conversation
Represents a chat/conversation with another user.

**Properties:**
- `id`: Unique conversation identifier
- `userId`: Other user's ID
- `userName`: Other user's name
- `userAvatarUrl`: Other user's avatar URL (optional)
- `messages`: List of messages in conversation
- `isOnline`: Whether user is currently online
- `lastSeen`: When user was last active (optional)
- `isTyping`: Whether user is currently typing

**Helper Methods:**
- `lastMessage`: Get most recent message
- `getUnreadCount(currentUserId)`: Count unread messages
- `getLastMessagePreview()`: Get formatted preview text
- `getFormattedLastMessageTime()`: Get relative time string

## Services

### ChatService
Central service for all messaging operations.

**Key Methods:**
```dart
// Get all conversations
List<Conversation> getAllConversations()

// Get specific conversation
Conversation? getConversationById(String id)
Conversation? getConversationByUserId(String userId)

// Send message
Future<bool> sendMessage({
  required String conversationId,
  required String content,
  MessageType type = MessageType.text,
})

// Mark as read
Future<void> markConversationAsRead(String conversationId)

// Get unread count
int getTotalUnreadCount()

// Search
List<Conversation> searchConversations(String query)

// Create/Delete
Future<Conversation?> createConversation(...)
Future<bool> deleteConversation(String conversationId)

// Typing indicator
void setTypingIndicator(String conversationId, bool isTyping)

// Simulate (for testing)
void simulateIncomingMessage(String conversationId, String content)
```

## Screens

### MessagesScreen
Shows list of all conversations.

**Features:**
- Search conversations
- Pull to refresh
- Unread badges
- Online indicators
- Last message preview
- Relative timestamps
- Empty state
- Navigate to chat screen

**Navigation:**
- Bottom navigation: Messages button (index 1)
- Tap conversation → Opens ChatScreen

### ChatScreen
Shows conversation with a specific user.

**Features:**
- Chat header with user info
- Scrollable messages list
- Message input field
- Send button
- Attachment button (coming soon)
- Online/last seen status
- Typing indicator
- Message status indicators
- Auto-scroll to bottom
- More options menu

**Navigation:**
- Back button → Returns to MessagesScreen
- More menu → Delete, mute, block (to be implemented)

## Widgets

### ChatListTile
Preview tile for each conversation in messages list.

**Shows:**
- User avatar (with initials fallback)
- User name
- Online indicator
- Last message preview
- Relative timestamp
- Unread count badge
- Typing indicator

### MessageBubble
Individual message in chat screen.

**Features:**
- Different styles for sent/received messages
- Rounded corners
- Message timestamp
- Status icon (sent by me only)
- Long text support
- Color-coded (primary for sent, card for received)

### ChatInput
Message input field with send button.

**Features:**
- Multi-line text input
- RTL support
- Send button (enabled when text present)
- Attachment button (optional)
- Auto-resize text field
- Bottom safe area

### ChatHeader
Header for chat screen.

**Features:**
- Back button
- User avatar
- User name
- Online/last seen status
- Typing indicator
- More options menu

## Localization

### Added Strings (Arabic & English)

```
messages                - الرسائل
messagesEmpty          - لا توجد محادثات
messagesEmptyDesc      - ابدأ محادثة جديدة
messagesNoResults      - لا توجد نتائج
messagesSending        - جاري الإرسال...
messagesTyping         - يكتب...
messagesOnline         - متصل الآن
messagesOffline        - غير متصل
messagesLastSeen       - آخر ظهور
messagesTypeMessage    - اكتب رسالة...
messagesDelete         - حذف المحادثة
messagesMute           - كتم الإشعارات
messagesBlock          - حظر المستخدم
messagesNoMessages     - لا توجد رسائل
messagesStartChat      - ابدأ المحادثة بإرسال رسالة
```

## Mock Data

6 test conversations with various states:
1. **Amina**: Online, recent messages
2. **Ahmed**: Offline, 5 hours ago
3. **Fatima**: Online, 3 unread messages
4. **Mohammad**: Offline, 2 days ago
5. **Sara**: Online, 1 day old conversation
6. **Noura**: Offline, 2 unread messages (recent)

## Backend Integration Guide

When ready to connect to a real backend:

### 1. Replace ChatService
```dart
class ChatService {
  final ApiClient _api;
  final LocalStorage _storage;

  Future<List<Conversation>> getAllConversations() async {
    final response = await _api.get('/conversations');
    return response.map((json) => Conversation.fromJson(json)).toList();
  }

  Future<bool> sendMessage(...) async {
    final response = await _api.post('/messages', body: {...});
    return response.statusCode == 200;
  }
}
```

### 2. Add State Management
Consider using:
- **Bloc/Cubit**: For complex state
- **Provider**: For simpler state
- **Riverpod**: For modern approach

### 3. Add Real-time Updates
Using WebSockets or Firebase:
```dart
class ChatService {
  Stream<List<Message>> messagesStream(String conversationId) {
    return _firebase
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .snapshots();
  }
}
```

### 4. Add Notifications
- Push notifications for new messages
- Local notifications when app in background
- Badge count on app icon

### 5. Add Media Upload
```dart
Future<String> uploadMedia(File file) async {
  final response = await _storage.uploadFile(file);
  return response.url;
}
```

## Testing

### Manual Testing Checklist
- [ ] Open messages screen from bottom nav
- [ ] See list of conversations
- [ ] Search for conversations
- [ ] Tap conversation to open chat
- [ ] Send text messages
- [ ] See message status (checkmarks)
- [ ] See online indicators
- [ ] See unread count badges
- [ ] Test pull to refresh
- [ ] Test empty states
- [ ] Test back navigation
- [ ] Test RTL/LTR switching
- [ ] Test Arabic/English language

### Unit Test Examples (Future)
```dart
test('ChatService sends message successfully', () async {
  final service = ChatService();
  final result = await service.sendMessage(
    conversationId: 'conv_001',
    content: 'Test message',
  );
  expect(result, true);
});

test('Conversation calculates unread count', () {
  final conversation = Conversation(...);
  final unreadCount = conversation.getUnreadCount('user_001');
  expect(unreadCount, 3);
});
```

## Performance Considerations

### Current Implementation
- In-memory data storage (fast, no persistence)
- List view with builder (efficient for long lists)
- Auto-scroll on new messages
- Simple state management

### Optimizations for Production
1. **Pagination**: Load messages in chunks
2. **Caching**: Cache conversations locally
3. **Lazy Loading**: Load conversation details on demand
4. **Image Optimization**: Compress and cache avatars
5. **Background Sync**: Sync messages in background
6. **Database**: Use SQLite for local storage

## Security Considerations

### Current State (Mock Data)
- No encryption
- No authentication
- No authorization
- Client-side only

### Production Requirements
1. **End-to-End Encryption**: Encrypt message content
2. **Authentication**: Verify user identity
3. **Authorization**: Check user permissions
4. **HTTPS**: Secure transport layer
5. **Input Validation**: Sanitize all inputs
6. **Rate Limiting**: Prevent spam
7. **Content Filtering**: Block inappropriate content

## UI/UX Design

### Color Scheme
- **Sent Messages**: Primary color background
- **Received Messages**: Card background color
- **Online Indicator**: Green
- **Unread Badge**: Primary color
- **Typing Indicator**: Primary color

### Typography
- **User Names**: 16px, Bold
- **Messages**: 15px, Regular
- **Timestamps**: 11-12px, Light
- **Preview Text**: 14px, Regular

### Spacing
- **Message Bubbles**: 16px horizontal, 4px vertical
- **List Items**: 16px horizontal, 12px vertical
- **Input Field**: 16px horizontal, 12px vertical

## Integration with Existing Features

### Connected To:
- **Bottom Navigation**: Messages button (index 1)
- **Core/Constants**: Uses AppColors
- **Core/Localization**: Full l10n support
- **Shared/Data**: Can access dummy_users.dart

### Can Be Extended With:
- **Stories**: Send story as message
- **Profile**: View user profile from chat
- **Projects**: Share project in message
- **Notifications**: Notify on new message

## Troubleshooting

### Common Issues

**Issue**: Messages not appearing
- Check mock data in `mock_conversations.dart`
- Verify conversation ID is correct
- Check service is returning data

**Issue**: Can't send messages
- Verify conversation exists
- Check ChatService.sendMessage() logic
- Look for errors in console

**Issue**: Unread count not updating
- Call `markConversationAsRead()` when opening chat
- Verify current user ID matches
- Check getUnreadCount() logic

**Issue**: Localization missing
- Run `flutter gen-l10n`
- Check .arb files have all keys
- Verify imports are correct

## Credits

- **Architecture**: Feature-based modular design
- **UI Pattern**: Instagram/WhatsApp inspired
- **State**: StatefulWidget with local state
- **Navigation**: MaterialPageRoute

## Version History

- **v1.0** (Current): Initial implementation with core features
  - Messages list screen
  - Chat conversation screen
  - Mock data and service layer
  - Full localization
  - Connected to navigation
