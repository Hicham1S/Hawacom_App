import 'package:flutter/material.dart';
import '../models/slide_model.dart';
import '../repositories/slider_repository.dart';

/// Provider for slider/banner state management
class SliderProvider extends ChangeNotifier {
  final SliderRepository _repository;

  SliderProvider({SliderRepository? repository})
      : _repository = repository ?? SliderRepository();

  // State
  List<SlideModel> _slides = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<SlideModel> get slides => _slides;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasSlides => _slides.isNotEmpty;

  /// Load home slider
  Future<void> loadSlider() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _slides = await _repository.getHomeSlider();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load slider: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Set current slide index
  void setCurrentIndex(int index) {
    if (index >= 0 && index < _slides.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
