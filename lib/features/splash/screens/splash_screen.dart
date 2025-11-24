import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../core/routing/app_routes.dart';
import '../../auth/providers/auth_provider.dart';

/// Splash screen with video animation shown at app startup
/// Production-ready implementation with:
/// - Parallel video + auth loading for performance
/// - Proper error handling and logging
/// - Uses AuthProvider for authentication check
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;

  bool _isVideoInitialized = false;
  bool _isNavigating = false;

  static const Duration _minimumDisplayTime = Duration(seconds: 2);
  static const Duration _fallbackDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  /// Initialize splash - runs video and auth check in parallel
  Future<void> _initializeSplash() async {
    // Create video controller first
    _videoController = VideoPlayerController.asset('assets/videos/splash.mp4');

    try {
      // Get AuthProvider
      final authProvider = context.read<AuthProvider>();

      // Run video initialization and auth check IN PARALLEL
      await Future.wait([
        _initializeVideo(),
        authProvider.initialize(),
      ]);

      // Wait for video to finish
      await _waitForCompletion();

      if (!mounted || _isNavigating) return;

      // Navigate based on auth status
      _navigateToNextScreen(authProvider.isAuthenticated);
    } catch (e) {
      debugPrint('SplashScreen: Error during initialization - $e');
      await _handleInitializationError();
    }
  }

  /// Initialize video player
  Future<void> _initializeVideo() async {
    try {
      await _videoController.initialize();
      await _videoController.setVolume(0.0);

      if (mounted) {
        setState(() => _isVideoInitialized = true);
      }

      await _videoController.play();
    } catch (e) {
      debugPrint('SplashScreen: Video initialization failed - $e');
      // Don't rethrow - we can continue without video
    }
  }

  /// Wait for video completion or minimum time
  Future<void> _waitForCompletion() async {
    final videoDuration = _videoController.value.isInitialized
        ? _videoController.value.duration
        : Duration.zero;

    // Use actual video duration if available, otherwise fallback
    final waitDuration = videoDuration > Duration.zero
        ? videoDuration
        : _fallbackDuration;

    // Ensure minimum display time
    final actualWaitTime = waitDuration > _minimumDisplayTime
        ? waitDuration
        : _minimumDisplayTime;

    await Future.delayed(actualWaitTime);
  }

  /// Handle initialization errors gracefully
  Future<void> _handleInitializationError() async {
    // Wait minimum time even on error for better UX
    await Future.delayed(_minimumDisplayTime);

    if (!mounted || _isNavigating) return;

    // On error, navigate to login (safe default)
    _navigateToNextScreen(false);
  }

  /// Navigate to appropriate screen based on auth status
  void _navigateToNextScreen(bool isAuthenticated) {
    if (_isNavigating) return;

    setState(() => _isNavigating = true);

    final targetRoute = isAuthenticated ? AppRoutes.home : AppRoutes.login;

    debugPrint('SplashScreen: Navigating to ${isAuthenticated ? "home" : "login"}');

    Navigator.pushReplacementNamed(context, targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isVideoInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            : Container(
                color: Colors.white,
                // Simple white screen while video loads
              ),
      ),
    );
  }
}
