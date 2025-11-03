import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Design App'**
  String get appTitle;

  /// No description provided for @clickHere.
  ///
  /// In en, this message translates to:
  /// **'Click Here'**
  String get clickHere;

  /// No description provided for @addStory.
  ///
  /// In en, this message translates to:
  /// **'Add Story'**
  String get addStory;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search for service...'**
  String get search;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @restContent.
  ///
  /// In en, this message translates to:
  /// **'Rest of content will come here'**
  String get restContent;

  /// No description provided for @ahmadAlShehri.
  ///
  /// In en, this message translates to:
  /// **'Ahmad Al-Shehri'**
  String get ahmadAlShehri;

  /// No description provided for @aminaAlHajri.
  ///
  /// In en, this message translates to:
  /// **'Amina Al-Hajri'**
  String get aminaAlHajri;

  /// No description provided for @mohammedAli.
  ///
  /// In en, this message translates to:
  /// **'Mohammed Ali'**
  String get mohammedAli;

  /// No description provided for @sarahAhmed.
  ///
  /// In en, this message translates to:
  /// **'Sarah Ahmed'**
  String get sarahAhmed;

  /// No description provided for @startDesignProject.
  ///
  /// In en, this message translates to:
  /// **'Start Design Project Now'**
  String get startDesignProject;

  /// No description provided for @createAIImages.
  ///
  /// In en, this message translates to:
  /// **'Create Images with AI'**
  String get createAIImages;

  /// No description provided for @architecturalDesign.
  ///
  /// In en, this message translates to:
  /// **'Architectural Design'**
  String get architecturalDesign;

  /// No description provided for @socialMedia.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get socialMedia;

  /// No description provided for @interiorDecor.
  ///
  /// In en, this message translates to:
  /// **'Interior Decor'**
  String get interiorDecor;

  /// No description provided for @fashionDesign.
  ///
  /// In en, this message translates to:
  /// **'Fashion Design'**
  String get fashionDesign;

  /// No description provided for @hobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get hobbies;

  /// No description provided for @projectsGallery.
  ///
  /// In en, this message translates to:
  /// **'Projects Gallery'**
  String get projectsGallery;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @addStoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Add Story Coming Soon'**
  String get addStoryComingSoon;

  /// No description provided for @storyHasNoContent.
  ///
  /// In en, this message translates to:
  /// **'This story has no content'**
  String get storyHasNoContent;

  /// No description provided for @failedToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get failedToLoadImage;

  /// No description provided for @videoNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Video playback not yet implemented'**
  String get videoNotImplemented;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
