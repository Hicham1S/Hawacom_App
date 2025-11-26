import 'package:flutter/material.dart';
import '../models/story.dart';
import '../repositories/story_repository.dart';

/// Provider for managing story state
class StoryProvider extends ChangeNotifier {
  final StoryRepository _repository;

  StoryProvider({StoryRepository? repository})
      : _repository = repository ?? StoryRepository();

  // State
  List<Story> _stories = [];
  List<Story> _displayableStories = [];
  List<Story> _viewableStories = [];
  Story? _selectedStory;
  int _currentStoryIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Story> get stories => _stories;
  List<Story> get displayableStories => _displayableStories;
  List<Story> get viewableStories => _viewableStories;
  Story? get selectedStory => _selectedStory;
  int get currentStoryIndex => _currentStoryIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Load all stories
  Future<void> loadStories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stories = await _repository.getAllStories();
      _displayableStories = await _repository.getDisplayableStories();
      _viewableStories = await _repository.getViewableStories();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في تحميل القصص: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Select a story to view
  void selectStory(Story story) {
    _selectedStory = story;
    _currentStoryIndex = _repository.getViewableIndex(story);
    notifyListeners();

    // Mark as viewed
    _repository.markAsViewed(story.id);
  }

  /// Clear selected story
  void clearSelectedStory() {
    _selectedStory = null;
    _currentStoryIndex = 0;
    notifyListeners();
  }

  /// Go to next story
  void nextStory() {
    if (_currentStoryIndex < _viewableStories.length - 1) {
      _currentStoryIndex++;
      _selectedStory = _viewableStories[_currentStoryIndex];
      notifyListeners();

      // Mark as viewed
      if (_selectedStory != null) {
        _repository.markAsViewed(_selectedStory!.id);
      }
    }
  }

  /// Go to previous story
  void previousStory() {
    if (_currentStoryIndex > 0) {
      _currentStoryIndex--;
      _selectedStory = _viewableStories[_currentStoryIndex];
      notifyListeners();
    }
  }

  /// Check if story can be viewed
  bool canViewStory(Story story) {
    return _repository.canViewStory(story);
  }

  /// Add a new story
  Future<bool> addStory({
    required String userId,
    required String userName,
    required String userImage,
    required List<String> mediaUrls,
    required bool isVideo,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.addStory(
        userId: userId,
        userName: userName,
        userImage: userImage,
        mediaUrls: mediaUrls,
        isVideo: isVideo,
      );

      if (success) {
        // Reload stories to include the new one
        await loadStories();
      } else {
        _errorMessage = 'فشل في إضافة القصة';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = 'فشل في إضافة القصة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Refresh stories
  Future<void> refresh() async {
    await loadStories();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
