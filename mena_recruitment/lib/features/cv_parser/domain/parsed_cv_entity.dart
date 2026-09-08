import 'package:freezed_annotation/freezed_annotation.dart';

part 'parsed_cv_entity.freezed.dart';
part 'parsed_cv_entity.g.dart';

@freezed
class ParsedCV with _$ParsedCV {
  const factory ParsedCV({
    required String fullName,
    required String email,
    required String phone,
    required String nationality,
    required String residentCountry,
    required String targetTitle,
    required double totalExperience,
    required double gccExperience,
    @Default([]) List<WorkExperience> experiences,
    @Default([]) List<EducationEntry> education,
    @Default([]) List<String> skills,
  }) = _ParsedCV;

  factory ParsedCV.fromJson(Map<String, dynamic> json) => _$ParsedCVFromJson(json);
}

@freezed
class WorkExperience with _$WorkExperience {
  const factory WorkExperience({
    required String title,
    required String company,
    required String location,
    required String startDate,
    required String endDate,
    @Default([]) List<String> highlights,
  }) = _WorkExperience;

  factory WorkExperience.fromJson(Map<String, dynamic> json) => _$WorkExperienceFromJson(json);
}

@freezed
class EducationEntry with _$EducationEntry {
  const factory EducationEntry({
    required String degree,
    required String institution,
    required String year,
    required String attestationStatus,
  }) = _EducationEntry;

  factory EducationEntry.fromJson(Map<String, dynamic> json) => _$EducationEntryFromJson(json);
}
