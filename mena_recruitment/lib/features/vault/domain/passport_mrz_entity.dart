import 'package:freezed_annotation/freezed_annotation.dart';

part 'passport_mrz_entity.freezed.dart';
part 'passport_mrz_entity.g.dart';

@freezed
class PassportMRZ with _$PassportMRZ {
  const factory PassportMRZ({
    required String rawMrz,
    required String passportNumber,
    required String surname,
    required String givenNames,
    required String nationality,
    required DateTime dateOfBirth,
    required String gender,
    required DateTime expiryDate,
    required bool hasSixMonthsValidity,
  }) = _PassportMRZ;

  factory PassportMRZ.fromJson(Map<String, dynamic> json) =>
      _$PassportMRZFromJson(json);
}
