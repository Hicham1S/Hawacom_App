import 'package:flutter/material.dart';
import '../repositories/checkout_repository.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../../bookings/models/booking_model.dart';

/// Provider for managing checkout and payment flow
class CheckoutProvider extends ChangeNotifier {
  final CheckoutRepository _repository = CheckoutRepository();

  // State
  BookingModel? _booking;
  List<PaymentMethodModel> _paymentMethods = [];
  PaymentMethodModel? _selectedPaymentMethod;
  PaymentModel? _payment;
  bool _isLoading = false;
  bool _isProcessingPayment = false;
  String? _errorMessage;

  // Getters
  BookingModel? get booking => _booking;
  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  PaymentMethodModel? get selectedPaymentMethod => _selectedPaymentMethod;
  PaymentModel? get payment => _payment;
  bool get isLoading => _isLoading;
  bool get isProcessingPayment => _isProcessingPayment;
  String? get errorMessage => _errorMessage;
  bool get hasPaymentMethods => _paymentMethods.isNotEmpty;

  /// Initialize checkout with booking
  void initializeCheckout(BookingModel booking) {
    _booking = booking;
    _selectedPaymentMethod = null;
    _payment = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Load available payment methods
  Future<void> loadPaymentMethods() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _paymentMethods = await _repository.getPaymentMethods();

      // Select default payment method if available
      if (_paymentMethods.isNotEmpty) {
        final defaultMethod = _paymentMethods.firstWhere(
          (method) => method.isDefault,
          orElse: () => _paymentMethods.first,
        );
        _selectedPaymentMethod = defaultMethod;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تحميل طرق الدفع: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select payment method
  void selectPaymentMethod(PaymentMethodModel method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  /// Process payment with selected method
  Future<bool> processPayment() async {
    if (_booking == null) {
      _errorMessage = 'لا يوجد حجز للدفع';
      notifyListeners();
      return false;
    }

    if (_selectedPaymentMethod == null) {
      _errorMessage = 'الرجاء اختيار طريقة الدفع';
      notifyListeners();
      return false;
    }

    _isProcessingPayment = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _payment = await _repository.createPayment(_booking!, _selectedPaymentMethod!);
      _isProcessingPayment = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'فشل معالجة الدفع: $e';
      _isProcessingPayment = false;
      notifyListeners();
      return false;
    }
  }

  /// Get payment gateway URL based on selected payment method
  String? getPaymentGatewayUrl() {
    if (_booking == null || _selectedPaymentMethod == null) return null;

    final route = _selectedPaymentMethod!.route?.toLowerCase() ?? '';
    final bookingId = _booking!.id;

    if (route.contains('stripe') && route.contains('fpx')) {
      return _repository.getStripeFPXUrl(bookingId);
    } else if (route.contains('stripe')) {
      return _repository.getStripeUrl(bookingId);
    } else if (route.contains('paypal')) {
      return _repository.getPayPalUrl(bookingId);
    } else if (route.contains('razorpay')) {
      return _repository.getRazorPayUrl(bookingId);
    } else if (route.contains('paystack')) {
      return _repository.getPayStackUrl(bookingId);
    } else if (route.contains('flutterwave')) {
      return _repository.getFlutterWaveUrl(bookingId);
    } else if (route.contains('paymob')) {
      return _repository.getPayMobUrl(bookingId);
    }

    return null;
  }

  /// Check if selected payment method requires external gateway
  bool requiresExternalGateway() {
    if (_selectedPaymentMethod == null) return false;
    final route = _selectedPaymentMethod!.route?.toLowerCase() ?? '';
    return route.contains('stripe') ||
        route.contains('paypal') ||
        route.contains('razorpay') ||
        route.contains('paystack') ||
        route.contains('flutterwave') ||
        route.contains('paymob');
  }

  /// Check if selected payment method is wallet
  bool isWalletPayment() {
    if (_selectedPaymentMethod == null) return false;
    return _selectedPaymentMethod!.isWallet;
  }

  /// Check if selected payment method is cash
  bool isCashPayment() {
    if (_selectedPaymentMethod == null) return false;
    return _selectedPaymentMethod!.isCash;
  }

  /// Process wallet payment
  Future<bool> processWalletPayment(String walletId) async {
    if (_booking == null) {
      _errorMessage = 'لا يوجد حجز للدفع';
      notifyListeners();
      return false;
    }

    _isProcessingPayment = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _payment = await _repository.createWalletPayment(_booking!, walletId);
      _isProcessingPayment = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'فشل الدفع من المحفظة: $e';
      _isProcessingPayment = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear checkout state
  void clearCheckout() {
    _booking = null;
    _selectedPaymentMethod = null;
    _payment = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get title theme for payment method (selected vs unselected)
  Color? getPaymentMethodColor(PaymentMethodModel method, Color primaryColor) {
    return method == _selectedPaymentMethod ? primaryColor : null;
  }

  /// Check if payment method can be selected (e.g., wallet has sufficient balance)
  bool canSelectPaymentMethod(PaymentMethodModel method) {
    // For now, all methods can be selected
    // TODO: Add wallet balance check when wallet feature is implemented
    return true;
  }
}
