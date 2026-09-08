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
}
