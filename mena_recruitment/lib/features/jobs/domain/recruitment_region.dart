/// Recruitment regions supported across the platform.
enum RecruitmentRegion {
  gcc(
    id: 'gcc',
    name: 'GCC / Middle East',
    shortLabel: 'GCC',
    flag: '🇸🇦',
    subtitle: 'Saudi Arabia, UAE, Qatar, Kuwait, Oman, Bahrain',
    description: 'Tax-free compensation, sponsored Iqamas, and mega giga-projects.',
    countryCodes: ['sau', 'ksa', 'uae', 'are', 'qat', 'kwt', 'omn', 'bhr'],
  ),
  apac(
    id: 'apac',
    name: 'APAC (Asia-Pacific)',
    shortLabel: 'APAC',
    flag: '🌏',
    subtitle: 'Singapore, Malaysia, Japan, India, South Korea',
    description: 'LNG terminals, subsea pipelines, smart infrastructure & offshore energy.',
    countryCodes: ['sgp', 'mys', 'jpn', 'ind', 'kor', 'vnm'],
  ),
  emea(
    id: 'emea',
    name: 'EMEA (Europe & Africa)',
    shortLabel: 'EMEA',
    flag: '🌍',
    subtitle: 'United Kingdom, Germany, Netherlands, South Africa',
    description: 'North Sea offshore wind, high-tech engineering, industrial refining & renewables.',
    countryCodes: ['gbr', 'uk', 'deu', 'fra', 'nld', 'zaf', 'che'],
  ),
  usa(
    id: 'usa',
    name: 'North America / USA',
    shortLabel: 'USA',
    flag: '🇺🇸',
    subtitle: 'United States, Canada',
    description: 'Deepwater drilling, refinery turnarounds, clean tech & heavy energy infrastructure.',
    countryCodes: ['usa', 'can', 'mex'],
  ),
  oceania(
    id: 'oceania',
    name: 'Oceania',
    shortLabel: 'Oceania',
    flag: '🇦🇺',
    subtitle: 'Australia, New Zealand, Papua New Guinea',
    description: 'Iron ore mining, ports & maritime logistics, trans-Tasman civil mega-projects.',
    countryCodes: ['aus', 'nzl', 'png', 'fji'],
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
