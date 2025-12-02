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

      // if (response.success && response.data != null) {
      //   final List<dynamic> data = response.data is List
      //       ? response.data
      //       : (response.data['data'] as List? ?? []);

      //   final allFavorites = data
      //       .map((json) => FavoriteModel.fromJson(json as Map<String, dynamic>))
      //       .toList();

      //   // CLIENT-SIDE FILTER: Only return favorites that belong to current user
      //   // This compensates for the Laravel API bug that returns all users' favorites
      //   final filteredFavorites = allFavorites.where((fav) {
      //     // Normalize both IDs to strings for comparison
      //     // API sometimes returns user_id as string, sometimes as number
      //     final favUserId = fav.userId.toString().trim();
      //     final currentUserIdStr = currentUserId.toString().trim();
          
      //     debugPrint('🔍 Comparing favorite user_id: "$favUserId" with current user: "$currentUserIdStr"');
          
      //     return favUserId == currentUserIdStr;
      //   }).toList();

      //   debugPrint('✅ Total favorites from API: ${allFavorites.length}');
      //   debugPrint('✅ Filtered for current user: ${filteredFavorites.length}');

      //   if (allFavorites.length != filteredFavorites.length) {
      //     debugPrint('⚠️ WARNING: API returned favorites from other users!');
      //     debugPrint('   Expected user_id: $currentUserId');
      //     debugPrint('   Received user_ids: ${allFavorites.map((f) => f.userId).toSet()}');
      //     debugPrint('   This is a BACKEND BUG - the API should filter by user_id');
      //   }

      //   return filteredFavorites;
      // }
      debugPrint(" saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa $response.data.filter((s) => s.user_id == 404)");

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

      debugPrint('Userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr: $user');

      // // Get user ID from the map
      final userId = user['id']?.toString();
      // if (userId == null) {
      //   debugPrint('Error adding to favorites: User ID not found');
      //   return false;
      // }

      // debugPrint('➕ Adding favorite for user_id: $userId, service_id: $serviceId');

      final response = await apiClient.post(
        'favorites',
        data: {
          'e_service_id': serviceId,
          'user_id': userId,
        },
      );

      debugPrint("$response.data, respoooooooooooooooooooonnnnnnnnnnnnnnnnnnssssssssssssssse");

      // if (response.success && response.data != null) {
      //   // Log what the API actually saved
      //   final savedUserId = response.data['user_id']?.toString();
      //   final savedFavoriteId = response.data['id']?.toString();
      //   debugPrint('✅ Favorite created - ID: $savedFavoriteId, user_id: $savedUserId');
        
      //   if (savedUserId != userId) {
      //     debugPrint('⚠️ WARNING: Backend saved different user_id!');
      //     debugPrint('   Requested: $userId, Saved: $savedUserId');
      //   }
      // }

      // return response.success;
      return true;
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
