import '../../../core/repositories/base_repository.dart';
import '../../../core/config/api_config.dart';
import '../models/service_model.dart';

/// Repository for service (e-service) related API calls
class ServiceRepository extends BaseRepository {
  ServiceRepository({super.apiClient});

  /// Get all services with pagination
  Future<List<ServiceModel>> getAll({
    String? categoryId,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page.toString()};
      if (categoryId != null) {
        queryParams['search'] = 'categories.id:$categoryId';
      }

      final response = await apiClient.get(
        ApiConfig.eServices,
        queryParameters: queryParams,
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => ServiceModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get recommended services
  Future<List<ServiceModel>> getRecommended() async {
    try {
      final response = await apiClient.get(
        ApiConfig.eServices,
        queryParameters: {'recommended': 'true'},
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => ServiceModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get featured services
  Future<List<ServiceModel>> getFeatured({String? categoryId}) async {
    try {
      final queryParams = <String, dynamic>{'featured': 'true'};
      if (categoryId != null) {
        queryParams['search'] = 'categories.id:$categoryId';
      }

      final response = await apiClient.get(
        ApiConfig.eServices,
        queryParameters: queryParams,
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => ServiceModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get popular services
  Future<List<ServiceModel>> getPopular({String? categoryId}) async {
    try {
      final queryParams = <String, dynamic>{'popular': 'true'};
      if (categoryId != null) {
        queryParams['search'] = 'categories.id:$categoryId';
      }

      final response = await apiClient.get(
        ApiConfig.eServices,
        queryParameters: queryParams,
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => ServiceModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get most rated services
  Future<List<ServiceModel>> getMostRated({String? categoryId}) async {
    try {
      final queryParams = <String, dynamic>{'orderBy': 'rate', 'sortedBy': 'desc'};
      if (categoryId != null) {
        queryParams['search'] = 'categories.id:$categoryId';
      }

      final response = await apiClient.get(
        ApiConfig.eServices,
        queryParameters: queryParams,
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => ServiceModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Search services
  Future<List<ServiceModel>> search({
    required String keywords,
    List<String>? categoryIds,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'search': keywords,
        'page': page.toString(),
      };

      if (categoryIds != null && categoryIds.isNotEmpty) {
        queryParams['categories'] = categoryIds.join(',');
      }

      final response = await apiClient.get(
        ApiConfig.eServices,
        queryParameters: queryParams,
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => ServiceModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get service details by ID
  Future<ServiceModel?> getById(String id) async {
    try {
      final response = await apiClient.get('${ApiConfig.eServices}/$id');

      if (response.success && response.data is Map) {
        return ServiceModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
