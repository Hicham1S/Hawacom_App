import 'package:flutter/material.dart';
import '../../services/models/service_model.dart';
import '../../profile/models/address_model.dart';
import '../../profile/repositories/address_repository.dart';
import '../../bookings/models/booking_model.dart';
import '../../bookings/models/booking_status_model.dart';
import '../../bookings/repositories/booking_repository.dart';

/// Provider for managing service booking flow
class BookServiceProvider extends ChangeNotifier {
  final AddressRepository _addressRepository = AddressRepository();
  final BookingRepository _bookingRepository = BookingRepository();

  // Service being booked
  ServiceModel? _service;

  // Booking state
  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;
  DateTime _bookingDate = DateTime.now();
  TimeOfDay _bookingTime = TimeOfDay.now();
  bool _isScheduled = false;
  int _quantity = 1;
  double _duration = 1.0;
  String? _couponCode;
  String? _appliedCouponId;
  double _couponDiscount = 0.0;
  String? _notes;

  // Loading states
  bool _isLoading = false;
  bool _isLoadingAddresses = false;
  bool _isValidatingCoupon = false;
  String? _errorMessage;
  String? _couponError;

  // Getters
  ServiceModel? get service => _service;
  List<AddressModel> get addresses => _addresses;
  AddressModel? get selectedAddress => _selectedAddress;
  DateTime get bookingDate => _bookingDate;
  TimeOfDay get bookingTime => _bookingTime;
  bool get isScheduled => _isScheduled;
  int get quantity => _quantity;
  double get duration => _duration;
  String? get couponCode => _couponCode;
  String? get appliedCouponId => _appliedCouponId;
  double get couponDiscount => _couponDiscount;
  String? get notes => _notes;
  bool get isLoading => _isLoading;
  bool get isLoadingAddresses => _isLoadingAddresses;
  bool get isValidatingCoupon => _isValidatingCoupon;
  String? get errorMessage => _errorMessage;
  String? get couponError => _couponError;
  bool get hasCouponApplied => _appliedCouponId != null && _appliedCouponId!.isNotEmpty;

  /// Initialize booking with service
  void initializeBooking(ServiceModel service) {
    _service = service;
    _quantity = 1;
    _duration = service.priceUnit == 'hourly' ? 1.0 : 1.0;
    _bookingDate = DateTime.now();
    _bookingTime = TimeOfDay.now();
    _isScheduled = false;
    _couponCode = null;
    _appliedCouponId = null;
    _couponDiscount = 0.0;
    _notes = null;
    _errorMessage = null;
    _couponError = null;
    notifyListeners();
  }

  /// Load user addresses
  Future<void> loadAddresses() async {
    _isLoadingAddresses = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _addresses = await _addressRepository.getAddresses();
      if (_addresses.isNotEmpty && _selectedAddress == null) {
        _selectedAddress = _addresses.first;
      }
      _isLoadingAddresses = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل العناوين: $e';
      _isLoadingAddresses = false;
      notifyListeners();
    }
  }

  /// Select address
  void selectAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  /// Toggle scheduled booking
  void toggleScheduled(bool value) {
    _isScheduled = value;
    if (!value) {
      // Reset to now if not scheduled
      _bookingDate = DateTime.now();
      _bookingTime = TimeOfDay.now();
    }
    notifyListeners();
  }

  /// Set booking date
  void setBookingDate(DateTime date) {
    _bookingDate = date;
    notifyListeners();
  }

  /// Set booking time
  void setBookingTime(TimeOfDay time) {
    _bookingTime = time;
    notifyListeners();
  }

  /// Get combined booking DateTime
  DateTime get fullBookingDateTime {
    return DateTime(
      _bookingDate.year,
      _bookingDate.month,
      _bookingDate.day,
      _bookingTime.hour,
      _bookingTime.minute,
    );
  }

  /// Set quantity
  void setQuantity(int value) {
    if (value > 0) {
      _quantity = value;
      notifyListeners();
    }
  }

  /// Set duration (for hourly services)
  void setDuration(double value) {
    if (value > 0) {
      _duration = value;
      notifyListeners();
    }
  }

  /// Set notes
  void setNotes(String? value) {
    _notes = value;
    notifyListeners();
  }

  /// Set coupon code
  void setCouponCode(String? code) {
    _couponCode = code;
    _couponError = null;
    notifyListeners();
  }

  /// Validate and apply coupon
  Future<void> validateCoupon() async {
    if (_couponCode == null || _couponCode!.trim().isEmpty) {
      _couponError = 'الرجاء إدخال كود القسيمة';
      notifyListeners();
      return;
    }

    _isValidatingCoupon = true;
    _couponError = null;
    notifyListeners();

    try {
      // TODO: Call API to validate coupon
      // For now, simulate validation
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful coupon (in real app, get from API response)
      _appliedCouponId = 'COUPON_${_couponCode}';
      _couponDiscount = 10.0; // Mock 10 SAR discount
      _couponError = null;

      _isValidatingCoupon = false;
      notifyListeners();
    } catch (e) {
      _couponError = 'كود القسيمة غير صالح';
      _appliedCouponId = null;
      _couponDiscount = 0.0;
      _isValidatingCoupon = false;
      notifyListeners();
    }
  }

  /// Remove applied coupon
  void removeCoupon() {
    _couponCode = null;
    _appliedCouponId = null;
    _couponDiscount = 0.0;
    _couponError = null;
    notifyListeners();
  }

  /// Calculate subtotal
  double calculateSubtotal() {
    if (_service == null) return 0.0;

    if (_service!.priceUnit == 'fixed') {
      return _service!.actualPrice * _quantity;
    } else {
      // Hourly pricing
      return _service!.actualPrice * _duration;
    }
  }

  /// Calculate tax (assuming 15% VAT)
  double calculateTax() {
    return calculateSubtotal() * 0.15;
  }

  /// Calculate total
  double calculateTotal() {
    double subtotal = calculateSubtotal();
    double tax = calculateTax();
    double discount = _couponDiscount;
    return subtotal + tax - discount;
  }

  /// Create booking
  Future<BookingModel?> createBooking() async {
    if (_service == null) {
      _errorMessage = 'لا توجد خدمة محددة';
      notifyListeners();
      return null;
    }

    if (_selectedAddress == null) {
      _errorMessage = 'الرجاء تحديد العنوان';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create booking object
      final booking = BookingModel(
        id: '', // Will be set by server
        hint: _notes,
        duration: _duration,
        quantity: _quantity,
        status: const BookingStatusModel(id: '1', status: 'قيد الانتظار', order: 1),
        service: _service!,
        addressDescription: _selectedAddress!.description,
        addressLatitude: _selectedAddress!.latitude?.toString(),
        addressLongitude: _selectedAddress!.longitude?.toString(),
        bookingAt: fullBookingDateTime,
        taxesValue: calculateTax(),
        couponDiscount: _couponDiscount,
      );

      // Submit to API
      final createdBooking = await _bookingRepository.createBooking(booking);

      _isLoading = false;
      notifyListeners();
      return createdBooking;
    } catch (e) {
      _errorMessage = 'فشل إنشاء الحجز: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Clear booking state
  void clearBooking() {
    _service = null;
    _selectedAddress = null;
    _bookingDate = DateTime.now();
    _bookingTime = TimeOfDay.now();
    _isScheduled = false;
    _quantity = 1;
    _duration = 1.0;
    _couponCode = null;
    _appliedCouponId = null;
    _couponDiscount = 0.0;
    _notes = null;
    _errorMessage = null;
    _couponError = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
