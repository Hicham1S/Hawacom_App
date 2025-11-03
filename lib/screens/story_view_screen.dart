import 'package:flutter/material.dart';
import '../models/story.dart';
import '../models/story_segment.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';
import '../widgets/stories/story_video_player.dart';

/// Full-screen story viewer that displays story segments similar to Instagram/WhatsApp
class StoryViewScreen extends StatefulWidget {
  final List<Story> stories; // All stories to display
  final int initialStoryIndex; // Which story to start with

  const StoryViewScreen({
    super.key,
    required this.stories,
    required this.initialStoryIndex,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  int _currentStoryIndex = 0;
  int _currentSegmentIndex = 0;
  late AnimationController _progressController;
  bool _isClosing = false; // Flag to prevent rendering during close

  @override
  void initState() {
    super.initState();
    _currentStoryIndex = widget.initialStoryIndex;

    // Initialize the animation controller for progress bar
    _progressController = AnimationController(vsync: this);

    // Start playing the first segment
    _playCurrentSegment();
  }

  @override
  void dispose() {
    // Stop and clean up the animation controller
    _progressController.stop();
    _progressController.reset();
    _progressController.dispose();
    super.dispose();
  }

  /// Play the current segment with its duration
  void _playCurrentSegment() {
    // Safety check: ensure we're within bounds
    if (_currentStoryIndex >= widget.stories.length) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
      return;
    }

    final story = widget.stories[_currentStoryIndex];

    // Safety check: ensure story has segments
    if (story.segments.isEmpty || _currentSegmentIndex >= story.segments.length) {
      // This story has no more segments, move to next story
      _nextStory();
      return;
    }

    final segment = story.segments[_currentSegmentIndex];

    // Configure the animation controller
    _progressController.duration = segment.duration;

    // For video segments, let the video player control progress manually
    // For image segments, use automatic animation
    if (segment.mediaType == StoryMediaType.video) {
      // Reset to 0 and let video player control it
      _progressController.reset();
    } else {
      // For images, start automatic animation
      _progressController.forward(from: 0.0);

      // Listen for when the animation completes
      _progressController.addStatusListener(_onProgressComplete);
    }
  }

  /// Called when a segment's progress completes
  void _onProgressComplete(AnimationStatus status) {
    if (!mounted) return;

    if (status == AnimationStatus.completed) {
      _progressController.removeStatusListener(_onProgressComplete);

      // Small delay to prevent rapid state changes
      Future.microtask(() {
        if (mounted) {
          _nextSegment();
        }
      });
    }
  }

  /// Move to the next segment in the current story
  void _nextSegment() {
    if (!mounted || _isClosing) return;

    // Safety check: ensure we're within bounds
    if (_currentStoryIndex >= widget.stories.length) {
      _closeViewer();
      return;
    }

    final story = widget.stories[_currentStoryIndex];

    if (_currentSegmentIndex < story.segments.length - 1) {
      // There are more segments in this story
      if (!_isClosing) {
        setState(() {
          _currentSegmentIndex++;
        });
        _playCurrentSegment();
      }
    } else {
      // No more segments in this story
      // Check if this is the last story before moving
      if (_currentStoryIndex >= widget.stories.length - 1) {
        // This is the last story, close immediately without setState
        _closeViewer();
      } else {
        // Move to next story
        _nextStory();
      }
    }
  }

  /// Move to the previous segment
  void _previousSegment() {
    if (_currentSegmentIndex > 0) {
      // Go to previous segment in current story
      setState(() {
        _currentSegmentIndex--;
      });
      _playCurrentSegment();
    } else {
      // Go to previous story
      _previousStory();
    }
  }

  /// Move to the next story
  void _nextStory() {
    if (!mounted || _isClosing) return;

    if (_currentStoryIndex < widget.stories.length - 1) {
      if (!_isClosing) {
        setState(() {
          _currentStoryIndex++;
          _currentSegmentIndex = 0;
        });
        _playCurrentSegment();
      }
    } else {
      // No more stories, close the viewer
      _closeViewer();
    }
  }

  /// Safely close the story viewer
  void _closeViewer() {
    if (!mounted || _isClosing) return;

    // Set flag to prevent further state changes
    _isClosing = true;

    // Stop the animation controller to prevent it from running during navigation
    _progressController.stop();
    _progressController.reset();

    // Close immediately without waiting for next frame
    // Use Navigator.pop with error handling
    try {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error closing story viewer: $e');
    }
  }

  /// Move to the previous story
  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
        _currentSegmentIndex =
            widget.stories[_currentStoryIndex].segments.length - 1;
      });
      _playCurrentSegment();
    }
  }

  /// Handle tap on left side (previous segment)
  void _onTapLeft() {
    if (!mounted) return;
    _progressController.stop();
    _previousSegment();
  }

  /// Handle tap on right side (next segment)
  void _onTapRight() {
    if (!mounted) return;
    _progressController.stop();
    _nextSegment();
  }

  @override
  Widget build(BuildContext context) {
    // If we're in the process of closing, show black screen without crashing
    if (_isClosing) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.shrink(),
      );
    }

    // Safety check: ensure we're within bounds
    if (_currentStoryIndex >= widget.stories.length) {
      // Close the viewer if we're out of bounds
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _closeViewer();
      });
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.shrink(),
      );
    }

    final story = widget.stories[_currentStoryIndex];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTapDown: (details) {
            // Divide screen into left and right halves
            final screenWidth = MediaQuery.of(context).size.width;
            if (details.localPosition.dx < screenWidth / 2) {
              _onTapLeft();
            } else {
              _onTapRight();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Story content (image or video)
              _buildStoryContent(story),

              // Top gradient overlay for better readability
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Progress bars at the top
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 8,
                child: _buildProgressBars(story),
              ),

              // User info header
              Positioned(
                top: MediaQuery.of(context).padding.top + 32,
                left: 8,
                right: 8,
                child: _buildUserHeader(story),
              ),

              // Close button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _closeViewer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build error widget for failed image loading
  Widget _buildImageError(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Stop the current progress controller
    _progressController.stop();

    // Schedule moving to next segment after showing error briefly
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _nextSegment();
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white.withValues(alpha: 0.7),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.failedToLoadImage,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the story content (image or video)
  Widget _buildStoryContent(Story story) {
    // Safety check: ensure we have segments
    if (story.segments.isEmpty || _currentSegmentIndex >= story.segments.length) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final segment = story.segments[_currentSegmentIndex];

    if (segment.mediaType == StoryMediaType.image) {
      return segment.mediaUrl.startsWith('http')
          ? Image.network(
              segment.mediaUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Image failed to load, show error and skip to next segment
                debugPrint('Failed to load image: ${segment.mediaUrl}');
                debugPrint('Error: $error');
                return _buildImageError(context);
              },
            )
          : Image.asset(
              segment.mediaUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Failed to load asset: ${segment.mediaUrl}');
                return _buildImageError(context);
              },
            );
    } else if (segment.mediaType == StoryMediaType.video) {
      // Video player for video segments
      return StoryVideoPlayer(
        videoUrl: segment.mediaUrl,
        progressController: _progressController,
        onVideoCompleted: () {
          if (mounted) {
            _nextSegment();
          }
        },
        onVideoError: () {
          debugPrint('Video error: ${segment.mediaUrl}');
          if (mounted) {
            // Show error briefly then move to next segment
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                _nextSegment();
              }
            });
          }
        },
      );
    } else {
      // Unknown media type
      return Center(
        child: Text(
          'Unsupported media type',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      );
    }
  }

  /// Build progress bars showing segment progress
  Widget _buildProgressBars(Story story) {
    return Row(
      children: List.generate(
        story.segments.length,
        (index) {
          return Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  double progress;
                  if (index < _currentSegmentIndex) {
                    // Completed segments
                    progress = 1.0;
                  } else if (index == _currentSegmentIndex) {
                    // Current segment
                    progress = _progressController.value;
                  } else {
                    // Future segments
                    progress = 0.0;
                  }

                  return FractionallySizedBox(
                    alignment: Alignment.centerRight,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build user header with profile picture and name
  Widget _buildUserHeader(Story story) {
    return Row(
      children: [
        // Profile picture
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ClipOval(
            child: story.userImage.startsWith('http')
                ? Image.network(
                    story.userImage,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    story.userImage,
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        const SizedBox(width: 8),

        // User name
        Expanded(
          child: Text(
            story.userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Live badge if applicable
        if (story.isLive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.liveIndicator,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              AppLocalizations.of(context)!.live,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
