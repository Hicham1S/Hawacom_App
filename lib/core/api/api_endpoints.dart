/// Centralized API endpoints configuration
/// Prevents typos and makes endpoint changes easier to maintain
class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();

  // Auth endpoints (Laravel standard)
  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String user = 'user';
  static const String refreshToken = 'auth/refresh';
  static const String verifyOtp = 'auth/verify-otp';
  static const String forgotPassword = 'send_reset_link_email';

  // User endpoints
  static const String users = 'users';

  /// Get user by ID: users/{id}
  static String userById(String userId) => 'users/$userId';

  /// Change password: users/{id}/change-password
  static String changePassword(String userId) => 'users/$userId/change-password';

  /// Get user by email or phone (legacy endpoint)
  static String userByEmailOrPhone(String identifier) =>
      'auth/user?identifier=$identifier';

  // Category endpoints
  static const String categories = 'categories';
  static String categoryById(String categoryId) => 'categories/$categoryId';

  // Service/Project endpoints
  static const String services = 'e_services';
  static String serviceById(String serviceId) => 'e_services/$serviceId';
  static String servicesByCategory(String categoryId) =>
      'categories/$categoryId/e_services';

  // Slider/Banner endpoints
  static const String sliders = 'sliders';
  static const String banners = 'banners';

  // Address endpoints
  static const String addresses = 'addresses';
  static String addressById(String addressId) => 'addresses/$addressId';

  // Message/Chat endpoints (if using Laravel backend for messages)
  static const String conversations = 'conversations';
  static String conversationById(String conversationId) =>
      'conversations/$conversationId';
  static String conversationMessages(String conversationId) =>
      'conversations/$conversationId/messages';

  // Media upload endpoints (Laravel)
  static const String uploads = 'uploads/store';
  static const String deleteUpload = 'uploads/clear';

  // Booking endpoints
  static const String bookings = 'bookings';
  static String bookingById(String bookingId) => 'bookings/$bookingId';
  static const String bookingStatuses = 'booking_statuses';

  // Payment endpoints
  static const String paymentMethods = 'payment_methods';
  static const String paymentStatuses = 'payment_statuses';
  static const String payments = 'payments';
  static String paymentById(String paymentId) => 'payments/$paymentId';

  // Payment gateway URLs
  static String stripePaymentUrl(String bookingId) => 'payments/stripe/$bookingId';
  static String paypalPaymentUrl(String bookingId) => 'payments/paypal/$bookingId';
  static String razorpayPaymentUrl(String bookingId) => 'payments/razorpay/$bookingId';
  static String paystackPaymentUrl(String bookingId) => 'payments/paystack/$bookingId';
  static String flutterwavePaymentUrl(String bookingId) => 'payments/flutterwave/$bookingId';
  static String paymobPaymentUrl(String bookingId) => 'payments/paymob/$bookingId';
  static String stripeFPXPaymentUrl(String bookingId) => 'payments/stripe_fpx/$bookingId';

  // Wallet endpoints
  static const String wallets = 'wallets';
  static String walletById(String walletId) => 'wallets/$walletId';
  static String walletTransactions(String walletId) => 'wallets/$walletId/transactions';
  static const String walletPayment = 'payments/wallet';
}
