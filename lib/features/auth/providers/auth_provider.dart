import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../core/models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../../../core/services/session_manager.dart';

/// Provider for authentication state management
/// Combines Firebase Auth with Laravel API backend
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  final SessionManager _sessionManager;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthProvider({
    AuthRepository? repository,
    SessionManager? sessionManager,
  })  : _repository = repository ?? AuthRepository(),
        _sessionManager = sessionManager ?? SessionManager(),
        _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  // State
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;
  String? _phoneNumber;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;
  String? get phoneNumber => _phoneNumber;

  /// Check if current user is a designer
  bool get isDesigner => _currentUser?.isDesigner ?? false;

  /// Get API token for requests
  String? get apiToken => _currentUser?.apiToken;

  /// Initialize auth provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _sessionManager.initialize();

      // Check for saved user session
      final isLoggedIn = await _sessionManager.isLoggedIn();

      if (isLoggedIn) {
        // Try to load user from local storage
        final savedUserJson = await _sessionManager.getUser();

        if (savedUserJson != null) {
          _currentUser = UserModel.fromStorageJson(savedUserJson);

          // Check if we have a valid API token
          // Phone users don't use Firebase Auth, so we check token instead
          if (_currentUser!.apiToken != null && _currentUser!.apiToken!.isNotEmpty) {
            // Valid token exists - refresh user data from API
            await _refreshUserFromApi();
          } else {
            // No valid token - check Firebase for email/password users
            final firebaseUser = _firebaseAuth.currentUser;
            if (firebaseUser == null) {
              // No token and no Firebase user = invalid session
              await clearSession();
            } else {
              // Firebase user exists but no token - try to refresh
              await _refreshUserFromApi();
            }
          }
        }
      }

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isInitialized = true;
      _isLoading = false;
      _errorMessage = 'Failed to initialize: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Login with email and password
  Future<bool> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Authenticate with Firebase
      final firebaseCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseCredential.user == null) {
        throw Exception('Firebase authentication failed');
      }

      // 2. Get Firebase ID token
      final idToken = await firebaseCredential.user!.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get Firebase token');
      }

      // 3. Login to Laravel API
      final userFromApi = await _repository.login(
        email: email,
        password: password,
        firebaseToken: idToken,
      );

      if (userFromApi == null) {
        throw Exception('API login failed');
      }

      // 4. Save user session
      _currentUser = userFromApi;
      await _sessionManager.saveUser(_currentUser!.toStorageJson());
      if (_currentUser!.apiToken != null) {
        await _sessionManager.saveToken(_currentUser!.apiToken!);
        debugPrint('=== LOGIN SUCCESS ===');
        debugPrint('New token saved: ${_currentUser!.apiToken!.substring(0, 10)}...');
        debugPrint('User ID: ${_currentUser!.id}');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getFirebaseErrorMessage(e.code);
      debugPrint('Firebase login error: $_errorMessage');
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Login failed: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
    bool isDesigner = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Create Firebase account
      final firebaseCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseCredential.user == null) {
        throw Exception('Firebase registration failed');
      }

      // 2. Update Firebase profile
      await firebaseCredential.user!.updateDisplayName(name);
      await firebaseCredential.user!.reload();

      // 3. Get Firebase ID token
      final idToken = await firebaseCredential.user!.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get Firebase token');
      }

      // 4. Register with Laravel API
      final userFromApi = await _repository.register(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        isDesigner: isDesigner,
        firebaseUid: firebaseCredential.user!.uid,
        firebaseToken: idToken,
      );

      if (userFromApi == null) {
        // Rollback: delete Firebase account
        await firebaseCredential.user!.delete();
        throw Exception('API registration failed');
      }

      // 5. Save user session
      _currentUser = userFromApi;
      await _sessionManager.saveUser(_currentUser!.toStorageJson());
      if (_currentUser!.apiToken != null) {
        await _sessionManager.saveToken(_currentUser!.apiToken!);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getFirebaseErrorMessage(e.code);
      debugPrint('Firebase registration error: $_errorMessage');
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      debugPrint('=== LOGOUT STARTED ===');
      debugPrint('Current user token before logout: ${_currentUser?.apiToken?.substring(0, 10)}...');

      // Logout from Laravel API
      if (_currentUser?.apiToken != null) {
        await _repository.logout();
      }

      // Logout from Firebase
      await _firebaseAuth.signOut();

      // Clear local session
      await clearSession();

      debugPrint('=== LOGOUT COMPLETED - Session cleared ===');
    } catch (e) {
      debugPrint('Logout error: ${e.toString()}');
      // Clear session anyway
      await clearSession();
    }
  }

  /// Clear local session
  Future<void> clearSession() async {
    await _sessionManager.clearSession();
    _currentUser = null;
    _errorMessage = null;

    // Verify token is actually cleared
    final tokenAfterClear = await _sessionManager.getToken();
    debugPrint('Token after clearSession: ${tokenAfterClear ?? "NULL (correctly cleared)"}');

    notifyListeners();
  }

  /// Refresh user data from API
  Future<void> _refreshUserFromApi() async {
    try {
      final updatedUser = await _repository.getCurrentUser();

      if (updatedUser != null) {
        _currentUser = updatedUser;
        await _sessionManager.saveUser(_currentUser!.toStorageJson());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to refresh user from API: ${e.toString()}');
    }
  }

  /// Update user data with UserModel object
  Future<void> updateUser(UserModel user) async {
    _currentUser = user;
    await _sessionManager.saveUser(_currentUser!.toStorageJson());
    if (_currentUser!.apiToken != null) {
      await _sessionManager.saveToken(_currentUser!.apiToken!);
    }
    notifyListeners();
  }

  /// Note: Profile updates are now handled by ProfileRepository
  /// Use ProfileRepository.updateProfile() instead

  /// Set phone number for OTP login
  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  /// Login with phone number (after OTP verification)
  /// This is called after OTP is verified
  /// Uses random email like old code: randomNumber@hawacom.sa
  Future<bool> loginWithPhoneNumber({
    required String phoneNumber,
    String? displayName,
    bool isNewUser = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      final password = 'hawacom123'; // Default password like old code

      UserModel? userFromApi;

      if (isNewUser) {
        // New user registration - generate random email like old code
        final randomNumber = Random().nextInt(100000000);
        final email = '$randomNumber@hawacom.sa';

        debugPrint('Registering new user with email: $email');

        userFromApi = await _repository.register(
          name: displayName ?? 'User $cleanPhone',
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          isDesigner: false,
        );
      } else {
        // Existing user login - try to find by phone number first
        debugPrint('Trying to login with phone: $cleanPhone');

        // Use loginWithPhone which looks up email by phone number
        userFromApi = await _repository.loginWithPhone(
          phoneNumber: phoneNumber,
          password: password,
        );

        // If not found, user doesn't exist - register them
        if (userFromApi == null) {
          debugPrint('User not found, registering new user');

          final randomNumber = Random().nextInt(100000000);
          final email = '$randomNumber@hawacom.sa';

          try {
            userFromApi = await _repository.register(
              name: displayName ?? 'User $cleanPhone',
              email: email,
              password: password,
              phoneNumber: phoneNumber,
              isDesigner: false,
            );
          } catch (e) {
            // Check if it's "phone already taken" error
            final errorMsg = e.toString().toLowerCase();
            if (errorMsg.contains('phone') && errorMsg.contains('taken')) {
              throw Exception(
                'رقم الجوال مسجل مسبقاً. حاول مرة أخرى أو تواصل مع الدعم\n'
                'Phone number already registered. Please try again or contact support.'
              );
            }
            rethrow;
          }
        }
      }

      if (userFromApi == null) {
        throw Exception('فشل تسجيل الدخول - Failed to login/register');
      }

      // Save user session
      _currentUser = userFromApi;
      await _sessionManager.saveUser(_currentUser!.toStorageJson());
      if (_currentUser!.apiToken != null) {
        await _sessionManager.saveToken(_currentUser!.apiToken!);
        debugPrint('=== PHONE LOGIN SUCCESS ===');
        debugPrint('New token saved: ${_currentUser!.apiToken!.substring(0, 10)}...');
        debugPrint('User ID: ${_currentUser!.id}');
        debugPrint('Phone: $phoneNumber');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل تسجيل الدخول: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get Firebase error message
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموح بها';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'too-many-requests':
        return 'طلبات كثيرة جداً. حاول مرة أخرى لاحقاً';
      default:
        return 'خطأ في المصادقة: $code';
    }
  }
}
