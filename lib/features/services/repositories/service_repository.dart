import 'package:flutter/foundation.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/services/session_manager.dart';
import '../models/service_model.dart';

/// Repository for service-related API calls
class ServiceRepository extends BaseRepository {
  final SessionManager _sessionManager;

  ServiceRepository({super.apiClient, SessionManager? sessionManager})
      : _sessionManager = sessionManager ?? SessionManager();

  /// Get all services
  Future<List<ServiceModel>> getAllServices({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await apiClient.get(
        ApiEndpoints.services,
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data is Map ? (response.data['data'] as List? ?? []) : []);

        return data
            .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting services: $e');
      return [];
    }
  }

  /// Get service by ID
  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.serviceById(serviceId),
      );

      if (response.success && response.data != null) {
        // Check if response.data is a Map before casting
        if (response.data is Map<String, dynamic>) {
          return ServiceModel.fromJson(response.data as Map<String, dynamic>);
        } else {
          debugPrint('Error: Expected Map but got ${response.data.runtimeType}');
          return null;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting service $serviceId: $e');
      return null;
    }
  }

  /// Get services by category
  Future<List<ServiceModel>> getServicesByCategory(
    String categoryId, {
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await apiClient.get(
        ApiEndpoints.servicesByCategory(categoryId),
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data is Map ? (response.data['data'] as List? ?? []) : []);

        return data
            .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting services for category $categoryId: $e');
      return [];
    }
  }

  /// Get featured services
  Future<List<ServiceModel>> getFeaturedServices({int limit = 10}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.services,
        queryParameters: {
          'featured': '1',
          'limit': limit,
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data is Map ? (response.data['data'] as List? ?? []) : []);

        return data
            .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting featured services: $e');
      return [];
    }
  }

  /// Search services with keywords and category filters
  Future<List<ServiceModel>> searchServices(
    String? keywords, {
    List<String>? categoryIds,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'with': 'eProvider;categories',
      };

      // Build search query
      final searchParts = <String>[];
      if (categoryIds != null && categoryIds.isNotEmpty) {
        searchParts.add('categories.id:${categoryIds.join(',')}');
      }
      if (keywords != null && keywords.isNotEmpty) {
        searchParts.add('name:$keywords');
      }

      if (searchParts.isNotEmpty) {
        queryParams['search'] = searchParts.join(';');
        queryParams['searchFields'] = categoryIds != null && categoryIds.isNotEmpty
            ? 'categories.id:in;name:like'
            : 'name:like';
        queryParams['searchJoin'] = 'and';
      }

      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await apiClient.get(
        ApiEndpoints.services,
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data is Map ? (response.data['data'] as List? ?? []) : []);

        return data
            .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error searching services: $e');
      return [];
    }
  }

  /// Add service to favorites
  /// Returns the favorite ID if successful, null otherwise
  Future<String?> addToFavorites(String serviceId) async {
    try {
      // Get current user from session
      final user = await _sessionManager.getUser();
      if (user == null) {
        debugPrint('Error adding to favorites: User not logged in');
        return null;
      }

      // Get user ID from the map
      final userId = user['id']?.toString();
      if (userId == null) {
        debugPrint('Error adding to favorites: User ID not found');
        return null;
      }

      final response = await apiClient.post(
        'favorites',
        data: {
          'e_service_id': serviceId,
          'user_id': userId,
        },
      );

      if (response.success && response.data != null) {
        // Extract favorite ID from response
        if (response.data is Map) {
          return response.data['id']?.toString();
        } else if (response.data is List && response.data.isNotEmpty) {
          return response.data[0]['id']?.toString();
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      return null;
    }
  }

  /// Remove service from favorites
  Future<bool> removeFromFavorites(String serviceId) async {
    try {
      // Get current user from session
      final user = await _sessionManager.getUser();
      if (user == null) {
        debugPrint('Error removing from favorites: User not logged in');
        return false;
      }

      // Get user ID from the map
      final userId = user['id']?.toString();
      if (userId == null) {
        debugPrint('Error removing from favorites: User ID not found');
        return false;
      }

      // The Laravel API uses the data in DELETE body to find the favorite to remove
      // Not the ID in the URL (which is just '1' as a placeholder)
      final response = await apiClient.delete(
        'favorites/1',
        data: {
          'e_service_id': serviceId,
          'user_id': userId,
        },
      );

      return response.success;
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      return false;
    }
  }
}
