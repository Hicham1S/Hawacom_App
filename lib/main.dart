import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/constants/colors.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/route_generator.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/category_provider.dart';
import 'features/home/providers/service_provider.dart' as home_service;
import 'features/home/providers/slider_provider.dart';
import 'features/profile/providers/address_provider.dart';
import 'features/services/providers/service_provider.dart';
import 'features/bookings/providers/booking_provider.dart';
import 'features/search/providers/search_provider.dart';
import 'features/book_service/providers/book_service_provider.dart';
import 'features/checkout/providers/checkout_provider.dart';
import 'features/messages/providers/message_provider.dart';
import 'features/stories/providers/story_provider.dart';
import 'features/favorites/providers/favorite_provider.dart';
import 'features/notifications/providers/notification_provider.dart';
import 'features/settings/providers/language_provider.dart';
import 'features/rating/providers/rating_provider.dart';
import 'features/help/providers/help_provider.dart';
import 'features/e_provider/providers/e_provider_provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  // Initialize settings providers
  final languageProvider = LanguageProvider();
  await languageProvider.initialize();

  runApp(MyApp(
    languageProvider: languageProvider,
  ));
}

class MyApp extends StatelessWidget {
  final LanguageProvider languageProvider;

  const MyApp({
    super.key,
    required this.languageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Settings providers (pre-initialized)
        ChangeNotifierProvider.value(value: languageProvider),
        // Auth provider (initialized in SplashScreen)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Home feature providers
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => home_service.ServiceProvider()),
        ChangeNotifierProvider(create: (_) => SliderProvider()),
        // Profile feature providers
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        // Favorites provider (must be before ServiceProvider)
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        // Services feature providers (connected to FavoriteProvider)
        ChangeNotifierProxyProvider<FavoriteProvider, ServiceProvider>(
          create: (_) => ServiceProvider(),
          update: (_, favoriteProvider, serviceProvider) {
            serviceProvider!.setFavoriteProvider(favoriteProvider);
            return serviceProvider;
          },
        ),
        // Bookings feature providers
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        // Search feature providers
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        // Book Service provider
        ChangeNotifierProvider(create: (_) => BookServiceProvider()),
        // Checkout provider
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        // Messages provider
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        // Stories provider
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        // Notifications provider
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        // Rating provider
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        // Help provider
        ChangeNotifierProvider(create: (_) => HelpProvider()),
        // E-Provider provider
        ChangeNotifierProvider(create: (_) => EProviderProvider()),
        // Add more providers here as needed
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, child) {
          return MaterialApp(
            title: 'Design App',
            debugShowCheckedModeBanner: false,

            // Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Supported languages
            supportedLocales: const [
              Locale('ar'), // Arabic
              Locale('en'), // English
            ],

            // Use language from provider
            locale: langProvider.currentLocale,

            // Light theme only
            theme: ThemeData(
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.background,
              fontFamily: 'Cairo',
              textTheme: const TextTheme(
                bodyLarge:
                    TextStyle(color: AppColors.textPrimary, fontFamily: 'Cairo'),
                bodyMedium:
                    TextStyle(color: AppColors.textPrimary, fontFamily: 'Cairo'),
              ),
              useMaterial3: true,
            ),

            // Routing
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}