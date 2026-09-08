// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'وظائف عالمية من سهانا';

  @override
  String get navJobs => 'الوظائف';

  @override
  String get navApplications => 'طلباتي';

  @override
  String get navVault => 'المستندات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get searchHint => 'ابحث عن وظائف، مهارات، شركات...';

  @override
  String get filterVisaSponsored => 'تأشيرة مكفولة';

  @override
  String get filterTransferableIqama => 'إقامة قابلة للتحويل';

  @override
  String get filterImmediateHiring => 'توظيف فوري';

  @override
  String get filterHousingIncluded => 'سكن متوفر';

  @override
  String get applyNow => 'تقدم الآن';

  @override
  String get quickApply => 'تقديم سريع بالسيرة الذكية';

  @override
  String get saveProfile => 'حفظ وإكمال الملف';

  @override
  String get uploadCV => 'رفع السيرة الذاتية';

  @override
  String get parseAndContinue => 'تحليل ومتابعة المراجعة';

  @override
  String get taxFree => 'معفى من الضرائب';

  @override
  String get perMonth => '/ شهر';

  @override
  String get perYear => '/ سنة';

  @override
  String closingIn(int days) {
    return 'ينتهي خلال $days أيام';
  }

  @override
  String activeApplications(int count) {
    return '$count نشطة';
  }

  @override
  String profileReadiness(int percent) {
    return '$percent% جاهز للانتقال إلى دول الخليج';
  }

  @override
  String get stageApplied => 'تم التقديم وتحليل السيرة';

  @override
  String get stageScreening => 'فحص المرشحين';

  @override
  String get stageInterview => 'المقابلة التقنية';

  @override
  String get stageOffer => 'عرض العمل';

  @override
  String get stageVisa => 'تأشيرة وانتقال الخليج';

  @override
  String get stageFlight => 'الرحلة والتأهيل';

  @override
  String get verifiedEmployer => 'جهة عمل موثقة';

  @override
  String get visaProvided => 'تصريح عمل متوفر';

  @override
  String get housingAllowance => 'بدل سكن';

  @override
  String get fullySponsored => 'تأشيرة عمل مكفولة بالكامل';

  @override
  String get passportValid => 'صالح لإصدار التأشيرة';

  @override
  String get passportExpiring => 'ينتهي خلال أقل من 6 أشهر - يلزم التجديد';

  @override
  String get confirmSaveVault => 'تأكيد وحفظ في الخزنة';

  @override
  String get retakeScan => 'إعادة المسح';

  @override
  String get uploadDocument => 'رفع مستند إلى الخزنة';

  @override
  String get addCertification => 'إضافة شهادة أو رخصة';

  @override
  String get updatePassport => 'تحديث بيانات جواز السفر';

  @override
  String get activelySeekingGcc => 'أبحث بنشاط عن انتقال للخليج';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsSecurity => 'الأمان';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsPrivacy => 'الخصوصية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get countryUAE => 'الإمارات';

  @override
  String get countryKSA => 'السعودية';

  @override
  String get countryQatar => 'قطر';

  @override
  String get countryKuwait => 'الكويت';

  @override
  String get countryOman => 'عُمان';

  @override
  String get countryBahrain => 'البحرين';
}
