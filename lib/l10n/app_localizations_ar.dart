// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق التصميم';

  @override
  String get clickHere => 'اضغط هنا';

  @override
  String get addStory => 'أضف ستوري';

  @override
  String get search => 'البحث عن الخدمة...';

  @override
  String get live => 'مباشر';

  @override
  String get restContent => 'المحتوى سيأتي هنا';

  @override
  String get ahmadAlShehri => 'أحمد الشمري';

  @override
  String get aminaAlHajri => 'أميمة الهاجري';

  @override
  String get mohammedAli => 'محمد علي';

  @override
  String get sarahAhmed => 'سارة أحمد';

  @override
  String get startDesignProject => 'إبدأ مشروع التصميم الآن';

  @override
  String get createAIImages => 'اصنع صور عبر الذكاء الاصطناعي';

  @override
  String get architecturalDesign => 'تصميم معماري';

  @override
  String get socialMedia => 'سوشل ميديا';

  @override
  String get interiorDecor => 'ديكور داخلي';

  @override
  String get fashionDesign => 'تصميم أزياء';

  @override
  String get hobbies => 'هوايات';

  @override
  String get projectsGallery => 'معرض المشاريع';

  @override
  String get viewAll => 'شاهد الكل';

  @override
  String get addStoryComingSoon => 'إضافة ستوري قريباً';

  @override
  String get storyHasNoContent => 'هذه القصة لا تحتوي على محتوى';

  @override
  String get failedToLoadImage => 'فشل تحميل الصورة';

  @override
  String get videoNotImplemented => 'تشغيل الفيديو غير متاح حالياً';

  @override
  String get videoFileNotExist => 'ملف الفيديو غير موجود';

  @override
  String videoFileTooLarge(String size) {
    return 'حجم الفيديو كبير جداً ($size ميجابايت). الحد الأقصى 10 ميجابايت';
  }

  @override
  String get videoTooShort => 'الفيديو قصير جداً. الحد الأدنى ثانية واحدة';

  @override
  String videoTooLong(int duration) {
    return 'الفيديو طويل جداً ($duration ثانية). الحد الأقصى 60 ثانية';
  }

  @override
  String get videoReadError => 'فشل في قراءة ملف الفيديو. تأكد من صيغة الفيديو';

  @override
  String get videoValidationError => 'حدث خطأ أثناء التحقق من الفيديو';

  @override
  String get videoRequirementsTitle => 'متطلبات الفيديو:';

  @override
  String get videoRequirementDuration => 'المدة: من 1 إلى 60 ثانية';

  @override
  String get videoRequirementSize => 'الحجم: أقل من 10 ميجابايت';

  @override
  String get videoRequirementFormat => 'الصيغة: MP4 (موصى به)';

  @override
  String get videoRequirementResolution => 'الدقة: 720p أو 1080p';

  @override
  String get videoRequirementOrientation => 'الاتجاه: عمودي (9:16)';

  @override
  String get addStoryTitle => 'إضافة ستوري';

  @override
  String get publish => 'نشر';

  @override
  String get error => 'خطأ';

  @override
  String get ok => 'حسناً';

  @override
  String get videoPickFailed => 'فشل في اختيار الفيديو';

  @override
  String get imagePickFailed => 'فشل في اختيار الصورة';

  @override
  String get videoRecordFailed => 'فشل في تسجيل الفيديو';

  @override
  String get storyUploadingSoon => 'سيتم إضافة ستوري قريباً';

  @override
  String get recordVideo => 'تسجيل فيديو';

  @override
  String get selectVideo => 'اختيار فيديو';

  @override
  String get selectImage => 'اختيار صورة';

  @override
  String get selectImageOrVideo => 'اختر صورة أو فيديو';

  @override
  String get videoRequirementsSummary =>
      'الفيديو: من 1 إلى 60 ثانية، أقل من 10 ميجابايت';

  @override
  String get videoValidating => 'جاري التحقق من الفيديو...';

  @override
  String videoSuitable(String duration) {
    return 'الفيديو مناسب ($duration)';
  }

  @override
  String get videoSelected => 'فيديو محدد';

  @override
  String get menuHome => 'الرئيسية';

  @override
  String get menuProfile => 'الملف الشخصي';

  @override
  String get menuFavorites => 'المفضلة';

  @override
  String get menuSaved => 'المحفوظات';

  @override
  String get menuProjects => 'المشاريع';

  @override
  String get menuSettings => 'الإعدادات';

  @override
  String get menuHelp => 'المساعدة';

  @override
  String get menuAbout => 'حول';

  @override
  String get menuLogout => 'تسجيل الخروج';

  @override
  String get menuWelcome => 'مرحباً';

  @override
  String get menuUserName => 'المستخدم';

  @override
  String get menuLogoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileProjects => 'المشاريع';

  @override
  String get profileFollowers => 'المتابعون';

  @override
  String get profileFollowing => 'المتابَعون';

  @override
  String get profileInformation => 'المعلومات الشخصية';

  @override
  String get profileEmail => 'البريد الإلكتروني';

  @override
  String get profilePhone => 'رقم الهاتف';

  @override
  String get profileMemberSince => 'عضو منذ';

  @override
  String get profileActions => 'الإجراءات';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileEditProfileDesc => 'تحديث معلوماتك';

  @override
  String get profileChangePassword => 'تغيير كلمة المرور';

  @override
  String get profileChangePasswordDesc => 'تحديث الأمان الخاص بك';

  @override
  String get profileLoadError => 'فشل تحميل الملف الشخصي';

  @override
  String get profileRetry => 'إعادة المحاولة';

  @override
  String get profileSettingsComingSoon => 'الإعدادات قريباً';

  @override
  String get profileEditComingSoon => 'تعديل الملف الشخصي قريباً';

  @override
  String get profilePasswordComingSoon => 'تغيير كلمة المرور قريباً';
}
