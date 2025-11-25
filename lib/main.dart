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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth provider
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        // Home feature providers
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => home_service.ServiceProvider()),
        ChangeNotifierProvider(create: (_) => SliderProvider()),
        // Profile feature providers
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        // Services feature providers
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        // Bookings feature providers
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        // Add more providers here as needed
      ],
      child: MaterialApp(
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

        // Default locale (Arabic)
        locale: const Locale('ar'),

        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Cairo',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.textPrimary, fontFamily: 'Cairo'),
            bodyMedium: TextStyle(color: AppColors.textPrimary, fontFamily: 'Cairo'),
          ),
          useMaterial3: true,
        ),

        // Routing
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}