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
}
