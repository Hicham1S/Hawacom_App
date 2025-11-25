import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../repositories/service_repository.dart';

/// Provider for managing services state
class ServiceProvider extends ChangeNotifier {
  final ServiceRepository _repository;

  ServiceProvider({ServiceRepository? repository})
      : _repository = repository ?? ServiceRepository();

  // State
  List<ServiceModel> _services = [];
  ServiceModel? _selectedService;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ServiceModel> get services => _services;
  ServiceModel? get selectedService => _selectedService;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Get all services
  Future<void> loadServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _repository.getAllServices();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل الخدمات: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get service by ID
  Future<void> loadServiceById(String serviceId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedService = await _repository.getServiceById(serviceId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل الخدمة: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get services by category
  Future<void> loadServicesByCategory(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _repository.getServicesByCategory(categoryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل خدمات الفئة: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get featured services
  Future<void> loadFeaturedServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _repository.getFeaturedServices();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل الخدمات المميزة: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search services
  Future<void> searchServices(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _repository.searchServices(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل البحث: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String serviceId, bool currentStatus) async {
    try {
      bool success;
      if (currentStatus) {
        success = await _repository.removeFromFavorites(serviceId);
      } else {
        success = await _repository.addToFavorites(serviceId);
      }

      if (success) {
        // Update the service in the list
        final index = _services.indexWhere((s) => s.id == serviceId);
        if (index != -1) {
          _services[index] = _services[index].copyWith(
            isFavorite: !currentStatus,
          );
        }

        // Update selected service if it's the same
        if (_selectedService?.id == serviceId) {
          _selectedService = _selectedService!.copyWith(
            isFavorite: !currentStatus,
          );
        }

        notifyListeners();
      }

      return success;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      return false;
    }
  }

  /// Clear selected service
  void clearSelectedService() {
    _selectedService = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
