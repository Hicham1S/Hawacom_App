import 'story_segment.dart';

class Story {
  final String id;
  final String userName;
  final String userImage;
  final bool isLive;
  final bool hasStory;
  final bool isAddStory;
  final List<StorySegment> segments;
  final DateTime createdAt;
  final bool isViewed;

  Story({
    required this.id,
    required this.userName,
    required this.userImage,
    this.isLive = false,
    this.hasStory = true,
    this.isAddStory = false,
    List<StorySegment>? segments,
    DateTime? createdAt,
    this.isViewed = false,
  })  : segments = segments ?? [],
        createdAt = createdAt ?? DateTime.now();

  /// Check if the story has expired (older than 24 hours)
  bool get isExpired {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours >= 24;
  }

  /// Get total duration of all segments
  Duration get totalDuration {
    return segments.fold(
      Duration.zero,
      (total, segment) => total + segment.duration,
    );
  }
}
