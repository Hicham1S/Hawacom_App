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
/// import 'localization/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
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

  /// No description provided for @profileMyBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get profileMyBookings;

  /// No description provided for @profileViewBookings.
  ///
  /// In en, this message translates to:
  /// **'View all bookings and orders'**
  String get profileViewBookings;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @messagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations'**
  String get messagesEmpty;

  /// No description provided for @messagesEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation'**
  String get messagesEmptyDesc;

  /// No description provided for @messagesNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get messagesNoResults;

  /// No description provided for @messagesSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get messagesSending;

  /// No description provided for @messagesTyping.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get messagesTyping;

  /// No description provided for @messagesOnline.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get messagesOnline;

  /// No description provided for @messagesOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get messagesOffline;

  /// No description provided for @messagesLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get messagesLastSeen;

  /// No description provided for @messagesNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get messagesNow;

  /// No description provided for @messagesMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get messagesMinutes;

  /// No description provided for @messagesHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get messagesHours;

  /// No description provided for @messagesDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get messagesDays;

  /// No description provided for @messagesYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get messagesYesterday;

  /// No description provided for @messagesTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get messagesTypeMessage;

  /// No description provided for @messagesAttach.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get messagesAttach;

  /// No description provided for @messagesSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get messagesSend;

  /// No description provided for @messagesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation'**
  String get messagesDelete;

  /// No description provided for @messagesMute.
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get messagesMute;

  /// No description provided for @messagesBlock.
  ///
  /// In en, this message translates to:
  /// **'Block user'**
  String get messagesBlock;

  /// No description provided for @messagesNewChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get messagesNewChat;

  /// No description provided for @messagesNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get messagesNoMessages;

  /// No description provided for @messagesStartChat.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation by sending a message'**
  String get messagesStartChat;

  /// No description provided for @messagesAttachmentSoon.
  ///
  /// In en, this message translates to:
  /// **'Attachments coming soon'**
  String get messagesAttachmentSoon;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get messagesTitle;

  /// No description provided for @messagesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search conversations'**
  String get messagesSearchHint;

  /// No description provided for @messagesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading conversations'**
  String get messagesLoadError;

  /// No description provided for @messagesStartPrompt.
  ///
  /// In en, this message translates to:
  /// **'Your conversations will appear here'**
  String get messagesStartPrompt;

  /// No description provided for @bookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Service'**
  String get bookingTitle;

  /// No description provided for @bookingAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get bookingAddress;

  /// No description provided for @bookingAddAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get bookingAddAddress;

  /// No description provided for @bookingNoAddresses.
  ///
  /// In en, this message translates to:
  /// **'No addresses found. Please add one.'**
  String get bookingNoAddresses;

  /// No description provided for @bookingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Service Schedule'**
  String get bookingSchedule;

  /// No description provided for @bookingNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get bookingNow;

  /// No description provided for @bookingLater.
  ///
  /// In en, this message translates to:
  /// **'Schedule Later'**
  String get bookingLater;

  /// No description provided for @bookingDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (Hours)'**
  String get bookingDuration;

  /// No description provided for @bookingQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get bookingQuantity;

  /// No description provided for @bookingCoupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get bookingCoupon;

  /// No description provided for @bookingCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied: {code}'**
  String bookingCouponApplied(String code);

  /// No description provided for @bookingEnterCoupon.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get bookingEnterCoupon;

  /// No description provided for @bookingApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get bookingApply;

  /// No description provided for @bookingNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get bookingNotes;

  /// No description provided for @bookingNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any special notes...'**
  String get bookingNotesHint;

  /// No description provided for @bookingPriceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Price Breakdown'**
  String get bookingPriceBreakdown;

  /// No description provided for @bookingSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get bookingSubtotal;

  /// No description provided for @bookingTax.
  ///
  /// In en, this message translates to:
  /// **'Tax (15%)'**
  String get bookingTax;

  /// No description provided for @bookingDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get bookingDiscount;

  /// No description provided for @bookingTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get bookingTotal;

  /// No description provided for @bookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get bookingConfirm;

  /// No description provided for @bookingRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get bookingRetry;

  /// No description provided for @bookingAddressNoDesc.
  ///
  /// In en, this message translates to:
  /// **'Address without description'**
  String get bookingAddressNoDesc;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get walletBalance;

  /// No description provided for @walletAddFunds.
  ///
  /// In en, this message translates to:
  /// **'Add Funds'**
  String get walletAddFunds;

  /// No description provided for @walletTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get walletTransactions;

  /// No description provided for @walletNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get walletNoTransactions;

  /// No description provided for @walletAddFundsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Funds added successfully'**
  String get walletAddFundsSuccess;

  /// No description provided for @walletAddFundsFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to add funds'**
  String get walletAddFundsFail;

  /// No description provided for @walletAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get walletAmount;

  /// No description provided for @walletAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get walletAdd;

  /// No description provided for @serviceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetailsTitle;

  /// No description provided for @serviceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Service not found'**
  String get serviceNotFound;

  /// No description provided for @serviceBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get serviceBack;

  /// No description provided for @serviceReviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get serviceReviews;

  /// No description provided for @serviceDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get serviceDuration;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get serviceDescription;

  /// No description provided for @serviceCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get serviceCategories;

  /// No description provided for @serviceProvider.
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get serviceProvider;

  /// No description provided for @serviceBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get serviceBookNow;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegister;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get authPhoneNumber;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get authRememberMe;

  /// No description provided for @authDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authDontHaveAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get authRegisterNow;

  /// No description provided for @authLoginNow.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginNow;

  /// No description provided for @authSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get authSigningIn;

  /// No description provided for @authCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get authCreatingAccount;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get authWelcomeBack;

  /// No description provided for @authCreateYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get authCreateYourAccount;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get authEmailHint;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get authPasswordHint;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullNameHint;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+966 123456789'**
  String get authPhoneHint;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @authResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link has been sent to your email'**
  String get authResetEmailSent;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get authBackToLogin;

  /// No description provided for @authVerifyOTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get authVerifyOTP;

  /// No description provided for @authEnterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code sent to'**
  String get authEnterOTP;

  /// No description provided for @authVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerify;

  /// No description provided for @authResendOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get authResendOTP;

  /// No description provided for @authOTPSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get authOTPSent;

  /// No description provided for @authInvalidOTP.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get authInvalidOTP;

  /// No description provided for @authOTPExpired.
  ///
  /// In en, this message translates to:
  /// **'Verification code expired'**
  String get authOTPExpired;

  /// No description provided for @authAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to Terms & Conditions'**
  String get authAgreeTerms;

  /// No description provided for @authMustAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'You must agree to Terms & Conditions'**
  String get authMustAgreeTerms;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authEmailRequired;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get authPasswordRequired;

  /// No description provided for @authFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get authFullNameRequired;

  /// No description provided for @authPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get authPhoneRequired;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get authInvalidEmail;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get authWeakPassword;

  /// No description provided for @authPasswordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsNotMatch;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordMinLength;

  /// No description provided for @authLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get authLoginSuccess;

  /// No description provided for @authRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get authRegisterSuccess;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogout;

  /// No description provided for @authLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get authLogoutConfirm;

  /// No description provided for @authCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get authCancel;

  /// No description provided for @authConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get authConfirm;

  /// No description provided for @authInvalidPhoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number with country code (e.g., +966...)'**
  String get authInvalidPhoneFormat;

  /// No description provided for @authLogoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get authLogoutSuccess;

  /// No description provided for @authLogoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed'**
  String get authLogoutFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
