import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toFormattedDate() {
    return DateFormat('MMM d, yyyy').format(this);
  }

  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()} years ago';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()} months ago';
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes} minutes ago';
    return 'Just now';
  }

  int daysUntilExpiry() {
    return difference(DateTime.now()).inDays;
  }

  bool hasMinimumGccValidity() {
    final sixMonthsFromNow = DateTime.now().add(const Duration(days: 30 * 6));
    return isAfter(sixMonthsFromNow);
  }

  String toPassportFormat() {
    return DateFormat('yyMMdd').format(this);
  }
}
