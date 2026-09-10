/// Recruitment regions supported across the platform.
enum RecruitmentRegion {
  gcc(
    id: 'gcc',
    name: 'GCC / Middle East',
    shortLabel: 'GCC',
    flag: '🇸🇦',
    subtitle: 'Saudi Arabia, UAE, Qatar, Kuwait, Oman, Bahrain',
    description: 'Tax-free compensation, sponsored Iqamas, and mega giga-projects.',
    countryCodes: [
      'sau', 'ksa', 'saudi arabia', 'saudi',
      'uae', 'are', 'united arab emirates', 'dubai', 'abu dhabi',
      'qat', 'qatar', 'doha',
      'kwt', 'kuwait',
      'omn', 'oman', 'muscat',
      'bhr', 'bahrain', 'manama',
    ],
  ),
  apac(
    id: 'apac',
    name: 'APAC (Asia-Pacific)',
    shortLabel: 'APAC',
    flag: '🌏',
    subtitle: 'Singapore, Malaysia, Japan, India, South Korea',
    description: 'LNG terminals, subsea pipelines, smart infrastructure & offshore energy.',
    countryCodes: [
      'sgp', 'singapore',
      'mys', 'malaysia',
      'jpn', 'japan',
      'ind', 'india',
      'kor', 'south korea', 'korea',
      'vnm', 'vietnam',
      'idn', 'indonesia',
      'phl', 'philippines',
      'tha', 'thailand',
      'twn', 'taiwan',
    ],
  ),
  emea(
    id: 'emea',
    name: 'EMEA (Europe & Africa)',
    shortLabel: 'EMEA',
    flag: '🌍',
    subtitle: 'United Kingdom, Germany, Netherlands, South Africa',
    description: 'North Sea offshore wind, high-tech engineering, industrial refining & renewables.',
    countryCodes: [
      'gbr', 'uk', 'united kingdom', 'great britain', 'england', 'scotland',
      'deu', 'germany',
      'fra', 'france',
      'nld', 'netherlands', 'holland',
      'zaf', 'south africa',
      'che', 'switzerland',
      'nor', 'norway',
      'irl', 'ireland',
      'esp', 'spain',
      'ita', 'italy',
      'swe', 'sweden',
      'dnk', 'denmark',
    ],
  ),
  usa(
    id: 'usa',
    name: 'North America / USA',
    shortLabel: 'USA',
    flag: '🇺🇸',
    subtitle: 'United States, Canada',
    description: 'Deepwater drilling, refinery turnarounds, clean tech & heavy energy infrastructure.',
    countryCodes: [
      'usa', 'us', 'united states', 'united states of america',
      'can', 'canada',
      'mex', 'mexico',
    ],
  ),
  oceania(
    id: 'oceania',
    name: 'Oceania',
    shortLabel: 'Oceania',
    flag: '🇦🇺',
    subtitle: 'Australia, New Zealand, Papua New Guinea',
    description: 'Iron ore mining, ports & maritime logistics, trans-Tasman civil mega-projects.',
    countryCodes: [
      'aus', 'australia',
      'nzl', 'new zealand',
      'png', 'papua new guinea',
      'fji', 'fiji',
    ],
  ),
  global(
    id: 'global',
    name: 'Global / All Regions',
    shortLabel: 'Global',
    flag: '🌐',
    subtitle: 'Worldwide International Opportunities',
    description: 'Browse active vacancies across all global corridors simultaneously.',
    countryCodes: [],
  );

  final String id;
  final String name;
  final String shortLabel;
  final String flag;
  final String subtitle;
  final String description;
  final List<String> countryCodes;

  const RecruitmentRegion({
    required this.id,
    required this.name,
    required this.shortLabel,
    required this.flag,
    required this.subtitle,
    required this.description,
    required this.countryCodes,
  });

  /// Checks if a job matches this region either via its region identifier or its country code.
  bool matchesJob(String jobRegion, String countryCode) {
    if (this == RecruitmentRegion.global) return true;
    final r = jobRegion.toLowerCase().trim();
    if (r == id.toLowerCase()) return true;
    final c = countryCode.toLowerCase().trim();
    return countryCodes.contains(c);
  }

  static RecruitmentRegion fromId(String? id) {
    if (id == null) return RecruitmentRegion.gcc;
    return RecruitmentRegion.values.firstWhere(
      (r) => r.id.toLowerCase() == id.toLowerCase(),
      orElse: () => RecruitmentRegion.gcc,
    );
  }

  static String inferRegionFromCountry(String countryCode) {
    final code = countryCode.toLowerCase().trim();
    for (final region in RecruitmentRegion.values) {
      if (region.countryCodes.contains(code)) {
        return region.id;
      }
    }
    return 'gcc';
  }
}
