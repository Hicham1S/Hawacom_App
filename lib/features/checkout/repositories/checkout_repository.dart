import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/config/api_config.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../../bookings/models/booking_model.dart';

/// Repository for payment and checkout operations
class CheckoutRepository {
  final ApiClient apiClient;

  CheckoutRepository({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient();

  /// Get available payment methods
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await apiClient.get(ApiEndpoints.paymentMethods);

      if (response.data['success'] == true && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'] as List;
        return data
            .map((json) => PaymentMethodModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load payment methods: $e');
    }
  }

  /// Create payment for booking
  Future<PaymentModel> createPayment(BookingModel booking, PaymentMethodModel paymentMethod) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.payments,
        data: {
          'booking_id': booking.id,
          'payment_method_id': paymentMethod.id,
          'amount': booking.getTotal(),
        },
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        return PaymentModel.fromJson(response.data['data']);
      }

      throw Exception('Failed to create payment');
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  /// Get payment gateway URL for Stripe
  String getStripeUrl(String bookingId) {
    return '${ApiConfig.apiBaseUrl}/${ApiEndpoints.stripePaymentUrl(bookingId)}';
  }

  /// Get payment gateway URL for PayPal
  String getPayPalUrl(String bookingId) {
    return '${ApiConfig.apiBaseUrl}/${ApiEndpoints.paypalPaymentUrl(bookingId)}';
  }

  /// Get payment gateway URL for RazorPay
  String getRazorPayUrl(String bookingId) {
    return '${ApiConfig.apiBaseUrl}/${ApiEndpoints.razorpayPaymentUrl(bookingId)}';
  }

  /// Get payment gateway URL for PayStack
  String getPayStackUrl(String bookingId) {
    return '${ApiConfig.apiBaseUrl}/${ApiEndpoints.paystackPaymentUrl(bookingId)}';
  }

  /// Get payment gateway URL for FlutterWave
  String getFlutterWaveUrl(String bookingId) {
    return '${ApiConfig.apiBaseUrl}/${ApiEndpoints.flutterwavePaymentUrl(bookingId)}';
  }

  /// Get payment gateway URL for PayMob
  String getPayMobUrl(String bookingId) {
    return '${ApiConfig.apiBaseUrl}/${ApiEndpoints.paymobPaymentUrl(bookingId)}';
  }

  /// Get payment gateway URL for Stripe FPX
  String getStripeFPXUrl(String bookingId) {
    return '${ApiConfig.apiBaseUrl}/${ApiEndpoints.stripeFPXPaymentUrl(bookingId)}';
  }

  /// Create wallet payment
  Future<PaymentModel> createWalletPayment(BookingModel booking, String walletId) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.walletPayment,
        data: {
          'booking_id': booking.id,
          'wallet_id': walletId,
          'amount': booking.getTotal(),
        },
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        return PaymentModel.fromJson(response.data['data']);
      }

      throw Exception('Failed to create wallet payment');
    } catch (e) {
      throw Exception('Failed to create wallet payment: $e');
    }
  }

  /// Get payment by ID
  Future<PaymentModel> getPaymentById(String paymentId) async {
    try {
      final response = await apiClient.get(ApiEndpoints.paymentById(paymentId));

      if (response.data['success'] == true && response.data['data'] != null) {
        return PaymentModel.fromJson(response.data['data']);
      }

      throw Exception('Payment not found');
    } catch (e) {
      throw Exception('Failed to get payment: $e');
    }
  }
}
