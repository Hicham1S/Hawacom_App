/// Centralized route names for the application
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Core routes
  static const String splash = '/';
  static const String home = '/home';

  // Authentication routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';

  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // Messages routes
  static const String messages = '/messages';
  static const String chat = '/chat';

  // Stories routes
  static const String stories = '/stories';
  static const String createStory = '/create-story';

  // Service routes (from old project - to be implemented)
  static const String services = '/services';
  static const String serviceDetails = '/service-details';
  static const String bookService = '/book-service';
  static const String myBookings = '/my-bookings';
  static const String bookingDetails = '/booking-details';

  // Search & Categories
  static const String search = '/search';
  static const String category = '/category';

  // Notifications
  static const String notifications = '/notifications';

  // About & Support
  static const String about = '/about';
  static const String support = '/support';
  static const String terms = '/terms';
  static const String privacy = '/privacy';

  // Route helpers
  static String chatWithId(String userId) => '$chat?userId=$userId';
  static String serviceDetailsWithId(String serviceId) =>
      '$serviceDetails?serviceId=$serviceId';
  static String categoryWithId(String categoryId) =>
      '$category?categoryId=$categoryId';
}
