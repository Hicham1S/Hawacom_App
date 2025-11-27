import 'package:flutter/material.dart';
import '../models/e_provider_model.dart';
import '../models/award_model.dart';
import '../models/experience_model.dart';
import '../repositories/e_provider_repository.dart';
import '../../services/models/service_model.dart';
import '../../rating/models/review_model.dart';

/// Provider for managing E-Provider state
class EProviderProvider extends ChangeNotifier {
  final EProviderRepository _repository;

  EProviderProvider({EProviderRepository? repository})
      : _repository = repository ?? EProviderRepository();

  // State
  EProviderModel? _eProvider;
  List<ReviewModel> _reviews = [];
  List<AwardModel> _awards = [];
  List<ExperienceModel> _experiences = [];
  List<ServiceModel> _featuredServices = [];
  bool _isAvailable = false;
  bool _isLoading = false;
  bool _isLoadingReviews = false;
  bool _isLoadingAwards = false;
  bool _isLoadingExperiences = false;
  bool _isLoadingServices = false;
  bool _isLoadingAvailability = false;
  String? _errorMessage;

  // Getters
  EProviderModel? get eProvider => _eProvider;
  List<ReviewModel> get reviews => _reviews;
  List<AwardModel> get awards => _awards;
  List<ExperienceModel> get experiences => _experiences;
  List<ServiceModel> get featuredServices => _featuredServices;
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  bool get isLoadingReviews => _isLoadingReviews;
  bool get isLoadingAwards => _isLoadingAwards;
  bool get isLoadingExperiences => _isLoadingExperiences;
  bool get isLoadingServices => _isLoadingServices;
  bool get isLoadingAvailability => _isLoadingAvailability;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasData => _eProvider != null && _eProvider!.hasData;

  /// Initialize with E-Provider ID
  Future<void> initialize(String eProviderId) async {
    await loadEProvider(eProviderId);
    await Future.wait([
      checkAvailability(eProviderId),
      loadReviews(eProviderId),
      loadAwards(eProviderId),
      loadExperiences(eProviderId),
      loadFeaturedServices(eProviderId),
    ]);
  }

  /// Set E-Provider directly (when passed from another screen)
  void setEProvider(EProviderModel provider) {
    _eProvider = provider;
    notifyListeners();
  }

  /// Load E-Provider
  Future<void> loadEProvider(String eProviderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _eProvider = await _repository.getEProvider(eProviderId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل في تحميل مزود الخدمة: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Load reviews
  Future<void> loadReviews(String eProviderId) async {
    _isLoadingReviews = true;
    notifyListeners();

    try {
      _reviews = await _repository.getReviews(eProviderId);
      _isLoadingReviews = false;
      notifyListeners();
    } catch (e) {
      _isLoadingReviews = false;
      debugPrint('Error loading reviews: $e');
      notifyListeners();
    }
  }

  /// Load awards
  Future<void> loadAwards(String eProviderId) async {
    _isLoadingAwards = true;
    notifyListeners();

    try {
      _awards = await _repository.getAwards(eProviderId);
      _isLoadingAwards = false;
      notifyListeners();
    } catch (e) {
      _isLoadingAwards = false;
      debugPrint('Error loading awards: $e');
      notifyListeners();
    }
  }

  /// Load experiences
  Future<void> loadExperiences(String eProviderId) async {
    _isLoadingExperiences = true;
    notifyListeners();

    try {
      _experiences = await _repository.getExperiences(eProviderId);
      _isLoadingExperiences = false;
      notifyListeners();
    } catch (e) {
      _isLoadingExperiences = false;
      debugPrint('Error loading experiences: $e');
      notifyListeners();
    }
  }

  /// Load featured services
  Future<void> loadFeaturedServices(String eProviderId) async {
    _isLoadingServices = true;
    notifyListeners();

    try {
      _featuredServices = await _repository.getFeaturedServices(eProviderId);
      _isLoadingServices = false;
      notifyListeners();
    } catch (e) {
      _isLoadingServices = false;
      debugPrint('Error loading featured services: $e');
      notifyListeners();
    }
  }

  /// Check availability
  Future<void> checkAvailability(String eProviderId) async {
    _isLoadingAvailability = true;
    notifyListeners();

    try {
      _isAvailable = await _repository.checkAvailability(eProviderId);
      _isLoadingAvailability = false;
      notifyListeners();
    } catch (e) {
      _isLoadingAvailability = false;
      debugPrint('Error checking availability: $e');
      notifyListeners();
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    if (_eProvider == null) return;

    await initialize(_eProvider!.id);
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _eProvider = null;
    _reviews = [];
    _awards = [];
    _experiences = [];
    _featuredServices = [];
    _isAvailable = false;
    _isLoading = false;
    _isLoadingReviews = false;
    _isLoadingAwards = false;
    _isLoadingExperiences = false;
    _isLoadingServices = false;
    _isLoadingAvailability = false;
    _errorMessage = null;
    notifyListeners();
  }
}
