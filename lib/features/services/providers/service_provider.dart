import 'package:flutter/material.dart';
import '../../favorites/providers/favorite_provider.dart';
import '../models/service_model.dart';
import '../repositories/service_repository.dart';

/// Provider for managing services state
class ServiceProvider extends ChangeNotifier {
  final ServiceRepository _repository;
  FavoriteProvider? _favoriteProvider;

  ServiceProvider({ServiceRepository? repository})
      : _repository = repository ?? ServiceRepository();

  /// Set the FavoriteProvider for synchronization
  void setFavoriteProvider(FavoriteProvider favoriteProvider) {
    _favoriteProvider = favoriteProvider;
  }

  // State
  List<ServiceModel> _services = [];
  ServiceModel? _selectedService;
  bool _isLoading = false;
  String? _errorMessage;

  // Local cache of favorited service IDs to override API's incorrect is_favorite
  final Set<String> _localFavoriteIds = {};

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

      // Override is_favorite with local truth if we have it
      if (_selectedService != null && _localFavoriteIds.contains(serviceId)) {
        _selectedService = _selectedService!.copyWith(isFavorite: true);
      } else if (_selectedService != null && !_localFavoriteIds.contains(serviceId)) {
        _selectedService = _selectedService!.copyWith(isFavorite: false);
      }

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
        // Remove from favorites
        success = await _repository.removeFromFavorites(serviceId);
        if (success) {
          _localFavoriteIds.remove(serviceId);
        }
      } else {
        // Add to favorites - returns favoriteId but we don't need to track it
        // because the API uses service_id + user_id to identify favorites
        final favoriteId = await _repository.addToFavorites(serviceId);
        success = favoriteId != null;
        if (success) {
          _localFavoriteIds.add(serviceId);
        }
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

        // Sync with FavoriteProvider to keep state consistent
        // Reload favorites to keep FavoriteProvider in sync
        if (_favoriteProvider != null) {
          debugPrint('🔄 Syncing with FavoriteProvider after toggle');
          await _favoriteProvider!.loadFavorites();
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

  /// Sync local favorite IDs from the favorites list
  /// Call this when favorites are loaded to keep state in sync
  void syncFavoriteIds(Set<String> favoriteServiceIds) {
    _localFavoriteIds.clear();
    _localFavoriteIds.addAll(favoriteServiceIds);

    // Re-apply to currently loaded services
    for (var i = 0; i < _services.length; i++) {
      _services[i] = _services[i].copyWith(
        isFavorite: _localFavoriteIds.contains(_services[i].id),
      );
    }

    // Re-apply to selected service
    if (_selectedService != null) {
      _selectedService = _selectedService!.copyWith(
        isFavorite: _localFavoriteIds.contains(_selectedService!.id),
      );
    }

    notifyListeners();
  }

  /// Clear all state - call when user logs out or switches accounts
  void clearState() {
    _services = [];
    _selectedService = null;
    _localFavoriteIds.clear();
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
