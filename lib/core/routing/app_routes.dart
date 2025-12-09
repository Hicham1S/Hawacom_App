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

  // Profile & User routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String languageSettings = '/language-settings';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';

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

  // E-Provider routes
  static const String eProvider = '/e-provider';

  // Checkout & Payment
  static const String checkout = '/checkout';

  // Search & Categories
  static const String search = '/search';
  static const String category = '/category';
  static const String categoryDetails = '/category-details';

  // Notifications
  static const String notifications = '/notifications';

  // Favorites
  static const String favorites = '/favorites';

  // Rating/Review
  static const String rating = '/rating';

  // Gallery
  static const String gallery = '/gallery';

  // About & Support
  static const String about = '/about';
  static const String help = '/help';
  static const String support = '/support';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String customPage = '/custom-page';

  // Wallet
  static const String wallet = '/wallet';

  // Route helpers
  static String chatWithId(String userId) => '$chat?userId=$userId';
  static String serviceDetailsWithId(String serviceId) =>
      '$serviceDetails?serviceId=$serviceId';
  static String categoryWithId(String categoryId) =>
      '$category?categoryId=$categoryId';
}
