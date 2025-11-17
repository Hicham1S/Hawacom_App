import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/session_manager.dart';
import '../models/user_model.dart';
import '../models/auth_state.dart';

/// Authentication service for Firebase Auth operations
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SessionManager _sessionManager = SessionManager();

  // Current auth state
  AuthState _currentState = const AuthState.initial();
  AuthState get currentState => _currentState;

  // Current user
  UserModel? get currentUser => _currentState.user;

  /// Initialize auth service and check existing session
  Future<AuthState> initialize() async {
    try {
      await _sessionManager.initialize();

      // Check if user is logged in from previous session
      final isLoggedIn = await _sessionManager.isLoggedIn();
      final savedUser = await _sessionManager.getUser();

      if (isLoggedIn && savedUser != null) {
        // Check if Firebase user still exists
        final firebaseUser = _auth.currentUser;
        if (firebaseUser != null) {
          final user = UserModel.fromFirebaseUser(firebaseUser);
          _currentState = AuthState.authenticated(user);
          return _currentState;
        }
      }

      _currentState = const AuthState.unauthenticated();
      return _currentState;
    } catch (e) {
      _currentState = AuthState.error('Failed to initialize auth: $e');
      return _currentState;
    }
  }

  /// Sign in with email and password
  Future<AuthState> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _currentState = const AuthState.loading();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final user = UserModel.fromFirebaseUser(userCredential.user!);
        await _sessionManager.saveUser(user);

        // Get and save token
        final token = await userCredential.user!.getIdToken();
        if (token != null) {
          await _sessionManager.saveToken(token);
        }

        _currentState = AuthState.authenticated(user);
        return _currentState;
      }

      _currentState = const AuthState.error('Login failed');
      return _currentState;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseErrorMessage(e.code);
      _currentState = AuthState.error(errorMessage);
      return _currentState;
    } catch (e) {
      _currentState = AuthState.error('An unexpected error occurred: $e');
      return _currentState;
    }
  }

  /// Register with email and password
  Future<AuthState> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _currentState = const AuthState.loading();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name if provided
        if (displayName != null && displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
          await userCredential.user!.reload();
        }

        // Send email verification
        await userCredential.user!.sendEmailVerification();

        final user = UserModel.fromFirebaseUser(userCredential.user!);
        await _sessionManager.saveUser(user);

        // Get and save token
        final token = await userCredential.user!.getIdToken();
        if (token != null) {
          await _sessionManager.saveToken(token);
        }

        _currentState = AuthState.authenticated(user);
        return _currentState;
      }

      _currentState = const AuthState.error('Registration failed');
      return _currentState;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseErrorMessage(e.code);
      _currentState = AuthState.error(errorMessage);
      return _currentState;
    } catch (e) {
      _currentState = AuthState.error('An unexpected error occurred: $e');
      return _currentState;
    }
  }

  /// Sign in with phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(String error) verificationFailed,
    required Function(PhoneAuthCredential credential) verificationCompleted,
    Function(String verificationId)? codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (FirebaseAuthException e) {
          verificationFailed(_getFirebaseErrorMessage(e.code));
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout ?? (_) {},
      );
    } catch (e) {
      verificationFailed('Failed to verify phone number: $e');
    }
  }

  /// Sign in with phone credential
  Future<AuthState> signInWithPhoneCredential(
      PhoneAuthCredential credential) async {
    try {
      _currentState = const AuthState.loading();

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = UserModel.fromFirebaseUser(userCredential.user!);
        await _sessionManager.saveUser(user);

        // Get and save token
        final token = await userCredential.user!.getIdToken();
        if (token != null) {
          await _sessionManager.saveToken(token);
        }

        _currentState = AuthState.authenticated(user);
        return _currentState;
      }

      _currentState = const AuthState.error('Phone authentication failed');
      return _currentState;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseErrorMessage(e.code);
      _currentState = AuthState.error(errorMessage);
      return _currentState;
    } catch (e) {
      _currentState = AuthState.error('An unexpected error occurred: $e');
      return _currentState;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${_getFirebaseErrorMessage(e.code)}');
      return false;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  /// Sign out
  Future<AuthState> signOut() async {
    try {
      await _auth.signOut();
      await _sessionManager.clearSession();
      _currentState = const AuthState.unauthenticated();
      return _currentState;
    } catch (e) {
      _currentState = AuthState.error('Failed to sign out: $e');
      return _currentState;
    }
  }

  /// Reload current user
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        final user = UserModel.fromFirebaseUser(firebaseUser);
        await _sessionManager.saveUser(user);
        _currentState = AuthState.authenticated(user);
      }
    } catch (e) {
      print('Error reloading user: $e');
    }
  }

  /// Update display name
  Future<bool> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await reloadUser();
      return true;
    } catch (e) {
      print('Error updating display name: $e');
      return false;
    }
  }

  /// Update photo URL
  Future<bool> updatePhotoUrl(String photoUrl) async {
    try {
      await _auth.currentUser?.updatePhotoURL(photoUrl);
      await reloadUser();
      return true;
    } catch (e) {
      print('Error updating photo URL: $e');
      return false;
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      await _sessionManager.clearSession();
      _currentState = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      print('Error deleting account: $e');
      return false;
    }
  }

  /// Get Firebase error message in user-friendly format
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      case 'quota-exceeded':
        return 'SMS quota exceeded';
      default:
        return 'Authentication error: $code';
    }
  }
}
