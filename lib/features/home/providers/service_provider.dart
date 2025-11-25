import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../repositories/service_repository.dart';

/// Provider for service (projects) state management
class ServiceProvider extends ChangeNotifier {
  final ServiceRepository _repository;

  ServiceProvider({ServiceRepository? repository})
      : _repository = repository ?? ServiceRepository();

  // State
  List<ServiceModel> _services = [];
  List<ServiceModel> _recommended = [];
  List<ServiceModel> _featured = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ServiceModel> get services => _services;
  List<ServiceModel> get recommended => _recommended;
  List<ServiceModel> get featured => _featured;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Load all services
  Future<void> loadServices({String? categoryId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _repository.getAll(categoryId: categoryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load services: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Load recommended services
  Future<void> loadRecommended() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommended = await _repository.getRecommended();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load recommended services: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Load featured services
  Future<void> loadFeatured({String? categoryId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _featured = await _repository.getFeatured(categoryId: categoryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load featured services: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Search services
  Future<List<ServiceModel>> search({
    required String keywords,
    List<String>? categoryIds,
  }) async {
    try {
      return await _repository.search(
        keywords: keywords,
        categoryIds: categoryIds,
      );
    } catch (e) {
      debugPrint('Failed to search services: ${e.toString()}');
      return [];
    }
  }

  /// Get service details
  Future<ServiceModel?> getServiceDetails(String id) async {
    try {
      return await _repository.getById(id);
    } catch (e) {
      debugPrint('Failed to get service details: ${e.toString()}');
      return null;
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadServices(),
      loadRecommended(),
      loadFeatured(),
    ]);
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
