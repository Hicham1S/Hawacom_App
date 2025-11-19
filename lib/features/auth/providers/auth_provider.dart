import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model_enhanced.dart';
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
  UserModelEnhanced? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  // Getters
  UserModelEnhanced? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

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
          _currentUser = UserModelEnhanced.fromStorageJson(savedUserJson);

          // Verify Firebase auth state matches
          final firebaseUser = _firebaseAuth.currentUser;
          if (firebaseUser == null) {
            // Firebase session expired, clear everything
            await clearSession();
          } else {
            // Refresh user data from API
            await _refreshUserFromApi();
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
      // Logout from Laravel API
      if (_currentUser?.apiToken != null) {
        await _repository.logout();
      }

      // Logout from Firebase
      await _firebaseAuth.signOut();

      // Clear local session
      await clearSession();
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
    notifyListeners();
  }

  /// Refresh user data from API
  Future<void> _refreshUserFromApi() async {
    try {
      UserModelEnhanced? updatedUser;

      // Try to get user from legacy PHP endpoint first (includes avatar)
      if (_currentUser?.phoneNumber != null) {
        updatedUser = await _repository.getUserByEmailOrPhone(_currentUser!.phoneNumber!);
      } else if (_currentUser?.email != null) {
        updatedUser = await _repository.getUserByEmailOrPhone(_currentUser!.email);
      }

      // Fallback to standard API endpoint
      if (updatedUser == null) {
        updatedUser = await _repository.getCurrentUser();
      }

      if (updatedUser != null) {
        _currentUser = updatedUser;
        await _sessionManager.saveUser(_currentUser!.toStorageJson());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to refresh user from API: ${e.toString()}');
    }
  }

  /// Update user data with UserModelEnhanced object
  Future<void> updateUser(UserModelEnhanced user) async {
    _currentUser = user;
    await _sessionManager.saveUser(_currentUser!.toStorageJson());
    if (_currentUser!.apiToken != null) {
      await _sessionManager.saveToken(_currentUser!.apiToken!);
    }
    notifyListeners();
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    String? bio,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return false;

    try {
      final updatedUser = await _repository.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        bio: bio,
        photoUrl: photoUrl,
      );

      if (updatedUser != null) {
        _currentUser = updatedUser;
        await _sessionManager.saveUser(_currentUser!.toStorageJson());
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update profile: ${e.toString()}';
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
