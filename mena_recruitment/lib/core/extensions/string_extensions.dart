extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  String maskPassport() {
    if (length < 4) return this;
    return '****${substring(length - 4)}';
  }

  String maskPhone() {
    if (length < 4) return this;
    final parts = split(' ');
    final prefix = parts.length > 1 ? '${parts[0]} ' : '';
    final number = parts.length > 1 ? parts[1] : this;
    
    if (number.length < 4) return this;
    return '$prefix****${number.substring(number.length - 4)}';
  }
}
