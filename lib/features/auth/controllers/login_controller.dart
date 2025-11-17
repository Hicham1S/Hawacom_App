import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

/// Controller for login screen business logic
/// Handles authentication validation and API calls
/// Separated from UI for testability and maintainability
class LoginController {
  final AuthService _authService;

  LoginController({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Validate phone number format
  bool isValidPhone(String phone) {
    // Remove spaces and special characters for validation
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // Check if starts with + and has 10-15 digits
    return RegExp(r'^\+[0-9]{10,15}$').hasMatch(cleanPhone);
  }

  /// Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Sign in with email and password
  /// Returns AuthState with authentication result
  Future<LoginResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final authState = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authState.isAuthenticated) {
        return LoginResult.success();
      } else {
        final sanitizedError = _sanitizeErrorMessage(
          authState.errorMessage ?? 'Login failed',
        );
        return LoginResult.error(sanitizedError);
      }
    } catch (e, stackTrace) {
      debugPrint('LoginController: Email sign-in error - $e');
      debugPrint('Stack trace: $stackTrace');

      final sanitizedError = _sanitizeErrorMessage(e.toString());
      return LoginResult.error(sanitizedError);
    }
  }

  /// Send password reset email
  /// Returns true if email was sent successfully
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      return await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      debugPrint('LoginController: Password reset error - $e');
      return false;
    }
  }

  /// Sanitize error messages to prevent sensitive info leakage
  /// Converts technical Firebase errors to user-friendly messages
  String _sanitizeErrorMessage(String error) {
    // Remove stack traces and technical details
    if (error.contains('Exception:')) {
      error = error.split('Exception:').last.trim();
    }

    // Map common Firebase errors to user-friendly messages
    if (error.contains('user-not-found')) {
      return 'No account found with this email';
    }
    if (error.contains('wrong-password')) {
      return 'Incorrect password';
    }
    if (error.contains('invalid-email')) {
      return 'Invalid email address';
    }
    if (error.contains('user-disabled')) {
      return 'This account has been disabled';
    }
    if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later';
    }
    if (error.contains('network-request-failed')) {
      return 'Network error. Check your internet connection';
    }

    // Generic fallback for unknown errors
    return 'Login failed. Please try again';
  }
}

/// Result of login operation
class LoginResult {
  final bool isSuccess;
  final String? errorMessage;

  LoginResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  factory LoginResult.success() => LoginResult._(isSuccess: true);

  factory LoginResult.error(String message) => LoginResult._(
        isSuccess: false,
        errorMessage: message,
      );
}
