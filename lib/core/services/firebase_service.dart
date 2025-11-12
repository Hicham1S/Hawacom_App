import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level function for handling background messages
/// Must be a top-level function for Firebase to access it
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

/// Centralized Firebase service for FCM, Realtime Database, and Storage
class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Local notifications
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // FCM token
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize Firebase and all services
  Future<void> initialize() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      print('Firebase initialized successfully');

      // Initialize FCM
      await _initializeFCM();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Configure database persistence
      _database.setPersistenceEnabled(true);
      _database.setPersistenceCacheSizeBytes(10000000); // 10MB

      print('FirebaseService initialized successfully');
    } catch (e) {
      print('Error initializing FirebaseService: $e');
      rethrow;
    }
  }

  /// Initialize Firebase Cloud Messaging
  Future<void> _initializeFCM() async {
    try {
      // Request notification permissions (iOS)
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('FCM permission granted');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('FCM provisional permission granted');
      } else {
        print('FCM permission denied');
      }

      // Get FCM token
      _fcmToken = await _messaging.getToken();
      print('FCM Token: $_fcmToken');

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print('FCM Token refreshed: $newToken');
        // TODO: Send token to server
      });

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle message when app is opened from terminated state
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was opened from a notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }
    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.messageId}');

    // Show local notification
    if (message.notification != null) {
      _showLocalNotification(
        title: message.notification!.title ?? 'New Message',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Handle when notification is tapped
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message opened app: ${message.messageId}');
    // TODO: Navigate to appropriate screen based on message data
  }

  /// Handle when local notification is tapped
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // TODO: Navigate based on payload
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // ==================== Realtime Database Methods ====================

  /// Get database reference
  DatabaseReference getDbRef(String path) {
    return _database.ref(path);
  }

  /// Read data once
  Future<DataSnapshot> readOnce(String path) async {
    try {
      final snapshot = await _database.ref(path).get();
      return snapshot;
    } catch (e) {
      print('Error reading from database: $e');
      rethrow;
    }
  }

  /// Write data
  Future<void> write(String path, Map<String, dynamic> data) async {
    try {
      await _database.ref(path).set(data);
    } catch (e) {
      print('Error writing to database: $e');
      rethrow;
    }
  }

  /// Update data
  Future<void> update(String path, Map<String, dynamic> data) async {
    try {
      await _database.ref(path).update(data);
    } catch (e) {
      print('Error updating database: $e');
      rethrow;
    }
  }

  /// Delete data
  Future<void> delete(String path) async {
    try {
      await _database.ref(path).remove();
    } catch (e) {
      print('Error deleting from database: $e');
      rethrow;
    }
  }

  /// Listen to data changes
  Stream<DatabaseEvent> listen(String path) {
    return _database.ref(path).onValue;
  }

  /// Push new data (generates unique ID)
  Future<DatabaseReference> push(String path, Map<String, dynamic> data) async {
    try {
      final ref = _database.ref(path).push();
      await ref.set(data);
      return ref;
    } catch (e) {
      print('Error pushing to database: $e');
      rethrow;
    }
  }

  // ==================== Storage Methods ====================

  /// Upload file to storage
  Future<String> uploadFile({
    required File file,
    required String path,
    Function(double)? onProgress,
  }) async {
    try {
      final ref = _storage.ref(path);
      final uploadTask = ref.putFile(file);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((snapshot) {
          final progress =
              snapshot.bytesTransferred / snapshot.totalBytes * 100;
          onProgress(progress);
        });
      }

      // Wait for upload to complete
      await uploadTask;

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  /// Delete file from storage
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref(path).delete();
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }

  /// Get download URL
  Future<String> getDownloadUrl(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      print('Error getting download URL: $e');
      rethrow;
    }
  }

  // ==================== User Presence ====================

  /// Set user online/offline status
  Future<void> setUserPresence(String userId, bool isOnline) async {
    try {
      await update('users/$userId/presence', {
        'online': isOnline,
        'lastSeen': ServerValue.timestamp,
      });

      // Set up automatic offline status when disconnected
      if (isOnline) {
        _database.ref('users/$userId/presence').onDisconnect().update({
          'online': false,
          'lastSeen': ServerValue.timestamp,
        });
      }
    } catch (e) {
      print('Error setting user presence: $e');
    }
  }

  /// Subscribe to FCM topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from FCM topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }
}
