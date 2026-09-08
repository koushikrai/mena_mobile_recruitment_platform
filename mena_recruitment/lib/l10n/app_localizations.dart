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
  /// **'Global Jobs By Suhana'**
  String get appTitle;

  /// No description provided for @navJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get navJobs;

  /// No description provided for @navApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get navApplications;

  /// No description provided for @navVault.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get navVault;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search jobs, skills, companies...'**
  String get searchHint;

  /// No description provided for @filterVisaSponsored.
  ///
  /// In en, this message translates to:
  /// **'Visa Sponsored'**
  String get filterVisaSponsored;

  /// No description provided for @filterTransferableIqama.
  ///
  /// In en, this message translates to:
  /// **'Transferable Iqama'**
  String get filterTransferableIqama;

  /// No description provided for @filterImmediateHiring.
  ///
  /// In en, this message translates to:
  /// **'Immediate Hiring'**
  String get filterImmediateHiring;

  /// No description provided for @filterHousingIncluded.
  ///
  /// In en, this message translates to:
  /// **'Housing Included'**
  String get filterHousingIncluded;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @quickApply.
  ///
  /// In en, this message translates to:
  /// **'Quick Apply with Smart CV'**
  String get quickApply;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save & Complete Profile'**
  String get saveProfile;

  /// No description provided for @uploadCV.
  ///
  /// In en, this message translates to:
  /// **'Upload Resume'**
  String get uploadCV;

  /// No description provided for @parseAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Parse & Continue to Review'**
  String get parseAndContinue;

  /// No description provided for @taxFree.
  ///
  /// In en, this message translates to:
  /// **'Tax-Free'**
  String get taxFree;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/ mo'**
  String get perMonth;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'/ yr'**
  String get perYear;

  /// No description provided for @closingIn.
  ///
  /// In en, this message translates to:
  /// **'Closing in {days} days'**
  String closingIn(int days);

  /// No description provided for @activeApplications.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String activeApplications(int count);

  /// No description provided for @profileReadiness.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Ready for GCC Relocation'**
  String profileReadiness(int percent);

  /// No description provided for @stageApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied & CV Parsed'**
  String get stageApplied;

  /// No description provided for @stageScreening.
  ///
  /// In en, this message translates to:
  /// **'Recruiter Screening'**
  String get stageScreening;

  /// No description provided for @stageInterview.
  ///
  /// In en, this message translates to:
  /// **'Technical/Client Interview'**
  String get stageInterview;

  /// No description provided for @stageOffer.
  ///
  /// In en, this message translates to:
  /// **'Job Offer Issued'**
  String get stageOffer;

  /// No description provided for @stageVisa.
  ///
  /// In en, this message translates to:
  /// **'GCC Visa & Relocation'**
  String get stageVisa;

  /// No description provided for @stageFlight.
  ///
  /// In en, this message translates to:
  /// **'Flight & Onboarding'**
  String get stageFlight;

  /// No description provided for @verifiedEmployer.
  ///
  /// In en, this message translates to:
  /// **'Verified Employer'**
  String get verifiedEmployer;

  /// No description provided for @visaProvided.
  ///
  /// In en, this message translates to:
  /// **'Work Permit Provided'**
  String get visaProvided;

  /// No description provided for @housingAllowance.
  ///
  /// In en, this message translates to:
  /// **'Housing Allowance'**
  String get housingAllowance;

  /// No description provided for @fullySponsored.
  ///
  /// In en, this message translates to:
  /// **'Fully Sponsored Employment Visa'**
  String get fullySponsored;

  /// No description provided for @passportValid.
  ///
  /// In en, this message translates to:
  /// **'Valid for Visa Issuance'**
  String get passportValid;

  /// No description provided for @passportExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expires in < 6 Months - Renewal Required'**
  String get passportExpiring;

  /// No description provided for @confirmSaveVault.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Save to Vault'**
  String get confirmSaveVault;

  /// No description provided for @retakeScan.
  ///
  /// In en, this message translates to:
  /// **'Retake Scan'**
  String get retakeScan;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document to Vault'**
  String get uploadDocument;

  /// No description provided for @addCertification.
  ///
  /// In en, this message translates to:
  /// **'Add Certification or License'**
  String get addCertification;

  /// No description provided for @updatePassport.
  ///
  /// In en, this message translates to:
  /// **'Update Passport Details'**
  String get updatePassport;

  /// No description provided for @activelySeekingGcc.
  ///
  /// In en, this message translates to:
  /// **'Actively Seeking GCC Relocation'**
  String get activelySeekingGcc;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @countryUAE.
  ///
  /// In en, this message translates to:
  /// **'UAE'**
  String get countryUAE;

  /// No description provided for @countryKSA.
  ///
  /// In en, this message translates to:
  /// **'KSA'**
  String get countryKSA;

  /// No description provided for @countryQatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get countryQatar;

  /// No description provided for @countryKuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get countryKuwait;

  /// No description provided for @countryOman.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get countryOman;

  /// No description provided for @countryBahrain.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get countryBahrain;
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
