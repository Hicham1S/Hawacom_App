import '../../../core/repositories/base_repository.dart';
import '../../../core/config/api_config.dart';
import '../models/category_model.dart';

/// Repository for category-related API calls
class CategoryRepository extends BaseRepository {
  CategoryRepository({super.apiClient});

  /// Get all categories
  Future<List<CategoryModel>> getAll() async {
    try {
      final response = await apiClient.get(ApiConfig.categories);

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get parent categories only
  Future<List<CategoryModel>> getAllParents() async {
    try {
      final response = await apiClient.get(
        ApiConfig.categories,
        queryParameters: {'parent': 'true'},
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get featured categories
  Future<List<CategoryModel>> getFeatured() async {
    try {
      final response = await apiClient.get(
        ApiConfig.categories,
        queryParameters: {'featured': 'true'},
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get subcategories for a parent category
  Future<List<CategoryModel>> getSubCategories(String parentId) async {
    try {
      final response = await apiClient.get(
        ApiConfig.categories,
        queryParameters: {'search': 'parent_id:$parentId'},
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get category with subcategories
  Future<List<CategoryModel>> getCategoriesWithSubs() async {
    try {
      final response = await apiClient.get(
        ApiConfig.categories,
        queryParameters: {
          'with': 'subCategories',
          'parent': 'true',
        },
      );

      if (response.success && response.data is List) {
        return (response.data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
