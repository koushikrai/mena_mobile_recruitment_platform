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

  static const empty = CandidateProfile(
    id: '',
    uid: '',
    fullName: '',
    email: '',
    phone: '',
    nationality: '',
    residentCountry: '',
    targetTitle: '',
    totalExperience: 0,
    gccExperience: 0,
    readinessScore: 0,
    isActivelyLooking: true,
    preferredCountries: [],
    expectedSalary: 0.0,
    expectedCurrency: 'SAR',
    noticePeriod: '',
    relocationStatus: '',
    isGccVerified: false,
  );

  factory CandidateProfile.fromJson(Map<String, dynamic> json) {
    final rawId = json['id']?.toString() ?? '';
    final uidSuffix = rawId.length >= 5 ? rawId.substring(0, 5) : '001';

    return CandidateProfile(
      id: rawId,
      uid: json['uid'] as String? ?? (rawId.isNotEmpty ? 'UID-$uidSuffix' : ''),
      fullName: json['full_name'] as String? ?? json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? json['phone_number'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      residentCountry: json['current_resident_country'] as String? ?? json['residentCountry'] as String? ?? '',
      targetTitle: json['target_job_title'] as String? ?? json['targetTitle'] as String? ?? '',
      totalExperience: (json['total_experience_years'] as num? ?? json['totalExperience'] as num?)?.round() ?? 0,
      gccExperience: (json['gcc_experience_years'] as num? ?? json['gccExperience'] as num?)?.round() ?? 0,
      readinessScore: json['relocation_readiness_score'] as int? ?? json['readinessScore'] as int? ?? 0,
      isActivelyLooking: json['is_actively_looking'] as bool? ?? json['isActivelyLooking'] as bool? ?? true,
      preferredCountries: (json['preferredCountries'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
      expectedSalary: (json['expected_salary_min'] as num? ?? json['expectedSalary'] as num?)?.toDouble() ?? 0.0,
      expectedCurrency: json['expected_salary_currency'] as String? ?? json['expectedCurrency'] as String? ?? 'SAR',
      noticePeriod: json['notice_period_days'] != null
          ? '${json['notice_period_days']} Days'
          : json['noticePeriod'] as String? ?? '',
      relocationStatus: json['relocation_status'] as String? ?? json['relocationStatus'] as String? ?? '',
      isGccVerified: json['is_gcc_verified'] as bool? ?? json['isGccVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target_job_title': targetTitle,
      'current_resident_country': residentCountry,
      'nationality': nationality,
      'total_experience_years': totalExperience.toDouble(),
      'gcc_experience_years': gccExperience.toDouble(),
      'is_actively_looking': isActivelyLooking,
      'relocation_status': relocationStatus,
      'expected_salary_min': expectedSalary,
      'expected_salary_currency': expectedCurrency,
    };
  }
}
