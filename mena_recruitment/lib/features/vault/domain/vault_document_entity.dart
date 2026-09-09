enum DocumentCategory {
  passport,
  visa,
  educationAttestation,
  medicalGamca,
  policeClearance,
  tradeLicense
}

class VaultDocument {
  final String id;
  final DocumentCategory category;
  final String title;
  final String documentNumber;
  final String issuingCountry;
  final DateTime? expiryDate;
  final bool isValidForGccVisa;
  final bool isVerified;
  final String? fileUrl;
  final bool reminder6Months;
  final bool reminder3Months;

  const VaultDocument({
    required this.id,
    required this.category,
    required this.title,
    required this.documentNumber,
    required this.issuingCountry,
    this.expiryDate,
    this.isValidForGccVisa = false,
    this.isVerified = false,
    this.fileUrl,
    this.reminder6Months = false,
    this.reminder3Months = false,
  });

  VaultDocument copyWith({
    String? id,
    DocumentCategory? category,
    String? title,
    String? documentNumber,
    String? issuingCountry,
    DateTime? expiryDate,
    bool? isValidForGccVisa,
    bool? isVerified,
    String? fileUrl,
    bool? reminder6Months,
    bool? reminder3Months,
  }) {
    return VaultDocument(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      documentNumber: documentNumber ?? this.documentNumber,
      issuingCountry: issuingCountry ?? this.issuingCountry,
      expiryDate: expiryDate ?? this.expiryDate,
      isValidForGccVisa: isValidForGccVisa ?? this.isValidForGccVisa,
      isVerified: isVerified ?? this.isVerified,
      fileUrl: fileUrl ?? this.fileUrl,
      reminder6Months: reminder6Months ?? this.reminder6Months,
      reminder3Months: reminder3Months ?? this.reminder3Months,
    );
  }

  factory VaultDocument.fromJson(Map<String, dynamic> json) {
    final docType = (json['document_type'] as String? ?? json['category'] as String? ?? 'passport').toLowerCase();
    final DocumentCategory category;
    if (docType == 'passport') {
      category = DocumentCategory.passport;
    } else if (docType.contains('cv') || docType.contains('resume')) {
      category = DocumentCategory.tradeLicense;
    } else if (docType.contains('visa')) {
      category = DocumentCategory.visa;
    } else if (docType.contains('medical') || docType.contains('gamca')) {
      category = DocumentCategory.medicalGamca;
    } else if (docType.contains('police') || docType.contains('pcc')) {
      category = DocumentCategory.policeClearance;
    } else {
      category = DocumentCategory.educationAttestation;
    }

    final expiry = json['expiry_date'] != null
        ? DateTime.tryParse(json['expiry_date'].toString())
        : null;

    final has6Months = json['has_six_months_validity'] as bool? ?? false;
    final isVerif = json['is_verified'] as bool? ?? false;

    return VaultDocument(
      id: json['id']?.toString() ?? '',
      category: category,
      title: json['file_name'] as String? ?? json['title'] as String? ?? (category == DocumentCategory.passport ? 'Passport Document' : 'Resume / CV Document'),
      documentNumber: json['passport_number'] as String? ?? json['documentNumber'] as String? ?? 'N/A',
      issuingCountry: json['issuing_country'] as String? ?? json['country_code_icao'] as String? ?? json['issuingCountry'] as String? ?? 'GCC',
      expiryDate: expiry,
      isValidForGccVisa: has6Months,
      isVerified: isVerif,
      fileUrl: json['file_url'] as String? ?? json['fileUrl'] as String?,
      reminder6Months: has6Months,
      reminder3Months: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': category.name,
      'file_name': title,
      'passport_number': documentNumber,
      'issuing_country': issuingCountry,
      'expiry_date': expiryDate?.toIso8601String(),
      'has_six_months_validity': isValidForGccVisa,
      'is_verified': isVerified,
      'file_url': fileUrl,
    };
  }
}
