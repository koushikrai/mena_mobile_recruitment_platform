class PassportMRZ {
  final String rawMrz;
  final String passportNumber;
  final String surname;
  final String givenNames;
  final String nationality;
  final DateTime dateOfBirth;
  final String gender;
  final DateTime expiryDate;
  final bool hasSixMonthsValidity;

  const PassportMRZ({
    required this.rawMrz,
    required this.passportNumber,
    required this.surname,
    required this.givenNames,
    required this.nationality,
    required this.dateOfBirth,
    required this.gender,
    required this.expiryDate,
    required this.hasSixMonthsValidity,
  });

  PassportMRZ copyWith({
    String? rawMrz,
    String? passportNumber,
    String? surname,
    String? givenNames,
    String? nationality,
    DateTime? dateOfBirth,
    String? gender,
    DateTime? expiryDate,
    bool? hasSixMonthsValidity,
  }) {
    return PassportMRZ(
      rawMrz: rawMrz ?? this.rawMrz,
      passportNumber: passportNumber ?? this.passportNumber,
      surname: surname ?? this.surname,
      givenNames: givenNames ?? this.givenNames,
      nationality: nationality ?? this.nationality,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      expiryDate: expiryDate ?? this.expiryDate,
      hasSixMonthsValidity: hasSixMonthsValidity ?? this.hasSixMonthsValidity,
    );
  }
}
