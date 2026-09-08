import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String formatSalary(double amount, String currencyCode) {
    final format = NumberFormat('#,##0', 'en_US');
    return '${getCurrencySymbol(currencyCode)} ${format.format(amount)}';
  }

  static String formatSalaryRange(double min, double max, String currencyCode, {String period = 'mo'}) {
    final format = NumberFormat('#,##0', 'en_US');
    return '${getCurrencySymbol(currencyCode)} ${format.format(min)} - ${format.format(max)} / $period';
  }

  static String getCurrencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'AED':
      case 'SAR':
      case 'QAR':
      case 'KWD':
      case 'OMR':
      case 'BHD':
        return code.toUpperCase();
      default:
        return code.toUpperCase();
    }
  }
}
