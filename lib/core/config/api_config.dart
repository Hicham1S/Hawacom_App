/// API Configuration
/// Contains base URLs and API endpoints
class ApiConfig {
  ApiConfig._(); // Private constructor to prevent instantiation

  // Base URLs
  static const String baseUrl = 'https://hawwcom.sa/public/';
  static const String apiPath = 'api/';
  static const String apiBaseUrl = '$baseUrl$apiPath';

  // API Endpoints

  // Authentication
  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String sendResetLinkEmail = 'send_reset_link_email';
  static const String user = 'user';

  // Categories
  static const String categories = 'categories';

  // Services (E-Services)
  static const String eServices = 'e_services';

  // Sliders/Banners
  static const String slides = 'slides';

  // Addresses
  static const String addresses = 'addresses';

  // Bookings
  static const String bookings = 'bookings';
  static const String bookingStatuses = 'booking_statuses';

  // Reviews
  static const String eServiceReviews = 'e_service_reviews';

  // Favorites
  static const String favorites = 'favorites';

  // Notifications
  static const String notifications = 'notifications';
  static const String notificationsCount = 'notifications/count';

  // Payments
  static const String paymentsCash = 'payments/cash';
  static const String paymentsWallets = 'payments/wallets';

  // Uploads
  static const String uploadsStore = 'uploads/store';
  static const String uploadsClear = 'uploads/clear';

  // FAQ
  static const String faqCategories = 'faq_categories';
  static const String faqs = 'faqs';

  // Custom Pages
  static const String customPages = 'custom_pages';

  // Payment Methods
  static const String paymentMethods = 'payment_methods';

  // Wallets
  static const String wallets = 'wallets';

  // Option Groups
  static const String optionGroups = 'option_groups';

  // Cache durations
  static const Duration cacheDuration = Duration(days: 3);
  static const Duration debugCacheDuration = Duration(minutes: 10);
}
