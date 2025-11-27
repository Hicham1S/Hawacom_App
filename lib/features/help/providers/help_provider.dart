import 'package:flutter/material.dart';
import '../models/faq_model.dart';
import '../models/faq_category_model.dart';
import '../repositories/help_repository.dart';

/// Provider for managing Help/FAQ state
class HelpProvider extends ChangeNotifier {
  final HelpRepository _repository;

  HelpProvider({HelpRepository? repository})
      : _repository = repository ?? HelpRepository();

  // State
  List<FaqCategoryModel> _categories = [];
  List<FaqModel> _faqs = [];
  String? _selectedCategoryId;
  bool _isLoadingCategories = false;
  bool _isLoadingFaqs = false;
  String? _errorMessage;

  // Getters
  List<FaqCategoryModel> get categories => _categories;
  List<FaqModel> get faqs => _faqs;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingFaqs => _isLoadingFaqs;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isLoading => _isLoadingCategories || _isLoadingFaqs;

  /// Get selected category
  FaqCategoryModel? get selectedCategory {
    if (_selectedCategoryId == null) return null;
    try {
      return _categories.firstWhere((cat) => cat.id == _selectedCategoryId);
    } catch (e) {
      return null;
    }
  }

  /// Initialize - load categories and first category's FAQs
  Future<void> initialize() async {
    await loadCategories();
    if (_categories.isNotEmpty) {
      await loadFaqsForCategory(_categories.first.id);
    }
  }

  /// Load FAQ categories
  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getFaqCategories();
      _isLoadingCategories = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCategories = false;
      _errorMessage = 'فشل في تحميل الفئات: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Load FAQs for a specific category
  Future<void> loadFaqsForCategory(String categoryId) async {
    _selectedCategoryId = categoryId;
    _isLoadingFaqs = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _faqs = await _repository.getFaqs(categoryId);
      _isLoadingFaqs = false;
      notifyListeners();
    } catch (e) {
      _isLoadingFaqs = false;
      _errorMessage = 'فشل في تحميل الأسئلة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadCategories();
    if (_selectedCategoryId != null) {
      await loadFaqsForCategory(_selectedCategoryId!);
    } else if (_categories.isNotEmpty) {
      await loadFaqsForCategory(_categories.first.id);
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
