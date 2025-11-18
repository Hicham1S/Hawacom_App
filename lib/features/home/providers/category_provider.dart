import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';

/// Provider for category state management
class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryProvider({CategoryRepository? repository})
      : _repository = repository ?? CategoryRepository();

  // State
  List<CategoryModel> _categories = [];
  List<CategoryModel> _featured = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get featured => _featured;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Load all parent categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getAllParents();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load categories: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Load featured categories
  Future<void> loadFeatured() async {
    try {
      _featured = await _repository.getFeatured();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load featured categories: ${e.toString()}');
    }
  }

  /// Load categories with subcategories
  Future<List<CategoryModel>> loadCategoriesWithSubs() async {
    try {
      return await _repository.getCategoriesWithSubs();
    } catch (e) {
      debugPrint('Failed to load categories with subs: ${e.toString()}');
      return [];
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadCategories(),
      loadFeatured(),
    ]);
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
