import 'package:flutter/material.dart';
import '../../services/providers/service_provider.dart';
import '../models/favorite_model.dart';
import '../repositories/favorite_repository.dart';

/// Provider for managing favorites state
class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _repository;
  final ServiceProvider? _serviceProvider;

  FavoriteProvider({
    FavoriteRepository? repository,
    ServiceProvider? serviceProvider,
  })  : _repository = repository ?? FavoriteRepository(),
        _serviceProvider = serviceProvider;

  // State
  List<FavoriteModel> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;
  Set<String> _favoriteServiceIds = {}; // For quick lookup

  // Getters
  List<FavoriteModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Check if a service is favorited (quick lookup)
  bool isFavorite(String serviceId) {
    return _favoriteServiceIds.contains(serviceId);
  }

  /// Get favorite by service ID
  FavoriteModel? getFavoriteByServiceId(String serviceId) {
    try {
      return _favorites.firstWhere((fav) => fav.service.id == serviceId);
    } catch (e) {
      return null;
    }
  }

  /// Load all favorites
  Future<void> loadFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favorites = await _repository.getAllFavorites();
      // Update quick lookup set
      _favoriteServiceIds = _favorites.map((fav) => fav.service.id).toSet();

      // Sync with ServiceProvider to override API's incorrect is_favorite flags
      _serviceProvider?.syncFavoriteIds(_favoriteServiceIds);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في تحميل المفضلة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Toggle favorite status for a service
  Future<bool> toggleFavorite(String serviceId) async {
    _errorMessage = null;

    if (isFavorite(serviceId)) {
      // Remove from favorites
      return await removeFromFavorites(serviceId);
    } else {
      // Add to favorites
      return await addToFavorites(serviceId);
    }
  }

  /// Add service to favorites
  Future<bool> addToFavorites(String serviceId) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.addToFavorites(serviceId);

      if (success) {
        // Reload favorites to get the new one with full data
        await loadFavorites();
      } else {
        _errorMessage = 'فشل في إضافة إلى المفضلة';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = 'فشل في إضافة إلى المفضلة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  /// Remove service from favorites
  Future<bool> removeFromFavorites(String serviceId) async {
    _errorMessage = null;

    // Find the favorite
    final favorite = getFavoriteByServiceId(serviceId);
    if (favorite == null) {
      _errorMessage = 'الخدمة ليست في المفضلة';
      notifyListeners();
      return false;
    }

    // IMMEDIATELY remove from local state for instant UI feedback
    _favorites.removeWhere((fav) => fav.id == favorite.id);
    _favoriteServiceIds.remove(serviceId);
    
    // Sync with ServiceProvider immediately
    _serviceProvider?.syncFavoriteIds(_favoriteServiceIds);
    
    notifyListeners();

    try {
      // Try to delete from backend
      final success = await _repository.removeFromFavorites(favorite.id);

      if (!success) {
        _errorMessage = 'فشل في إزالة من المفضلة';
        // Reload to get correct state from server
        await loadFavorites();
      }

      return success;
    } catch (e) {
      _errorMessage = 'فشل في إزالة من المفضلة: ${e.toString()}';
      debugPrint(_errorMessage);
      // Reload to restore correct state
      await loadFavorites();
      notifyListeners();
      return false;
    }
  }

  /// Refresh favorites
  Future<void> refresh() async {
    await loadFavorites();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all state - call when user logs out or switches accounts
  void clearState() {
    _favorites = [];
    _favoriteServiceIds.clear();
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
