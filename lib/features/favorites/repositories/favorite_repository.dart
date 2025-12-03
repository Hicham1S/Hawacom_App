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
      // Get current user ID for client-side filtering
      final user = await _sessionManager.getUser();
      final currentUserId = user?['id']?.toString();

      if (currentUserId == null) {
        debugPrint('⚠️ No user logged in, cannot get favorites');
        return [];
      }

      debugPrint('📋 Fetching favorites for User ID: $currentUserId');

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

        final allFavorites = data
            .map((json) => FavoriteModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // CLIENT-SIDE FILTER: Only return favorites that belong to current user
        // This compensates for the Laravel API bug that returns all users' favorites
        final filteredFavorites = allFavorites.where((fav) {
          // Normalize both IDs to strings for comparison
          // API sometimes returns user_id as string, sometimes as number
          final favUserId = fav.userId.toString().trim();
          final currentUserIdStr = currentUserId.toString().trim();
          
          return favUserId == currentUserIdStr;
        }).toList();

        debugPrint('✅ Fetched ${filteredFavorites.length} favorites for user $currentUserId');

        if (allFavorites.length != filteredFavorites.length) {
          debugPrint('⚠️ Backend returned ${allFavorites.length - filteredFavorites.length} favorites from other users');
        }

        return filteredFavorites;
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

      if (response.success && response.data != null) {
        final savedFavoriteId = response.data['id']?.toString();
        debugPrint('✅ Favorite created - ID: $savedFavoriteId');
      }

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
