import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../repositories/booking_repository.dart';

/// Provider for managing booking state
class BookingProvider extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  // State
  List<BookingModel> _bookings = [];
  List<BookingStatusModel> _bookingStatuses = [];
  BookingModel? _selectedBooking;
  String? _currentStatusId;
  bool _isLoading = false;
  bool _hasMorePages = true;
  int _currentPage = 1;
  String? _errorMessage;

  // Getters
  List<BookingModel> get bookings => _bookings;
  List<BookingStatusModel> get bookingStatuses => _bookingStatuses;
  BookingModel? get selectedBooking => _selectedBooking;
  String? get currentStatusId => _currentStatusId;
  bool get isLoading => _isLoading;
  bool get hasMorePages => _hasMorePages;
  String? get errorMessage => _errorMessage;

  /// Load all booking statuses (should be called once on init)
  Future<void> loadBookingStatuses() async {
    try {
      _bookingStatuses = await _repository.getBookingStatuses();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل حالات الحجوزات: $e';
      notifyListeners();
    }
  }

  /// Get status by order number
  BookingStatusModel? getStatusByOrder(int order) {
    try {
      return _bookingStatuses.firstWhere((s) => s.order == order);
    } catch (e) {
      return null;
    }
  }

  /// Load bookings for a specific status (with pagination)
  Future<void> loadBookings({String? statusId, bool refresh = false}) async {
    if (_isLoading) return;

    // If refreshing, reset pagination
    if (refresh) {
      _currentPage = 1;
      _bookings = [];
      _hasMorePages = true;
    }

    // If no more pages, don't load
    if (!_hasMorePages && !refresh) return;

    _isLoading = true;
    _errorMessage = null;
    _currentStatusId = statusId;
    notifyListeners();

    try {
      final newBookings = await _repository.getAllBookings(
        statusId: statusId,
        page: _currentPage,
        limit: 10,
      );

      if (newBookings.isEmpty) {
        _hasMorePages = false;
      } else {
        _bookings.addAll(newBookings);
        _currentPage++;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل الحجوزات: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more bookings (for pagination)
  Future<void> loadMoreBookings() async {
    await loadBookings(statusId: _currentStatusId);
  }

  /// Change active status tab and reload bookings
  Future<void> changeStatusTab(String statusId) async {
    if (_currentStatusId == statusId) return;
    await loadBookings(statusId: statusId, refresh: true);
  }

  /// Load a single booking by ID
  Future<void> loadBookingById(String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedBooking = await _repository.getBookingById(bookingId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل الحجز: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cancel a booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final success = await _repository.cancelBooking(bookingId);
      if (success) {
        // Remove from list
        _bookings.removeWhere((b) => b.id == bookingId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = 'فشل إلغاء الحجز: $e';
      notifyListeners();
      return false;
    }
  }

  /// Create a new booking
  Future<BookingModel?> createBooking(BookingModel booking) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newBooking = await _repository.createBooking(booking);
      _bookings.insert(0, newBooking);
      _isLoading = false;
      notifyListeners();
      return newBooking;
    } catch (e) {
      _errorMessage = 'فشل إنشاء الحجز: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Refresh bookings with current status
  Future<void> refreshBookings() async {
    await loadBookings(statusId: _currentStatusId, refresh: true);
  }

  /// Clear selected booking
  void clearSelectedBooking() {
    _selectedBooking = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
