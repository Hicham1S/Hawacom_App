import 'package:flutter/foundation.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/e_provider_model.dart';
import '../models/award_model.dart';
import '../models/experience_model.dart';
import '../../services/models/service_model.dart';
import '../../rating/models/review_model.dart';

/// Repository for E-Provider API calls
class EProviderRepository extends BaseRepository {
  EProviderRepository({super.apiClient});

  /// Get E-Provider by ID
  Future<EProviderModel?> getEProvider(String eProviderId) async {
    try {
      final response = await apiClient.get('e_providers/$eProviderId');

      if (response.success && response.data != null) {
        return EProviderModel.fromJson(response.data as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      debugPrint('Error getting e-provider: $e');
      return null;
    }
  }

  /// Get E-Provider reviews
  Future<List<ReviewModel>> getReviews(String eProviderId) async {
    try {
      final response = await apiClient.get(
        'e_provider_reviews',
        queryParameters: {
          'search': 'e_provider_id:$eProviderId',
          'searchFields': 'e_provider_id:=',
          'searchJoin': 'and',
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
      debugPrint('Error getting e-provider reviews: $e');
      return [];
    }
  }

  /// Get E-Provider awards
  Future<List<AwardModel>> getAwards(String eProviderId) async {
    try {
      final response = await apiClient.get(
        'awards',
        queryParameters: {
          'search': 'e_provider_id:$eProviderId',
          'searchFields': 'e_provider_id:=',
          'searchJoin': 'and',
          'orderBy': 'created_at',
          'sortedBy': 'desc',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) => AwardModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting e-provider awards: $e');
      return [];
    }
  }

  /// Get E-Provider experiences
  Future<List<ExperienceModel>> getExperiences(String eProviderId) async {
    try {
      final response = await apiClient.get(
        'experiences',
        queryParameters: {
          'search': 'e_provider_id:$eProviderId',
          'searchFields': 'e_provider_id:=',
          'searchJoin': 'and',
          'orderBy': 'created_at',
          'sortedBy': 'desc',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) =>
                ExperienceModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting e-provider experiences: $e');
      return [];
    }
  }

  /// Get E-Provider services
  Future<List<ServiceModel>> getEProviderServices(
    String eProviderId, {
    int page = 1,
  }) async {
    try {
      final response = await apiClient.get(
        'e_services',
        queryParameters: {
          'search': 'e_provider_id:$eProviderId',
          'searchFields': 'e_provider_id:=',
          'searchJoin': 'and',
          'orderBy': 'updated_at',
          'sortedBy': 'desc',
          'limit': '10',
          'offset': ((page - 1) * 10).toString(),
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
      debugPrint('Error getting e-provider services: $e');
      return [];
    }
  }

  /// Get featured E-Provider services
  Future<List<ServiceModel>> getFeaturedServices(
    String eProviderId, {
    int page = 1,
  }) async {
    try {
      final response = await apiClient.get(
        'e_services',
        queryParameters: {
          'search': 'e_provider_id:$eProviderId;featured:1',
          'searchFields': 'e_provider_id:=;featured:=',
          'searchJoin': 'and',
          'orderBy': 'updated_at',
          'sortedBy': 'desc',
          'limit': '10',
          'offset': ((page - 1) * 10).toString(),
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
      debugPrint('Error getting featured e-provider services: $e');
      return [];
    }
  }

  /// Check if E-Provider is available
  Future<bool> checkAvailability(String eProviderId) async {
    try {
      // Note: This uses a custom API endpoint from the old system
      // You may need to adjust the URL based on your backend
      final response = await apiClient.get(
        'availbelty',
        queryParameters: {'id': eProviderId},
      );

      if (response.success && response.data != null) {
        final data = response.data['data'];
        return data.toString() == 'true';
      }

      return false;
    } catch (e) {
      debugPrint('Error checking e-provider availability: $e');
      return false;
    }
  }
}
