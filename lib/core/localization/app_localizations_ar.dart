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

  @override
  String get messages => 'الرسائل';

  @override
  String get messagesEmpty => 'لا توجد محادثات';

  @override
  String get messagesEmptyDesc => 'ابدأ محادثة جديدة';

  @override
  String get messagesNoResults => 'لا توجد نتائج';

  @override
  String get messagesSending => 'جاري الإرسال...';

  @override
  String get messagesTyping => 'يكتب...';

  @override
  String get messagesOnline => 'متصل الآن';

  @override
  String get messagesOffline => 'غير متصل';

  @override
  String get messagesLastSeen => 'آخر ظهور';

  @override
  String get messagesNow => 'الآن';

  @override
  String get messagesMinutes => 'دقيقة';

  @override
  String get messagesHours => 'ساعة';

  @override
  String get messagesDays => 'يوم';

  @override
  String get messagesYesterday => 'أمس';

  @override
  String get messagesTypeMessage => 'اكتب رسالة...';

  @override
  String get messagesAttach => 'إرفاق';

  @override
  String get messagesSend => 'إرسال';

  @override
  String get messagesDelete => 'حذف المحادثة';

  @override
  String get messagesMute => 'كتم الإشعارات';

  @override
  String get messagesBlock => 'حظر المستخدم';

  @override
  String get messagesNewChat => 'محادثة جديدة';

  @override
  String get messagesNoMessages => 'لا توجد رسائل';

  @override
  String get messagesStartChat => 'ابدأ المحادثة بإرسال رسالة';

  @override
  String get messagesAttachmentSoon => 'إرفاق الملفات قريباً';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authRegister => 'إنشاء حساب';

  @override
  String get authEmail => 'البريد الإلكتروني';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get authFullName => 'الاسم الكامل';

  @override
  String get authPhoneNumber => 'رقم الهاتف';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authRememberMe => 'تذكرني';

  @override
  String get authDontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get authAlreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authRegisterNow => 'سجل الآن';

  @override
  String get authLoginNow => 'سجل دخول';

  @override
  String get authSigningIn => 'جاري تسجيل الدخول...';

  @override
  String get authCreatingAccount => 'جاري إنشاء الحساب...';

  @override
  String get authWelcomeBack => 'مرحباً بعودتك!';

  @override
  String get authCreateYourAccount => 'أنشئ حسابك';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authPasswordHint => 'أدخل كلمة المرور';

  @override
  String get authFullNameHint => 'الاسم الكامل';

  @override
  String get authPhoneHint => '+966 123456789';

  @override
  String get authResetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get authSendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get authResetEmailSent =>
      'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني';

  @override
  String get authBackToLogin => 'العودة لتسجيل الدخول';

  @override
  String get authVerifyOTP => 'تحقق من رمز OTP';

  @override
  String get authEnterOTP => 'أدخل رمز التحقق المرسل إلى';

  @override
  String get authVerify => 'تحقق';

  @override
  String get authResendOTP => 'إعادة إرسال الرمز';

  @override
  String get authOTPSent => 'تم إرسال رمز التحقق';

  @override
  String get authInvalidOTP => 'رمز التحقق غير صحيح';

  @override
  String get authOTPExpired => 'انتهت صلاحية رمز التحقق';

  @override
  String get authAgreeTerms => 'أوافق على الشروط والأحكام';

  @override
  String get authMustAgreeTerms => 'يجب الموافقة على الشروط والأحكام';

  @override
  String get authEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get authPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get authFullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get authPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get authInvalidEmail => 'البريد الإلكتروني غير صحيح';

  @override
  String get authWeakPassword => 'كلمة المرور ضعيفة جداً';

  @override
  String get authPasswordsNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get authPasswordMinLength =>
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get authLoginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get authRegisterSuccess => 'تم إنشاء الحساب بنجاح';

  @override
  String get authLogout => 'تسجيل الخروج';

  @override
  String get authLogoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get authCancel => 'إلغاء';

  @override
  String get authConfirm => 'تأكيد';

  @override
  String get authInvalidPhoneFormat =>
      'الرجاء إدخال رقم هاتف صحيح مع رمز الدولة (مثال: +966...)';

  @override
  String get authLogoutSuccess => 'تم تسجيل الخروج بنجاح';

  @override
  String get authLogoutFailed => 'فشل تسجيل الخروج';
}
