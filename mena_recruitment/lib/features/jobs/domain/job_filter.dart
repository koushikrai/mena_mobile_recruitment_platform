class JobFilter {
  final String? searchQuery;
  final List<String> selectedCountries;
  final String? region;
  final bool? visaSponsored;
  final bool? transferableIqama;
  final bool? immediateHiring;
  final bool? housingIncluded;
  final double? salaryMin;
  final double? salaryMax;
  final List<String> selectedSkills;

  const JobFilter({
    this.searchQuery,
    this.selectedCountries = const [],
    this.region = 'gcc',
    this.visaSponsored,
    this.transferableIqama,
    this.immediateHiring,
    this.housingIncluded,
    this.salaryMin,
    this.salaryMax,
    this.selectedSkills = const [],
  });

  bool get hasActiveFilters => activeFilterCount > 0;

  int get activeFilterCount {
    int count = 0;
    if (searchQuery != null && searchQuery!.isNotEmpty) count++;
    count += selectedCountries.length;
    if (visaSponsored == true) count++;
    if (transferableIqama == true) count++;
    if (immediateHiring == true) count++;
    if (housingIncluded == true) count++;
    if (salaryMin != null) count++;
    if (salaryMax != null) count++;
    count += selectedSkills.length;
    return count;
  }

  JobFilter copyWith({
    String? searchQuery,
    List<String>? selectedCountries,
    String? region,
    bool? visaSponsored,
    bool? transferableIqama,
    bool? immediateHiring,
    bool? housingIncluded,
    double? salaryMin,
    double? salaryMax,
    List<String>? selectedSkills,
  }) {
    return JobFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCountries: selectedCountries ?? this.selectedCountries,
      region: region ?? this.region,
      visaSponsored: visaSponsored ?? this.visaSponsored,
      transferableIqama: transferableIqama ?? this.transferableIqama,
      immediateHiring: immediateHiring ?? this.immediateHiring,
      housingIncluded: housingIncluded ?? this.housingIncluded,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      selectedSkills: selectedSkills ?? this.selectedSkills,
    );
  }
}
