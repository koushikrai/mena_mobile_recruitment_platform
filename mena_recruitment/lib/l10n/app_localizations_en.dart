// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Global Jobs By Suhana';

  @override
  String get navJobs => 'Jobs';

  @override
  String get navApplications => 'Applications';

  @override
  String get navVault => 'Vault';

  @override
  String get navProfile => 'Profile';

  @override
  String get searchHint => 'Search jobs, skills, companies...';

  @override
  String get filterVisaSponsored => 'Visa Sponsored';

  @override
  String get filterTransferableIqama => 'Transferable Iqama';

  @override
  String get filterImmediateHiring => 'Immediate Hiring';

  @override
  String get filterHousingIncluded => 'Housing Included';

  @override
  String get applyNow => 'Apply Now';

  @override
  String get quickApply => 'Quick Apply with Smart CV';

  @override
  String get saveProfile => 'Save & Complete Profile';

  @override
  String get uploadCV => 'Upload Resume';

  @override
  String get parseAndContinue => 'Parse & Continue to Review';

  @override
  String get taxFree => 'Tax-Free';

  @override
  String get perMonth => '/ mo';

  @override
  String get perYear => '/ yr';

  @override
  String closingIn(int days) {
    return 'Closing in $days days';
  }

  @override
  String activeApplications(int count) {
    return '$count Active';
  }

  @override
  String profileReadiness(int percent) {
    return '$percent% Ready for GCC Relocation';
  }

  @override
  String get stageApplied => 'Applied & CV Parsed';

  @override
  String get stageScreening => 'Recruiter Screening';

  @override
  String get stageInterview => 'Technical/Client Interview';

  @override
  String get stageOffer => 'Job Offer Issued';

  @override
  String get stageVisa => 'GCC Visa & Relocation';

  @override
  String get stageFlight => 'Flight & Onboarding';

  @override
  String get verifiedEmployer => 'Verified Employer';

  @override
  String get visaProvided => 'Work Permit Provided';

  @override
  String get housingAllowance => 'Housing Allowance';

  @override
  String get fullySponsored => 'Fully Sponsored Employment Visa';

  @override
  String get passportValid => 'Valid for Visa Issuance';

  @override
  String get passportExpiring => 'Expires in < 6 Months - Renewal Required';

  @override
  String get confirmSaveVault => 'Confirm & Save to Vault';

  @override
  String get retakeScan => 'Retake Scan';

  @override
  String get uploadDocument => 'Upload Document to Vault';

  @override
  String get addCertification => 'Add Certification or License';

  @override
  String get updatePassport => 'Update Passport Details';

  @override
  String get activelySeekingGcc => 'Actively Seeking GCC Relocation';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get countryUAE => 'UAE';

  @override
  String get countryKSA => 'KSA';

  @override
  String get countryQatar => 'Qatar';

  @override
  String get countryKuwait => 'Kuwait';

  @override
  String get countryOman => 'Oman';

  @override
  String get countryBahrain => 'Bahrain';
}
