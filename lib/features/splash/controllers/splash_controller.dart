import 'package:flutter/foundation.dart';
import '../../auth/services/auth_service.dart';

/// Controller for splash screen business logic
/// Handles authentication check and navigation decision
/// Separated from UI for testability and maintainability
class SplashController {
  final AuthService _authService;

  SplashController({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Check authentication status
  /// Returns the route to navigate to after splash
  Future<SplashNavigationResult> initialize() async {
    try {
      final authState = await _authService.initialize();

      return SplashNavigationResult(
        isAuthenticated: authState.isAuthenticated,
        shouldNavigateToHome: authState.isAuthenticated,
      );
    } catch (e, stackTrace) {
      // Enhanced error logging with stack trace for debugging
      debugPrint('SplashController: Error checking auth status - $e');
      debugPrint('Stack trace: $stackTrace');

      // TODO: In production, send to analytics/crash reporting
      // Example: FirebaseCrashlytics.instance.recordError(e, stackTrace);

      // On error, assume not authenticated and go to login (safe default)
      return SplashNavigationResult(
        isAuthenticated: false,
        shouldNavigateToHome: false,
        error: e.toString(),
      );
    }
  }
}

/// Result of splash initialization
/// Contains navigation decision and error state
class SplashNavigationResult {
  final bool isAuthenticated;
  final bool shouldNavigateToHome;
  final String? error;

  SplashNavigationResult({
    required this.isAuthenticated,
    required this.shouldNavigateToHome,
    this.error,
  });

  bool get hasError => error != null;
}
