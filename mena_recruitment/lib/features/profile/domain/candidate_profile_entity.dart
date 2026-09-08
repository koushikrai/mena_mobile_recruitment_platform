import 'package:freezed_annotation/freezed_annotation.dart';

part 'candidate_profile_entity.freezed.dart';
part 'candidate_profile_entity.g.dart';

@freezed
class CandidateProfile with _$CandidateProfile {
  const factory CandidateProfile({
    required String id,
    required String uid,
    required String fullName,
    required String email,
    required String phone,
    required String nationality,
    required String residentCountry,
    required String targetTitle,
    required int totalExperience,
    required int gccExperience,
    required int readinessScore,
    required bool isActivelyLooking,
    required List<String> preferredCountries,
    required double expectedSalary,
    required String expectedCurrency,
    required String noticePeriod,
    required String relocationStatus,
    required bool isGccVerified,
  }) = _CandidateProfile;

  factory CandidateProfile.fromJson(Map<String, dynamic> json) =>
      _$CandidateProfileFromJson(json);
}
