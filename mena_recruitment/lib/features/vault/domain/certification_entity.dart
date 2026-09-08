import 'package:freezed_annotation/freezed_annotation.dart';

part 'certification_entity.freezed.dart';
part 'certification_entity.g.dart';

enum CertificationCategory {
  engineeringSCE,
  safetyNeboshOsha,
  driving,
  medicalDhaMoh,
  other
}

@freezed
class Certification with _$Certification {
  const factory Certification({
    required String id,
    required String title,
    required CertificationCategory category,
    required String issuingAuthority,
    required String credentialId,
    required DateTime validFrom,
    DateTime? validUntil,
    @Default(false) bool isVerified,
    String? documentUrl,
  }) = _Certification;

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);
}
