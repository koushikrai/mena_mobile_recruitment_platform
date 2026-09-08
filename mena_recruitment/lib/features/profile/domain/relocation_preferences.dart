class RelocationPreferences {
  final List<String> preferredCountries;
  final double expectedSalary;
  final String currency;
  final String noticePeriod;
  final String familyStatus;

  const RelocationPreferences({
    required this.preferredCountries,
    required this.expectedSalary,
    required this.currency,
    required this.noticePeriod,
    required this.familyStatus,
  });

  RelocationPreferences copyWith({
    List<String>? preferredCountries,
    double? expectedSalary,
    String? currency,
    String? noticePeriod,
    String? familyStatus,
  }) {
    return RelocationPreferences(
      preferredCountries: preferredCountries ?? this.preferredCountries,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      currency: currency ?? this.currency,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      familyStatus: familyStatus ?? this.familyStatus,
    );
  }
}
