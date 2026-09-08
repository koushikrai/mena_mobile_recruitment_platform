class GccCountry {
  final String code;
  final String name;
  final String flagAssetPath;
  final String phonePrefix;
  final String currency;

  const GccCountry({
    required this.code,
    required this.name,
    required this.flagAssetPath,
    required this.phonePrefix,
    required this.currency,
  });
}

class AppConstants {
  AppConstants._();

  static const String appName = 'Global Jobs By Suhana';

  static const List<GccCountry> gccCountries = [
    GccCountry(code: 'AE', name: 'United Arab Emirates', flagAssetPath: 'assets/flags/ae.png', phonePrefix: '+971', currency: 'AED'),
    GccCountry(code: 'SA', name: 'Saudi Arabia', flagAssetPath: 'assets/flags/sa.png', phonePrefix: '+966', currency: 'SAR'),
    GccCountry(code: 'QA', name: 'Qatar', flagAssetPath: 'assets/flags/qa.png', phonePrefix: '+974', currency: 'QAR'),
    GccCountry(code: 'KW', name: 'Kuwait', flagAssetPath: 'assets/flags/kw.png', phonePrefix: '+965', currency: 'KWD'),
    GccCountry(code: 'OM', name: 'Oman', flagAssetPath: 'assets/flags/om.png', phonePrefix: '+968', currency: 'OMR'),
    GccCountry(code: 'BH', name: 'Bahrain', flagAssetPath: 'assets/flags/bh.png', phonePrefix: '+973', currency: 'BHD'),
  ];

  static const List<String> visaStatusOptions = [
    'Visit Visa',
    'Employment Visa',
    'Cancelled Visa',
    'Own Visa / Freelance',
    'Outside GCC',
  ];

  static const List<String> accommodationOptions = [
    'Company Provided',
    'Allowance Provided',
    'Not Provided',
  ];

  static const List<String> noticePeriodOptions = [
    'Immediately Available',
    '15 Days',
    '1 Month',
    '2 Months',
    '3 Months or more',
  ];
}
