class PassportMRZResult {
  final String passportNumber;
  final String surname;
  final String givenNames;
  final String nationality;
  final DateTime dateOfBirth;
  final String gender;
  final DateTime expiryDate;
  final bool hasSixMonthsValidity;

  const PassportMRZResult({
    required this.passportNumber,
    required this.surname,
    required this.givenNames,
    required this.nationality,
    required this.dateOfBirth,
    required this.gender,
    required this.expiryDate,
    required this.hasSixMonthsValidity,
  });
}

class MrzParser {
  MrzParser._();

  static PassportMRZResult? parseMRZ(String line1, String line2) {
    if (line1.length != 44 || line2.length != 44) return null;

    try {
      final names = line1.substring(5, 44).split('<<');
      final surname = names.isNotEmpty ? names[0].replaceAll('<', ' ').trim() : '';
      final givenNames = names.length > 1 ? names[1].replaceAll('<', ' ').trim() : '';
      
      final passportNumber = line2.substring(0, 9).replaceAll('<', '');
      final nationality = line2.substring(10, 13).replaceAll('<', '');
      
      final dobStr = line2.substring(13, 19);
      final dob = _parseDate(dobStr, isDob: true);
      
      final gender = line2.substring(20, 21);
      
      final expiryStr = line2.substring(21, 27);
      final expiryDate = _parseDate(expiryStr, isDob: false);

      return PassportMRZResult(
        passportNumber: passportNumber,
        surname: surname,
        givenNames: givenNames,
        nationality: nationality,
        dateOfBirth: dob,
        gender: gender,
        expiryDate: expiryDate,
        hasSixMonthsValidity: calculateGccValidity(expiryDate),
      );
    } catch (e) {
      return null;
    }
  }

  static DateTime _parseDate(String dateStr, {required bool isDob}) {
    final year = int.parse(dateStr.substring(0, 2));
    final month = int.parse(dateStr.substring(2, 4));
    final day = int.parse(dateStr.substring(4, 6));
    
    int fullYear;
    final currentYear = DateTime.now().year;
    final century = (currentYear ~/ 100) * 100;
    
    if (isDob) {
      fullYear = century + year;
      if (fullYear > currentYear) {
        fullYear -= 100;
      }
    } else {
      fullYear = century + year;
      if (fullYear < currentYear - 50) {
        fullYear += 100;
      }
    }
    
    return DateTime(fullYear, month, day);
  }

  static bool calculateGccValidity(DateTime expiryDate) {
    final sixMonthsFromNow = DateTime.now().add(const Duration(days: 30 * 6));
    return expiryDate.isAfter(sixMonthsFromNow);
  }
}
