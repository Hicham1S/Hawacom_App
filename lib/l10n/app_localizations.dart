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

  /// No description provided for @videoFileNotExist.
  ///
  /// In en, this message translates to:
  /// **'Video file does not exist'**
  String get videoFileNotExist;

  /// No description provided for @videoFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Video file too large ({size} MB). Maximum is 10 MB'**
  String videoFileTooLarge(String size);

  /// No description provided for @videoTooShort.
  ///
  /// In en, this message translates to:
  /// **'Video too short. Minimum is 1 second'**
  String get videoTooShort;

  /// No description provided for @videoTooLong.
  ///
  /// In en, this message translates to:
  /// **'Video too long ({duration} seconds). Maximum is 60 seconds'**
  String videoTooLong(int duration);

  /// No description provided for @videoReadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to read video file. Check video format'**
  String get videoReadError;

  /// No description provided for @videoValidationError.
  ///
  /// In en, this message translates to:
  /// **'Error validating video'**
  String get videoValidationError;

  /// No description provided for @videoRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Video Requirements:'**
  String get videoRequirementsTitle;

  /// No description provided for @videoRequirementDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: 1 to 60 seconds'**
  String get videoRequirementDuration;

  /// No description provided for @videoRequirementSize.
  ///
  /// In en, this message translates to:
  /// **'Size: Under 10 MB'**
  String get videoRequirementSize;

  /// No description provided for @videoRequirementFormat.
  ///
  /// In en, this message translates to:
  /// **'Format: MP4 (recommended)'**
  String get videoRequirementFormat;

  /// No description provided for @videoRequirementResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution: 720p or 1080p'**
  String get videoRequirementResolution;

  /// No description provided for @videoRequirementOrientation.
  ///
  /// In en, this message translates to:
  /// **'Orientation: Vertical (9:16)'**
  String get videoRequirementOrientation;

  /// No description provided for @addStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Story'**
  String get addStoryTitle;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @videoPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select video'**
  String get videoPickFailed;

  /// No description provided for @imagePickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select image'**
  String get imagePickFailed;

  /// No description provided for @videoRecordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to record video'**
  String get videoRecordFailed;

  /// No description provided for @storyUploadingSoon.
  ///
  /// In en, this message translates to:
  /// **'Story will be added soon'**
  String get storyUploadingSoon;

  /// No description provided for @recordVideo.
  ///
  /// In en, this message translates to:
  /// **'Record Video'**
  String get recordVideo;

  /// No description provided for @selectVideo.
  ///
  /// In en, this message translates to:
  /// **'Select Video'**
  String get selectVideo;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @selectImageOrVideo.
  ///
  /// In en, this message translates to:
  /// **'Select image or video'**
  String get selectImageOrVideo;

  /// No description provided for @videoRequirementsSummary.
  ///
  /// In en, this message translates to:
  /// **'Video: 1 to 60 seconds, under 10 MB'**
  String get videoRequirementsSummary;

  /// No description provided for @videoValidating.
  ///
  /// In en, this message translates to:
  /// **'Validating video...'**
  String get videoValidating;

  /// No description provided for @videoSuitable.
  ///
  /// In en, this message translates to:
  /// **'Video is suitable ({duration})'**
  String videoSuitable(String duration);

  /// No description provided for @videoSelected.
  ///
  /// In en, this message translates to:
  /// **'Video selected'**
  String get videoSelected;

  /// No description provided for @menuHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get menuHome;

  /// No description provided for @menuProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menuProfile;

  /// No description provided for @menuFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get menuFavorites;

  /// No description provided for @menuSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get menuSaved;

  /// No description provided for @menuProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get menuProjects;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get menuHelp;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// No description provided for @menuWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get menuWelcome;

  /// No description provided for @menuUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get menuUserName;

  /// No description provided for @menuLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get menuLogoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get profileProjects;

  /// No description provided for @profileFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profileFollowers;

  /// No description provided for @profileFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profileFollowing;

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get profileInformation;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get profileMemberSince;

  /// No description provided for @profileActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get profileActions;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileEditProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Update your information'**
  String get profileEditProfileDesc;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profileChangePassword;

  /// No description provided for @profileChangePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Update your security'**
  String get profileChangePasswordDesc;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profileLoadError;

  /// No description provided for @profileRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profileRetry;

  /// No description provided for @profileSettingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Settings coming soon'**
  String get profileSettingsComingSoon;

  /// No description provided for @profileEditComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit profile coming soon'**
  String get profileEditComingSoon;

  /// No description provided for @profilePasswordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Change password coming soon'**
  String get profilePasswordComingSoon;
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
