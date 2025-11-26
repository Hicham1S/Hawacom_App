import 'package:flutter/material.dart';
import '../../services/models/service_model.dart';
import '../../services/repositories/service_repository.dart';
import '../../home/models/category_model.dart';
import '../../home/repositories/category_repository.dart';

/// Provider for managing search state
class SearchProvider extends ChangeNotifier {
  final ServiceRepository _serviceRepository = ServiceRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  // State
  List<ServiceModel> _searchResults = [];
  List<CategoryModel> _categories = [];
  final List<String> _selectedCategoryIds = [];
  String _searchKeywords = '';
  bool _isLoading = false;
  bool _isLoadingCategories = false;
  String? _errorMessage;

  // Getters
  List<ServiceModel> get searchResults => _searchResults;
  List<CategoryModel> get categories => _categories;
  List<String> get selectedCategoryIds => _selectedCategoryIds;
  String get searchKeywords => _searchKeywords;
  bool get isLoading => _isLoading;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get errorMessage => _errorMessage;
  bool get hasFilters => _selectedCategoryIds.isNotEmpty;

  /// Load all categories for filtering
  Future<void> loadCategories() async {
    if (_categories.isNotEmpty) return; // Already loaded

    _isLoadingCategories = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _categoryRepository.getAllParents();
      _isLoadingCategories = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل الفئات: $e';
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  /// Search services with current filters
  Future<void> searchServices(String keywords) async {
    _searchKeywords = keywords.trim();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _serviceRepository.searchServices(
        _searchKeywords.isEmpty ? null : _searchKeywords,
        categoryIds: _selectedCategoryIds.isEmpty ? null : _selectedCategoryIds,
        limit: 50,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل البحث: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle category selection
  void toggleCategory(String categoryId) {
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds.remove(categoryId);
    } else {
      _selectedCategoryIds.add(categoryId);
    }
    notifyListeners();

    // Auto-search when filters change
    if (_searchKeywords.isNotEmpty || _selectedCategoryIds.isNotEmpty) {
      searchServices(_searchKeywords);
    }
  }

  /// Check if a category is selected
  bool isCategorySelected(String categoryId) {
    return _selectedCategoryIds.contains(categoryId);
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategoryIds.clear();
    notifyListeners();

    // Re-search with no filters
    if (_searchKeywords.isNotEmpty) {
      searchServices(_searchKeywords);
    } else {
      _searchResults.clear();
      notifyListeners();
    }
  }

  /// Clear search
  void clearSearch() {
    _searchKeywords = '';
    _searchResults.clear();
    _selectedCategoryIds.clear();
    _errorMessage = null;
    notifyListeners();
  }

  /// Refresh search with current keywords and filters
  Future<void> refreshSearch() async {
    await searchServices(_searchKeywords);
  }
}
