import 'package:flutter/foundation.dart';
import '../models/story.dart';
import '../services/story_service.dart';

/// Repository for story-related operations
/// Abstracts data source from business logic
class StoryRepository {
  /// Get all stories
  Future<List<Story>> getAllStories() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      return StoryService.getAllStories();
    } catch (e) {
      debugPrint('Error getting all stories: $e');
      return [];
    }
  }

  /// Get stories that should be displayed (includes "Add Story" button)
  Future<List<Story>> getDisplayableStories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return StoryService.getDisplayableStories();
    } catch (e) {
      debugPrint('Error getting displayable stories: $e');
      return [];
    }
  }

  /// Get stories that can be viewed (excludes "Add Story" button)
  Future<List<Story>> getViewableStories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return StoryService.getViewableStories();
    } catch (e) {
      debugPrint('Error getting viewable stories: $e');
      return [];
    }
  }

  /// Check if a story can be viewed
  bool canViewStory(Story story) {
    return StoryService.canViewStory(story);
  }

  /// Get the index of a story in viewable stories list
  int getViewableIndex(Story story) {
    return StoryService.getViewableIndex(story);
  }

  /// Mark story as viewed
  Future<void> markAsViewed(String storyId) async {
    try {
      await StoryService.markAsViewed(storyId);
    } catch (e) {
      debugPrint('Error marking story as viewed: $e');
    }
  }

  /// Add a new story
  Future<bool> addStory({
    required String userId,
    required String userName,
    required String userImage,
    required List<String> mediaUrls,
    required bool isVideo,
  }) async {
    try {
      return await StoryService.addStory(
        userId: userId,
        userName: userName,
        userImage: userImage,
        mediaUrls: mediaUrls,
        isVideo: isVideo,
      );
    } catch (e) {
      debugPrint('Error adding story: $e');
      return false;
    }
  }
}
