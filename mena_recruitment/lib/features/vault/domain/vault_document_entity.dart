import 'package:freezed_annotation/freezed_annotation.dart';

part 'vault_document_entity.freezed.dart';
part 'vault_document_entity.g.dart';

enum DocumentCategory {
  passport,
  visa,
  educationAttestation,
  medicalGamca,
  policeClearance,
  tradeLicense
}

@freezed
class VaultDocument with _$VaultDocument {
  const factory VaultDocument({
    required String id,
    required DocumentCategory category,
    required String title,
    required String documentNumber,
    required String issuingCountry,
    DateTime? expiryDate,
    @Default(false) bool isValidForGccVisa,
    @Default(false) bool isVerified,
    String? fileUrl,
    @Default(false) bool reminder6Months,
    @Default(false) bool reminder3Months,
  }) = _VaultDocument;

  factory VaultDocument.fromJson(Map<String, dynamic> json) =>
      _$VaultDocumentFromJson(json);
}
