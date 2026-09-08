class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    // Simplified regex checking for allowed GCC prefixes and digits
    final phoneRegExp = RegExp(r"^\+?(971|966|974|965|968|973)\s?[0-9]{7,9}$");
    if (!phoneRegExp.hasMatch(value.replaceAll(' ', ''))) return 'Enter a valid GCC phone number';
    return null;
  }

  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  static String? validatePassportNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Passport number is required';
    if (value.length < 6 || value.length > 9) return 'Enter a valid passport number';
    return null;
  }

  static String? validateSalary(String? value) {
    if (value == null || value.trim().isEmpty) return 'Salary is required';
    if (double.tryParse(value) == null) return 'Enter a valid number';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name must be at least 2 characters';
    return null;
  }
}
