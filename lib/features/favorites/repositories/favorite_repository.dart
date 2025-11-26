import 'package:flutter/foundation.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/services/session_manager.dart';
import '../models/favorite_model.dart';

/// Repository for favorite-related API calls
class FavoriteRepository extends BaseRepository {
  final SessionManager _sessionManager;

  FavoriteRepository({super.apiClient, SessionManager? sessionManager})
      : _sessionManager = sessionManager ?? SessionManager();

  /// Get all user's favorites
  Future<List<FavoriteModel>> getAllFavorites() async {
    try {
      final response = await apiClient.get(
        'favorites',
        queryParameters: {
          'with': 'eService;eService.eProvider;eService.categories',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) => FavoriteModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  /// Add service to favorites
  Future<bool> addToFavorites(String serviceId) async {
    try {
      // Get current user from session
      final user = await _sessionManager.getUser();
      if (user == null) {
        debugPrint('Error adding to favorites: User not logged in');
        return false;
      }

      // Get user ID from the map
      final userId = user['id']?.toString();
      if (userId == null) {
        debugPrint('Error adding to favorites: User ID not found');
        return false;
      }

      final response = await apiClient.post(
        'favorites',
        data: {
          'e_service_id': serviceId,
          'user_id': userId,
        },
      );

      return response.success;
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      return false;
    }
  }

  /// Remove service from favorites
  Future<bool> removeFromFavorites(String favoriteId) async {
    try {
      final response = await apiClient.delete('favorites/$favoriteId');
      return response.success;
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      return false;
    }
  }

  /// Check if service is in favorites
  Future<bool> isFavorite(String serviceId) async {
    try {
      final favorites = await getAllFavorites();
      return favorites.any((fav) => fav.service.id == serviceId);
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }
}
