import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_entity.freezed.dart';
part 'application_entity.g.dart';

enum RelocationStage {
  @JsonValue('applied') applied,
  @JsonValue('screening') screening,
  @JsonValue('interview') interview,
  @JsonValue('offerIssued') offerIssued,
  @JsonValue('visaProcessing') visaProcessing,
  @JsonValue('flightOnboarding') flightOnboarding,
}

enum StatusSeverity {
  @JsonValue('verified') verified,
  @JsonValue('review') review,
  @JsonValue('critical') critical,
  @JsonValue('info') info,
}

@freezed
class JobApplication with _$JobApplication {
  const factory JobApplication({
    required String id,
    required String jobId,
    required String jobTitle,
    required String companyName,
    required String companyLogoUrl,
    required String countryCode,
    required String city,
    required DateTime appliedDate,
    required RelocationStage currentStage,
    required String statusLabel,
    required StatusSeverity severity,
    @Default([]) List<String> missingDocuments,
    DateTime? nextDeadline,
    String? recruiterContact,
  }) = _JobApplication;

  factory JobApplication.fromJson(Map<String, dynamic> json) => _$JobApplicationFromJson(json);
}
