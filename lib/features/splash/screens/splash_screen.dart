import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/constants/colors.dart';
import '../../auth/services/auth_service.dart';

/// Splash screen with video animation shown at app startup
/// Performs initialization checks and navigates to appropriate screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  /// Initialize and play the splash video
  Future<void> _initializeVideo() async {
    try {
      // Initialize video controller with the splash video
      _videoController = VideoPlayerController.asset(
        'assets/videos/splash.mp4',
      );

      // Initialize the video
      await _videoController.initialize();

      // Set video to mute (no sound)
      await _videoController.setVolume(0.0);

      // Update state to show video
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      // Play the video
      await _videoController.play();

      // Wait for video to complete or minimum duration
      await _navigateAfterVideo();
    } catch (e) {
      print('Error initializing splash video: $e');
      // If video fails, show fallback and navigate
      await _navigateAfterFallback();
    }
  }

  /// Navigate after video completes
  Future<void> _navigateAfterVideo() async {
    // Wait for video duration (or minimum 4 seconds)
    final videoDuration = _videoController.value.duration;
    final waitDuration = videoDuration.inSeconds > 0
        ? videoDuration
        : const Duration(seconds: 4);

    await Future.delayed(waitDuration);

    if (!mounted) return;

    // Check authentication and navigate
    await _checkAuthAndNavigate();
  }

  /// Navigate with fallback (if video fails)
  Future<void> _navigateAfterFallback() async {
    // Wait minimum duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check authentication and navigate
    await _checkAuthAndNavigate();
  }

  /// Check authentication status and navigate to appropriate screen
  Future<void> _checkAuthAndNavigate() async {
    final isLoggedIn = await _checkAuthStatus();

    if (!mounted) return;

    if (isLoggedIn) {
      // User is logged in, go to home
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      // User is not logged in, go to login
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  /// Check user authentication status
  /// Returns true if user is authenticated, false otherwise
  Future<bool> _checkAuthStatus() async {
    try {
      final authService = AuthService();
      final authState = await authService.initialize();

      return authState.isAuthenticated;
    } catch (e) {
      print('Error checking auth status: $e');
      return false;
    }
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
            : _buildFallbackSplash(),
      ),
    );
  }

  /// Fallback splash screen (shown while video loads or if video fails)
  /// Just a white screen to match the video background for seamless transition
  Widget _buildFallbackSplash() {
    return Container(
      color: Colors.white,
      // Empty white screen - seamless transition to video
    );
  }
}
