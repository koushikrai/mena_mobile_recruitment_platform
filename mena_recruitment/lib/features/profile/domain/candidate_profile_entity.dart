class CandidateProfile {
  final String id;
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String nationality;
  final String residentCountry;
  final String targetTitle;
  final int totalExperience;
  final int gccExperience;
  final int readinessScore;
  final bool isActivelyLooking;
  final List<String> preferredCountries;
  final double expectedSalary;
  final String expectedCurrency;
  final String noticePeriod;
  final String relocationStatus;
  final bool isGccVerified;

  const CandidateProfile({
    required this.id,
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.nationality,
    required this.residentCountry,
    required this.targetTitle,
    required this.totalExperience,
    required this.gccExperience,
    required this.readinessScore,
    required this.isActivelyLooking,
    required this.preferredCountries,
    required this.expectedSalary,
    required this.expectedCurrency,
    required this.noticePeriod,
    required this.relocationStatus,
    required this.isGccVerified,
  });

  CandidateProfile copyWith({
    String? id,
    String? uid,
    String? fullName,
    String? email,
    String? phone,
    String? nationality,
    String? residentCountry,
    String? targetTitle,
    int? totalExperience,
    int? gccExperience,
    int? readinessScore,
    bool? isActivelyLooking,
    List<String>? preferredCountries,
    double? expectedSalary,
    String? expectedCurrency,
    String? noticePeriod,
    String? relocationStatus,
    bool? isGccVerified,
  }) {
    return CandidateProfile(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationality: nationality ?? this.nationality,
      residentCountry: residentCountry ?? this.residentCountry,
      targetTitle: targetTitle ?? this.targetTitle,
      totalExperience: totalExperience ?? this.totalExperience,
      gccExperience: gccExperience ?? this.gccExperience,
      readinessScore: readinessScore ?? this.readinessScore,
      isActivelyLooking: isActivelyLooking ?? this.isActivelyLooking,
      preferredCountries: preferredCountries ?? this.preferredCountries,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      expectedCurrency: expectedCurrency ?? this.expectedCurrency,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      relocationStatus: relocationStatus ?? this.relocationStatus,
      isGccVerified: isGccVerified ?? this.isGccVerified,
    );
  }
}
