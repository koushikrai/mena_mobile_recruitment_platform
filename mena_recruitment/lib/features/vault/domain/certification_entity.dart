enum CertificationCategory {
  engineeringSCE,
  safetyNeboshOsha,
  driving,
  medicalDhaMoh,
  other
}

class Certification {
  final String id;
  final String title;
  final CertificationCategory category;
  final String issuingAuthority;
  final String credentialId;
  final DateTime validFrom;
  final DateTime? validUntil;
  final bool isVerified;
  final String? documentUrl;

  const Certification({
    required this.id,
    required this.title,
    required this.category,
    required this.issuingAuthority,
    required this.credentialId,
    required this.validFrom,
    this.validUntil,
    this.isVerified = false,
    this.documentUrl,
  });

  Certification copyWith({
    String? id,
    String? title,
    CertificationCategory? category,
    String? issuingAuthority,
    String? credentialId,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isVerified,
    String? documentUrl,
  }) {
    return Certification(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      issuingAuthority: issuingAuthority ?? this.issuingAuthority,
      credentialId: credentialId ?? this.credentialId,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isVerified: isVerified ?? this.isVerified,
      documentUrl: documentUrl ?? this.documentUrl,
    );
  }
}
