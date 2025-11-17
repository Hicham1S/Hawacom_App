// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Design App';

  @override
  String get clickHere => 'Click Here';

  @override
  String get addStory => 'Add Story';

  @override
  String get search => 'Search for service...';

  @override
  String get live => 'Live';

  @override
  String get restContent => 'Rest of content will come here';

  @override
  String get ahmadAlShehri => 'Ahmad Al-Shehri';

  @override
  String get aminaAlHajri => 'Amina Al-Hajri';

  @override
  String get mohammedAli => 'Mohammed Ali';

  @override
  String get sarahAhmed => 'Sarah Ahmed';

  @override
  String get startDesignProject => 'Start Design Project Now';

  @override
  String get createAIImages => 'Create Images with AI';

  @override
  String get architecturalDesign => 'Architectural Design';

  @override
  String get socialMedia => 'Social Media';

  @override
  String get interiorDecor => 'Interior Decor';

  @override
  String get fashionDesign => 'Fashion Design';

  @override
  String get hobbies => 'Hobbies';

  @override
  String get projectsGallery => 'Projects Gallery';

  @override
  String get viewAll => 'View All';

  @override
  String get addStoryComingSoon => 'Add Story Coming Soon';

  @override
  String get storyHasNoContent => 'This story has no content';

  @override
  String get failedToLoadImage => 'Failed to load image';

  @override
  String get videoNotImplemented => 'Video playback not yet implemented';

  @override
  String get videoFileNotExist => 'Video file does not exist';

  @override
  String videoFileTooLarge(String size) {
    return 'Video file too large ($size MB). Maximum is 10 MB';
  }

  @override
  String get videoTooShort => 'Video too short. Minimum is 1 second';

  @override
  String videoTooLong(int duration) {
    return 'Video too long ($duration seconds). Maximum is 60 seconds';
  }

  @override
  String get videoReadError => 'Failed to read video file. Check video format';

  @override
  String get videoValidationError => 'Error validating video';

  @override
  String get videoRequirementsTitle => 'Video Requirements:';

  @override
  String get videoRequirementDuration => 'Duration: 1 to 60 seconds';

  @override
  String get videoRequirementSize => 'Size: Under 10 MB';

  @override
  String get videoRequirementFormat => 'Format: MP4 (recommended)';

  @override
  String get videoRequirementResolution => 'Resolution: 720p or 1080p';

  @override
  String get videoRequirementOrientation => 'Orientation: Vertical (9:16)';

  @override
  String get addStoryTitle => 'Add Story';

  @override
  String get publish => 'Publish';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get videoPickFailed => 'Failed to select video';

  @override
  String get imagePickFailed => 'Failed to select image';

  @override
  String get videoRecordFailed => 'Failed to record video';

  @override
  String get storyUploadingSoon => 'Story will be added soon';

  @override
  String get recordVideo => 'Record Video';

  @override
  String get selectVideo => 'Select Video';

  @override
  String get selectImage => 'Select Image';

  @override
  String get selectImageOrVideo => 'Select image or video';

  @override
  String get videoRequirementsSummary => 'Video: 1 to 60 seconds, under 10 MB';

  @override
  String get videoValidating => 'Validating video...';

  @override
  String videoSuitable(String duration) {
    return 'Video is suitable ($duration)';
  }

  @override
  String get videoSelected => 'Video selected';

  @override
  String get menuHome => 'Home';

  @override
  String get menuProfile => 'Profile';

  @override
  String get menuFavorites => 'Favorites';

  @override
  String get menuSaved => 'Saved';

  @override
  String get menuProjects => 'Projects';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuHelp => 'Help';

  @override
  String get menuAbout => 'About';

  @override
  String get menuLogout => 'Logout';

  @override
  String get menuWelcome => 'Welcome';

  @override
  String get menuUserName => 'User';

  @override
  String get menuLogoutConfirm => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileProjects => 'Projects';

  @override
  String get profileFollowers => 'Followers';

  @override
  String get profileFollowing => 'Following';

  @override
  String get profileInformation => 'Information';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileMemberSince => 'Member Since';

  @override
  String get profileActions => 'Actions';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileEditProfileDesc => 'Update your information';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileChangePasswordDesc => 'Update your security';

  @override
  String get profileLoadError => 'Failed to load profile';

  @override
  String get profileRetry => 'Retry';

  @override
  String get profileSettingsComingSoon => 'Settings coming soon';

  @override
  String get profileEditComingSoon => 'Edit profile coming soon';

  @override
  String get profilePasswordComingSoon => 'Change password coming soon';

  @override
  String get messages => 'Messages';

  @override
  String get messagesEmpty => 'No conversations';

  @override
  String get messagesEmptyDesc => 'Start a new conversation';

  @override
  String get messagesNoResults => 'No results found';

  @override
  String get messagesSending => 'Sending...';

  @override
  String get messagesTyping => 'Typing...';

  @override
  String get messagesOnline => 'Online now';

  @override
  String get messagesOffline => 'Offline';

  @override
  String get messagesLastSeen => 'Last seen';

  @override
  String get messagesNow => 'Now';

  @override
  String get messagesMinutes => 'minutes';

  @override
  String get messagesHours => 'hours';

  @override
  String get messagesDays => 'days';

  @override
  String get messagesYesterday => 'Yesterday';

  @override
  String get messagesTypeMessage => 'Type a message...';

  @override
  String get messagesAttach => 'Attach';

  @override
  String get messagesSend => 'Send';

  @override
  String get messagesDelete => 'Delete conversation';

  @override
  String get messagesMute => 'Mute notifications';

  @override
  String get messagesBlock => 'Block user';

  @override
  String get messagesNewChat => 'New chat';

  @override
  String get messagesNoMessages => 'No messages';

  @override
  String get messagesStartChat => 'Start the conversation by sending a message';

  @override
  String get messagesAttachmentSoon => 'Attachments coming soon';

  @override
  String get authLogin => 'Login';

  @override
  String get authRegister => 'Register';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authPhoneNumber => 'Phone Number';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authRememberMe => 'Remember Me';

  @override
  String get authDontHaveAccount => 'Don\'t have an account?';

  @override
  String get authAlreadyHaveAccount => 'Already have an account?';

  @override
  String get authRegisterNow => 'Register Now';

  @override
  String get authLoginNow => 'Login';

  @override
  String get authSigningIn => 'Signing in...';

  @override
  String get authCreatingAccount => 'Creating account...';

  @override
  String get authWelcomeBack => 'Welcome Back!';

  @override
  String get authCreateYourAccount => 'Create Your Account';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authPasswordHint => 'Enter password';

  @override
  String get authFullNameHint => 'Full Name';

  @override
  String get authPhoneHint => '+966 123456789';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get authResetEmailSent => 'Reset link has been sent to your email';

  @override
  String get authBackToLogin => 'Back to Login';

  @override
  String get authVerifyOTP => 'Verify OTP';

  @override
  String get authEnterOTP => 'Enter verification code sent to';

  @override
  String get authVerify => 'Verify';

  @override
  String get authResendOTP => 'Resend Code';

  @override
  String get authOTPSent => 'Verification code sent';

  @override
  String get authInvalidOTP => 'Invalid verification code';

  @override
  String get authOTPExpired => 'Verification code expired';

  @override
  String get authAgreeTerms => 'I agree to Terms & Conditions';

  @override
  String get authMustAgreeTerms => 'You must agree to Terms & Conditions';

  @override
  String get authEmailRequired => 'Email is required';

  @override
  String get authPasswordRequired => 'Password is required';

  @override
  String get authFullNameRequired => 'Full name is required';

  @override
  String get authPhoneRequired => 'Phone number is required';

  @override
  String get authInvalidEmail => 'Invalid email address';

  @override
  String get authWeakPassword => 'Password is too weak';

  @override
  String get authPasswordsNotMatch => 'Passwords do not match';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authLoginSuccess => 'Login successful';

  @override
  String get authRegisterSuccess => 'Account created successfully';

  @override
  String get authLogout => 'Logout';

  @override
  String get authLogoutConfirm => 'Are you sure you want to logout?';

  @override
  String get authCancel => 'Cancel';

  @override
  String get authConfirm => 'Confirm';

  @override
  String get authInvalidPhoneFormat =>
      'Please enter a valid phone number with country code (e.g., +966...)';
}
