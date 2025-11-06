import 'package:equatable/equatable.dart';

/// Represents a single segment (image or video) within a user's story
class StorySegment extends Equatable {
  final String id;
  final String mediaUrl;
  final StoryMediaType mediaType;
  final Duration duration;
  final DateTime createdAt;

  StorySegment({
    required this.id,
    required this.mediaUrl,
    this.mediaType = StoryMediaType.image,
    this.duration = const Duration(seconds: 5),
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Equatable: Define which properties determine equality
  /// Two segments are equal if they have the same id
  @override
  List<Object?> get props => [id];
}

/// Types of media that can be in a story segment
enum StoryMediaType {
  image,
  video,
}
