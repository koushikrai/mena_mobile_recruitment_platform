import 'package:freezed_annotation/freezed_annotation.dart';

part 'relocation_preferences.freezed.dart';
part 'relocation_preferences.g.dart';

@freezed
class RelocationPreferences with _$RelocationPreferences {
  const factory RelocationPreferences({
    required List<String> preferredCountries,
    required double expectedSalary,
    required String currency,
    required String noticePeriod,
    required String familyStatus,
  }) = _RelocationPreferences;

  factory RelocationPreferences.fromJson(Map<String, dynamic> json) =>
      _$RelocationPreferencesFromJson(json);
}
