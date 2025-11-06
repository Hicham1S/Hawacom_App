import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Video player widget specifically designed for story segments
/// Handles video playback with automatic play, progress tracking, and error handling
class StoryVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onVideoCompleted;
  final VoidCallback onVideoError;
  final AnimationController progressController;

  const StoryVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.onVideoCompleted,
    required this.onVideoError,
    required this.progressController,
  });

  @override
  State<StoryVideoPlayer> createState() => _StoryVideoPlayerState();
}

class _StoryVideoPlayerState extends State<StoryVideoPlayer> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      // Determine if this is a network or asset video
      if (widget.videoUrl.startsWith('http')) {
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
        );
      } else {
        _videoController = VideoPlayerController.asset(widget.videoUrl);
      }

      // Initialize the controller
      await _videoController.initialize();

      if (!mounted) return;

      // Get video duration
      final videoDuration = _videoController.value.duration;

      // Maximum story video duration is 60 seconds
      const maxDuration = Duration(seconds: 60);

      // If video is longer than 60 seconds, limit it
      final effectiveDuration = videoDuration > maxDuration ? maxDuration : videoDuration;

      debugPrint('Video duration: ${videoDuration.inSeconds}s, effective: ${effectiveDuration.inSeconds}s');

      setState(() {
        _isInitialized = true;
      });

      // Set up video listener for progress tracking
      _videoController.addListener(_videoListener);

      // Start playing automatically
      await _videoController.play();

      // Update the progress controller duration to match effective video duration (max 60s)
      widget.progressController.duration = effectiveDuration;
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
        widget.onVideoError();
      }
    }
  }

  /// Listener that tracks video progress and syncs with animation controller
  void _videoListener() {
    if (!mounted) return;

    final position = _videoController.value.position;
    final duration = widget.progressController.duration;

    // Ensure duration is valid
    if (duration == null || duration.inMilliseconds <= 0) return;

    final progress = position.inMilliseconds / duration.inMilliseconds;

    // Update the animation controller to match video progress
    widget.progressController.value = progress.clamp(0.0, 1.0);

    // Check if video has reached the maximum duration (60 seconds) or completed
    if (position >= duration || _videoController.value.isCompleted) {
      _videoController.removeListener(_videoListener);
      // Pause the video
      _videoController.pause();
      widget.onVideoCompleted();
      return;
    }

    // Handle errors during playback
    if (_videoController.value.hasError) {
      debugPrint('Video playback error: ${_videoController.value.errorDescription}');
      _videoController.removeListener(_videoListener);
      if (mounted && !_hasError) {
        setState(() {
          _hasError = true;
        });
        widget.onVideoError();
      }
    }
  }

  /// Pause video playback (used when user navigates away)
  void pause() {
    if (_isInitialized && _videoController.value.isPlaying) {
      _videoController.pause();
    }
  }

  /// Resume video playback
  void resume() {
    if (_isInitialized && !_videoController.value.isPlaying) {
      _videoController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      // Error state - this will trigger the parent's error handler
      return const SizedBox.shrink();
    }

    if (!_isInitialized) {
      // Loading state
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    // Display the video
    return Center(
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      ),
    );
  }
}
