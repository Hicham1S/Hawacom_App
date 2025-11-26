import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Model for application settings from backend
class AppSettingsModel extends Equatable {
  final String appName;
  final String defaultCurrency;
  final String defaultTax;
  final String appVersion;
  final String mobileLanguage;
  final bool enableVersion;
  final bool currencyRight;
  final int defaultCurrencyDecimalDigits;
  final String? googleMapsKey;
  final String? fcmKey;

  // Payment gateway settings
  final bool enableStripe;
  final bool enablePaypal;
  final bool enableRazorpay;

  // Theme colors (optional - can be overridden by app)
  final String? mainColor;
  final String? mainDarkColor;
  final String? secondColor;
  final String? secondDarkColor;
  final String? accentColor;
  final String? accentDarkColor;
  final String? scaffoldColor;
  final String? scaffoldDarkColor;

  const AppSettingsModel({
    required this.appName,
    required this.defaultCurrency,
    required this.defaultTax,
    required this.appVersion,
    this.mobileLanguage = 'ar',
    this.enableVersion = true,
    this.currencyRight = false,
    this.defaultCurrencyDecimalDigits = 2,
    this.googleMapsKey,
    this.fcmKey,
    this.enableStripe = false,
    this.enablePaypal = false,
    this.enableRazorpay = false,
    this.mainColor,
    this.mainDarkColor,
    this.secondColor,
    this.secondDarkColor,
    this.accentColor,
    this.accentDarkColor,
    this.scaffoldColor,
    this.scaffoldDarkColor,
  });

  /// Create from JSON
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      appName: json['app_name']?.toString() ?? 'Hawacom',
      defaultCurrency: json['default_currency']?.toString() ?? 'SAR',
      defaultTax: json['default_tax']?.toString() ?? '0',
      appVersion: json['app_version']?.toString() ?? '1.0.0',
      mobileLanguage: json['mobile_language']?.toString() ?? 'ar',
      enableVersion: json['enable_version'] == true || json['enable_version'] == 1,
      currencyRight: json['currency_right'] == true || json['currency_right'] == 1,
      defaultCurrencyDecimalDigits: int.tryParse(
            json['default_currency_decimal_digits']?.toString() ?? '2',
          ) ??
          2,
      googleMapsKey: json['google_maps_key']?.toString(),
      fcmKey: json['fcm_key']?.toString(),
      enableStripe: json['enable_stripe'] == true || json['enable_stripe'] == 1,
      enablePaypal: json['enable_paypal'] == true || json['enable_paypal'] == 1,
      enableRazorpay:
          json['enable_razorpay'] == true || json['enable_razorpay'] == 1,
      mainColor: json['main_color']?.toString(),
      mainDarkColor: json['main_dark_color']?.toString(),
      secondColor: json['second_color']?.toString(),
      secondDarkColor: json['second_dark_color']?.toString(),
      accentColor: json['accent_color']?.toString(),
      accentDarkColor: json['accent_dark_color']?.toString(),
      scaffoldColor: json['scaffold_color']?.toString(),
      scaffoldDarkColor: json['scaffold_dark_color']?.toString(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'default_currency': defaultCurrency,
      'default_tax': defaultTax,
      'app_version': appVersion,
      'mobile_language': mobileLanguage,
      'enable_version': enableVersion,
      'currency_right': currencyRight,
      'default_currency_decimal_digits': defaultCurrencyDecimalDigits,
      if (googleMapsKey != null) 'google_maps_key': googleMapsKey,
      if (fcmKey != null) 'fcm_key': fcmKey,
      'enable_stripe': enableStripe,
      'enable_paypal': enablePaypal,
      'enable_razorpay': enableRazorpay,
      if (mainColor != null) 'main_color': mainColor,
      if (mainDarkColor != null) 'main_dark_color': mainDarkColor,
      if (secondColor != null) 'second_color': secondColor,
      if (secondDarkColor != null) 'second_dark_color': secondDarkColor,
      if (accentColor != null) 'accent_color': accentColor,
      if (accentDarkColor != null) 'accent_dark_color': accentDarkColor,
      if (scaffoldColor != null) 'scaffold_color': scaffoldColor,
      if (scaffoldDarkColor != null) 'scaffold_dark_color': scaffoldDarkColor,
    };
  }

  /// Parse hex color to Flutter Color
  Color? parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return null;
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// Get main color
  Color? get mainColorValue => parseColor(mainColor);

  /// Get accent color
  Color? get accentColorValue => parseColor(accentColor);

  @override
  List<Object?> get props => [
        appName,
        defaultCurrency,
        defaultTax,
        appVersion,
        mobileLanguage,
        enableVersion,
        currencyRight,
        defaultCurrencyDecimalDigits,
      ];
}
