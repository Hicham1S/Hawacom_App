import 'package:flutter/foundation.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/faq_model.dart';
import '../models/faq_category_model.dart';

/// Repository for FAQ and Help-related API calls
class HelpRepository extends BaseRepository {
  HelpRepository({super.apiClient});

  /// Get all FAQ categories
  Future<List<FaqCategoryModel>> getFaqCategories() async {
    try {
      final response = await apiClient.get(
        'faq_categories',
        queryParameters: {
          'orderBy': 'created_at',
          'sortedBy': 'asc',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) =>
                FaqCategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting FAQ categories: $e');
      return [];
    }
  }

  /// Get FAQs for a specific category
  Future<List<FaqModel>> getFaqs(String categoryId) async {
    try {
      final response = await apiClient.get(
        'faqs',
        queryParameters: {
          'search': 'faq_category_id:$categoryId',
          'searchFields': 'faq_category_id:=',
          'searchJoin': 'and',
          'orderBy': 'updated_at',
          'sortedBy': 'desc',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) => FaqModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting FAQs: $e');
      return [];
    }
  }

  /// Get all FAQs (without category filter)
  Future<List<FaqModel>> getAllFaqs() async {
    try {
      final response = await apiClient.get(
        'faqs',
        queryParameters: {
          'orderBy': 'updated_at',
          'sortedBy': 'desc',
        },
      );

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);

        return data
            .map((json) => FaqModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting all FAQs: $e');
      return [];
    }
  }
}
