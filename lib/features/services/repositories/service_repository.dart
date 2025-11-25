import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/service_model.dart';

/// Repository for service-related API calls
class ServiceRepository extends BaseRepository {
  ServiceRepository({super.apiClient});

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
            : (response.data['data'] as List? ?? []);

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
        return ServiceModel.fromJson(response.data as Map<String, dynamic>);
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
            : (response.data['data'] as List? ?? []);

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
            : (response.data['data'] as List? ?? []);

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

  /// Search services
  Future<List<ServiceModel>> searchServices(
    String query, {
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'search': query,
      };
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await apiClient.get(
        ApiEndpoints.services,
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

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
  Future<bool> addToFavorites(String serviceId) async {
    try {
      final response = await apiClient.post(
        'favorites',
        data: {'e_service_id': serviceId},
      );

      return response.success;
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      return false;
    }
  }

  /// Remove service from favorites
  Future<bool> removeFromFavorites(String serviceId) async {
    try {
      final response = await apiClient.delete(
        'favorites/$serviceId',
      );

      return response.success;
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      return false;
    }
  }
}
