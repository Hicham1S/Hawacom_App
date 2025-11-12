import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_localizations.dart';
import 'core/constants/colors.dart';
import 'core/services/firebase_service.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/route_generator.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (will be done when first accessed)
  // Firebase will auto-initialize on Android via google-services.json
  // and on iOS via GoogleService-Info.plist

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}