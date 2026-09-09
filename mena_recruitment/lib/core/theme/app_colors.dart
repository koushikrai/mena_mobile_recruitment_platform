import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Crimson Brand Colors from Stitch
  static const Color primary = Color(0xFF990000);
  static const Color primaryDark = Color(0xFF6E0000);
  static const Color primaryContainer = Color(0xFF990000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFA092);
  static const Color primaryFixed = Color(0xFFFFDAD4);
  static const Color primaryFixedDim = Color(0xFFFFB4A8);

  // Secondary & Accents
  static const Color secondary = Color(0xFF5A5F67);
  static const Color secondaryContainer = Color(0xFFBA1A1A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFFFFFFFF);
  static const Color tertiary = Color(0xFF6D0016);
  static const Color tertiaryContainer = Color(0xFF960824);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color emerald = Color(0xFF059669);
  static const Color emeraldDark = Color(0xFF065F46);
  static const Color emeraldBg = Color(0xFFECFDF5);
  static const Color amber = Color(0xFF6E0000);
  static const Color amberDark = Color(0xFF92400E);
  static const Color amberBg = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);

  // Surfaces & Backgrounds
  static const Color surface = Color(0xFFFCF9F9);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFE8E5E8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF9F4F4);
  static const Color surfaceContainer = Color(0xFFF3ECEC);
  static const Color surfaceContainerHigh = Color(0xFFEDE4E4);
  static const Color surfaceContainerHighest = Color(0xFFE4DADB);
  static const Color background = Color(0xFFFCF9F9);

  // Text & Outlines
  static const Color onSurface = Color(0xFF1E1B1B);
  static const Color onSurfaceVariant = Color(0xFF5B403C);
  static const Color outline = Color(0xFF8F706B);
  static const Color outlineVariant = Color(0xFFE4BEB8);
  static const Color border = Color(0xFFE4DADB);
  static const Color borderSubtle = Color(0xFFF0DCD9);
  static const Color textPrimary = Color(0xFF1E1B1B);
  static const Color textSecondary = Color(0xFF5B403C);
  static const Color textMuted = Color(0xFF8F706B);

  // Dark card surface for interview/highlight widgets
  static const Color darkCard = Color(0xFF1C222B);

  // Material 3 ColorScheme
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiary,
    error: error,
    onError: onError,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: surface,
    onSurface: onSurface,
    surfaceContainerHighest: surfaceContainerHigh,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
  );
}

class StatusColors {
  StatusColors._();

  static const Color verifiedBg = Color(0xFFECFDF5);
  static const Color verifiedText = Color(0xFF065F46);
  static const Color verifiedBorder = Color(0xFFA7F3D0);

  static const Color reviewBg = Color(0xFFFFFBEB);
  static const Color reviewText = Color(0xFF92400E);
  static const Color reviewBorder = Color(0xFFFDE68A);

  static const Color criticalBg = Color(0xFFFEF2F2);
  static const Color criticalText = Color(0xFF991B1B);
  static const Color criticalBorder = Color(0xFFFECACA);

  static const Color infoBg = Color(0xFFF1F5F9);
  static const Color infoText = Color(0xFF990000);
  static const Color infoBorder = Color(0xFFCBD5E1);
}
