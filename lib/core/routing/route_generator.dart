import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/messages/screens/messages_screen.dart';
import '../../features/messages/screens/chat_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/addresses_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/services/screens/service_detail_screen.dart';
import '../../features/bookings/screens/bookings_screen.dart';
import '../../features/bookings/screens/booking_detail_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/book_service/screens/book_service_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/language_settings_screen.dart';
import '../../features/home/screens/category_detail_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/profile/screens/address_form_screen.dart';
import '../../features/profile/models/address_model.dart';
import '../../features/rating/screens/rating_screen.dart';
import '../../features/gallery/screens/gallery_screen.dart';
import '../../features/services/models/media_model.dart';
import '../../features/help/screens/help_screen.dart';
import '../../features/help/screens/privacy_screen.dart';
import '../../features/e_provider/screens/e_provider_screen.dart';
import '../../features/e_provider/models/e_provider_model.dart';

/// Centralized route generator for the application
class RouteGenerator {
  /// Generate route based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract route name and arguments
    final routeName = settings.name;
    final args = settings.arguments;

    // Route mapping
    switch (routeName) {
      // Splash screen
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      // Home
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      // Profile
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );

      // Edit Profile
      case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
          settings: settings,
        );

      // Addresses
      case AppRoutes.addresses:
        return MaterialPageRoute(
          builder: (_) => const AddressesScreen(),
          settings: settings,
        );

      case AppRoutes.addAddress:
        return MaterialPageRoute(
          builder: (_) => const AddressFormScreen(),
          settings: settings,
        );

      case AppRoutes.editAddress:
        if (args is Map<String, dynamic>) {
          final address = args['address'] as AddressModel?;
          if (address != null) {
            return MaterialPageRoute(
              builder: (_) => AddressFormScreen(address: address),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'Edit address requires address object');

      // Messages
      case AppRoutes.messages:
        return MaterialPageRoute(
          builder: (_) => const MessagesScreen(),
          settings: settings,
        );

      // Chat (requires conversation argument)
      case AppRoutes.chat:
        if (args is Map<String, dynamic> && args.containsKey('conversation')) {
          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              conversation: args['conversation'],
            ),
            settings: settings,
          );
        }
        return _errorRoute(settings, 'Chat requires conversation argument');

      // Stories (not using routes - accessed via home screen)
      case AppRoutes.stories:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      // Authentication routes
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case AppRoutes.verifyOtp:
        if (args is Map<String, dynamic>) {
          final phoneNumber = args['phoneNumber'] as String?;
          final verificationId = args['verificationId'] as String?;
          final isExistingUser = args['isExistingUser'] as bool? ?? false;
          final displayName = args['displayName'] as String?;

          if (phoneNumber != null) {
            return MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(
                phoneNumber: phoneNumber,
                verificationId: verificationId,
                isExistingUser: isExistingUser,
                displayName: displayName,
              ),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'OTP verification requires phone number');

      // Service routes
      case AppRoutes.serviceDetails:
        if (args is Map<String, dynamic>) {
          final serviceId = args['serviceId'] as String?;
          if (serviceId != null) {
            return MaterialPageRoute(
              builder: (_) => ServiceDetailScreen(serviceId: serviceId),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'Service details requires serviceId');

      case AppRoutes.bookService:
        if (args is Map<String, dynamic>) {
          final service = args['service'];
          if (service != null) {
            return MaterialPageRoute(
              builder: (_) => BookServiceScreen(service: service),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'Book service requires service argument');

      // Booking routes
      case AppRoutes.myBookings:
        return MaterialPageRoute(
          builder: (_) => const BookingsScreen(),
          settings: settings,
        );

      case AppRoutes.bookingDetails:
        if (args is Map<String, dynamic>) {
          final bookingId = args['bookingId'] as String?;
          if (bookingId != null) {
            return MaterialPageRoute(
              builder: (_) => BookingDetailScreen(bookingId: bookingId),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'Booking details requires bookingId');

      // Search
      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );

      // Category Details
      case AppRoutes.categoryDetails:
        if (args is Map<String, dynamic>) {
          final categoryId = args['categoryId'] as String?;
          final categoryName = args['categoryName'] as String?;
          if (categoryId != null && categoryName != null) {
            return MaterialPageRoute(
              builder: (_) => CategoryDetailScreen(
                categoryId: categoryId,
                categoryName: categoryName,
              ),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'Category details requires categoryId and categoryName');

      // Checkout
      case AppRoutes.checkout:
        if (args is Map<String, dynamic>) {
          final booking = args['booking'];
          if (booking != null) {
            return MaterialPageRoute(
              builder: (_) => CheckoutScreen(booking: booking),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'Checkout requires booking argument');

      // Favorites
      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
          settings: settings,
        );

      // Notifications
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );

      // Rating
      case AppRoutes.rating:
        if (args is Map<String, dynamic>) {
          final serviceId = args['serviceId'] as String?;
          if (serviceId != null) {
            return MaterialPageRoute(
              builder: (_) => RatingScreen(
                serviceId: serviceId,
                serviceName: args['serviceName'] as String?,
                serviceImageUrl: args['serviceImageUrl'] as String?,
              ),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'Rating requires serviceId');

      // Gallery
      case AppRoutes.gallery:
        if (args is Map<String, dynamic>) {
          final mediaList = args['mediaList'] as List<MediaModel>?;
          if (mediaList != null && mediaList.isNotEmpty) {
            return MaterialPageRoute(
              builder: (_) => GalleryScreen(
                mediaList: mediaList,
                initialIndex: args['initialIndex'] as int? ?? 0,
                heroTag: args['heroTag'] as String?,
              ),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'Gallery requires mediaList');

      // Settings
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );

      case AppRoutes.languageSettings:
        return MaterialPageRoute(
          builder: (_) => const LanguageSettingsScreen(),
          settings: settings,
        );

      // Wallet
      case AppRoutes.wallet:
        return MaterialPageRoute(
          builder: (_) => const WalletScreen(),
          settings: settings,
        );

      // E-Provider
      case AppRoutes.eProvider:
        if (args is Map<String, dynamic>) {
          final eProviderId = args['eProviderId'] as String?;
          final eProvider = args['eProvider'] as EProviderModel?;
          if (eProviderId != null || eProvider != null) {
            return MaterialPageRoute(
              builder: (_) => EProviderScreen(
                eProviderId: eProviderId,
                eProvider: eProvider,
              ),
              settings: settings,
            );
          }
        }
        return _errorRoute(settings, 'E-Provider requires eProviderId or eProvider');

      // Help & Privacy
      case AppRoutes.help:
        return MaterialPageRoute(
          builder: (_) => const HelpScreen(),
          settings: settings,
        );

      case AppRoutes.privacy:
        // Check if custom URL or page ID is provided
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => PrivacyScreen(
              url: args['url'] as String?,
              pageId: args['pageId'] as String?,
              title: args['title'] as String?,
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const PrivacyScreen(),
          settings: settings,
        );

      case AppRoutes.customPage:
        // Custom page with WebView
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => PrivacyScreen(
              url: args['url'] as String?,
              pageId: args['pageId'] as String?,
              title: args['title'] as String?,
            ),
            settings: settings,
          );
        }
        return _errorRoute(settings, 'Custom page requires url or pageId');

      // Default: Unknown route
      default:
        return _errorRoute(settings, 'Route not found: $routeName');
    }
  }

  /// Error route for undefined or invalid routes
  static Route<dynamic> _errorRoute(RouteSettings settings, String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('خطأ - Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                child: const Text('العودة للرئيسية - Go Home'),
              ),
            ],
          ),
        ),
      ),
      settings: settings,
    );
  }

  /// Navigate with route name
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and replace current route
  static Future<T?> navigateAndReplace<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, void>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and remove all previous routes
  static Future<T?> navigateAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back
  static void goBack(BuildContext context, {Object? result}) {
    Navigator.pop(context, result);
  }

  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }
}

/// Extension for easy navigation
extension NavigationExtension on BuildContext {
  /// Navigate to route
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return RouteGenerator.navigateTo<T>(this, routeName, arguments: arguments);
  }

  /// Navigate and replace
  Future<T?> navigateAndReplace<T>(String routeName, {Object? arguments}) {
    return RouteGenerator.navigateAndReplace<T>(
      this,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and remove all
  Future<T?> navigateAndRemoveUntil<T>(String routeName, {Object? arguments}) {
    return RouteGenerator.navigateAndRemoveUntil<T>(
      this,
      routeName,
      arguments: arguments,
    );
  }

  /// Go back
  void goBack({Object? result}) {
    RouteGenerator.goBack(this, result: result);
  }

  /// Check if can go back
  bool canGoBack() {
    return RouteGenerator.canGoBack(this);
  }
}
