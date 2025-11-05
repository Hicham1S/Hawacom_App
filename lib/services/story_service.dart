import '../models/story.dart';
import '../data/mock_data.dart';

/// Service for handling story-related business logic
/// Separates data operations from UI concerns
class StoryService {
  /// Get all stories from the data source
  static List<Story> getAllStories() {
    return MockData.getStories();
  }

  /// Get stories that should be displayed in the stories section
  /// Filters out broken/empty stories, keeps "Add Story" button
  static List<Story> getDisplayableStories() {
    return getAllStories().where((story) {
      return story.isAddStory || story.segments.isNotEmpty;
    }).toList();
  }

  /// Get stories that can be viewed (excludes "Add Story" button and empty stories)
  static List<Story> getViewableStories() {
    return getAllStories()
        .where((story) => !story.isAddStory && story.segments.isNotEmpty)
        .toList();
  }

  /// Check if a story can be viewed
  static bool canViewStory(Story story) {
    return !story.isAddStory && story.segments.isNotEmpty;
  }

  /// Find the index of a story in the viewable stories list
  /// Returns -1 if story is not viewable
  static int getViewableIndex(Story story) {
    final viewableStories = getViewableStories();
    return viewableStories.indexOf(story);
  }

  /// Mark a story as viewed (for future implementation)
  /// Currently just a placeholder for when you add persistence
  static Future<void> markAsViewed(String storyId) async {
    // TODO: Implement story viewed tracking
    // This could save to local storage or send to backend
  }

  /// Add a new story (for future implementation)
  /// Currently just a placeholder for when you add story creation
  static Future<bool> addStory({
    required String userId,
    required String userName,
    required String userImage,
    required List<String> mediaUrls,
    required bool isVideo,
  }) async {
    // TODO: Implement story creation
    // This would upload media and create story record
    return false;
  }
}
