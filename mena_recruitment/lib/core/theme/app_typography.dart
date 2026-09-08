import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 44 / 36,
        letterSpacing: -0.02 * 36,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 34 / 28,
        letterSpacing: -0.02 * 28,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 30 / 24,
        letterSpacing: -0.015 * 24,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 26 / 20,
        letterSpacing: -0.01 * 20,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 26 / 20,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 20 / 14,
      ),
      labelMedium: GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 14 / 11,
        letterSpacing: 0.04 * 11,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 14 / 11,
        letterSpacing: 0.06 * 11,
      ),
    );
  }

  static TextStyle get currencyNum {
    return GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 22 / 18,
      letterSpacing: -0.01 * 18,
    );
  }

  // Direct static accessors matching typography definitions
  static TextStyle get displayLarge => textTheme.displayLarge!;
  static TextStyle get displayMedium => textTheme.displayMedium!;
  static TextStyle get headlineLarge => textTheme.headlineLarge!;
  static TextStyle get headlineMedium => textTheme.headlineMedium!;
  static TextStyle get headlineSmall => textTheme.headlineSmall!;
  static TextStyle get bodyLarge => textTheme.bodyLarge!;
  static TextStyle get bodyMedium => textTheme.bodyMedium!;
  static TextStyle get bodySmall => textTheme.bodySmall!;
  static TextStyle get titleLarge => textTheme.titleLarge!;
  static TextStyle get titleMedium => textTheme.titleMedium!;
  static TextStyle get titleSmall => textTheme.titleSmall!;
  static TextStyle get labelLarge => textTheme.labelLarge!;
  static TextStyle get labelMedium => textTheme.labelMedium!;
  static TextStyle get labelSmall => textTheme.labelSmall!;
}
