import 'package:flutter/foundation.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/services/session_manager.dart';
import '../models/review_model.dart';

/// Repository for rating and review API operations
class RatingRepository extends BaseRepository {
  final SessionManager _sessionManager;

  RatingRepository({super.apiClient, SessionManager? sessionManager})
      : _sessionManager = sessionManager ?? SessionManager();

  /// Submit a new review/rating for a service
  Future<ReviewModel?> addReview({
    required String serviceId,
    required double rating,
    required String reviewText,
  }) async {
    try {
      // Get current user from session
      final user = await _sessionManager.getUser();
      if (user == null) {
        debugPrint('Error adding review: User not logged in');
        return null;
      }

      // Get user ID from the map
      final userId = user['id']?.toString();
      if (userId == null) {
        debugPrint('Error adding review: User ID not found');
        return null;
      }

      final response = await apiClient.post(
        'e_service_reviews',
        data: {
          'e_service_id': serviceId,
          'user_id': userId,
          'rate': rating,
          'review': reviewText,
        },
      );

      if (response.success && response.data != null) {
        return ReviewModel.fromJson(response.data['data'] ?? response.data);
      }

      return null;
    } catch (e) {
      debugPrint('Error adding review: $e');
      return null;
    }
  }

  /// Get all reviews for a service
  Future<List<ReviewModel>> getServiceReviews(String serviceId) async {
    try {
      final response = await apiClient.get(
        'e_service_reviews',
        queryParameters: {
          'search': 'e_service_id:$serviceId',
          'searchFields': 'e_service_id:=',
          'with': 'user',
          'orderBy': 'created_at',
          'sortedBy': 'desc',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting service reviews: $e');
      return [];
    }
  }

  /// Get user's reviews
  Future<List<ReviewModel>> getUserReviews() async {
    try {
      final user = await _sessionManager.getUser();
      if (user == null) return [];

      final userId = user['id']?.toString();
      if (userId == null) return [];

      final response = await apiClient.get(
        'e_service_reviews',
        queryParameters: {
          'search': 'user_id:$userId',
          'searchFields': 'user_id:=',
          'with': 'eService',
          'orderBy': 'created_at',
          'sortedBy': 'desc',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting user reviews: $e');
      return [];
    }
  }
}
