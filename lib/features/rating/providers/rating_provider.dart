import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../repositories/rating_repository.dart';

/// Provider for managing rating/review state
class RatingProvider extends ChangeNotifier {
  final RatingRepository _repository;

  RatingProvider({RatingRepository? repository})
      : _repository = repository ?? RatingRepository();

  // State for submitting a review
  double _selectedRating = 0;
  String _reviewText = '';
  bool _isSubmitting = false;
  String? _errorMessage;

  // State for viewing reviews
  List<ReviewModel> _reviews = [];
  bool _isLoadingReviews = false;

  // Getters
  double get selectedRating => _selectedRating;
  String get reviewText => _reviewText;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  List<ReviewModel> get reviews => _reviews;
  bool get isLoadingReviews => _isLoadingReviews;

  /// Check if review can be submitted
  bool get canSubmit => _selectedRating > 0 && _reviewText.trim().isNotEmpty;

  /// Update selected rating
  void updateRating(double rating) {
    _selectedRating = rating;
    _errorMessage = null;
    notifyListeners();
  }

  /// Update review text
  void updateReviewText(String text) {
    _reviewText = text;
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset review form
  void resetReview() {
    _selectedRating = 0;
    _reviewText = '';
    _errorMessage = null;
    notifyListeners();
  }

  /// Submit review
  Future<bool> submitReview(String serviceId) async {
    // Validate
    if (_selectedRating < 1) {
      _errorMessage = 'الرجاء تحديد التقييم بالنقر على النجوم';
      notifyListeners();
      return false;
    }

    if (_reviewText.trim().isEmpty) {
      _errorMessage = 'الرجاء كتابة تعليقك عن الخدمة';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final review = await _repository.addReview(
        serviceId: serviceId,
        rating: _selectedRating,
        reviewText: _reviewText.trim(),
      );

      _isSubmitting = false;

      if (review != null) {
        // Reset form on success
        resetReview();
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'فشل في إرسال التقييم. الرجاء المحاولة مرة أخرى';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isSubmitting = false;
      _errorMessage = 'حدث خطأ: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Load reviews for a service
  Future<void> loadServiceReviews(String serviceId) async {
    _isLoadingReviews = true;
    notifyListeners();

    try {
      _reviews = await _repository.getServiceReviews(serviceId);
      _isLoadingReviews = false;
      notifyListeners();
    } catch (e) {
      _isLoadingReviews = false;
      debugPrint('Error loading reviews: $e');
      notifyListeners();
    }
  }

  /// Load user's reviews
  Future<void> loadUserReviews() async {
    _isLoadingReviews = true;
    notifyListeners();

    try {
      _reviews = await _repository.getUserReviews();
      _isLoadingReviews = false;
      notifyListeners();
    } catch (e) {
      _isLoadingReviews = false;
      debugPrint('Error loading user reviews: $e');
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
