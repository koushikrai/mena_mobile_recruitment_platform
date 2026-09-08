import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Color scheme constants
  static const Color primaryNavy = Color(0xFF0F1E36);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0F1E36);
  static const Color onPrimaryContainer = Color(0xFF7886A3);

  static const Color secondaryAmber = Color(0xFFD97706);
  static const Color secondary = Color(0xFF904D00);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFE932C);
  static const Color onSecondaryContainer = Color(0xFF663500);

  static const Color tertiaryEmerald = Color(0xFF059669);
  static const Color tertiary = Color(0xFF000703);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF002416);
  static const Color onTertiaryContainer = Color(0xFF0E996B);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color surface = Color(0xFFF8F9FF);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFCBDBF5);
  static const Color surfaceBright = Color(0xFFF8F9FF);

  static const Color outline = Color(0xFF75777E);
  static const Color outlineVariant = Color(0xFFC5C6CE);

  static const Color inverseSurface = Color(0xFF213145);
  static const Color inverseOnSurface = Color(0xFFEAF1FF);
  static const Color inversePrimary = Color(0xFFB8C7E6);

  static const Color surfaceTint = Color(0xFF515F7A);

  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0B1C30);
  
  static const Color surfaceVariant = Color(0xFFD3E4FE);
  static const Color onSurfaceVariant = Color(0xFF44474D);

  // Convenience aliases matching design tokens and widgets
  static const Color primary = primaryNavy;
  static const Color amber = secondaryAmber;
  static const Color emerald = tertiaryEmerald;
  static const Color slate = Color(0xFF64748B);
  static const Color textPrimary = onSurface;
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFCBD5E1);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color scaffoldBg = Color(0xFFF8FAFC);

  // Generate ColorScheme
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryNavy,
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
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    background: background,
    onBackground: onBackground,
    surface: surface,
    onSurface: onSurface,
    surfaceVariant: surfaceVariant,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    inverseSurface: inverseSurface,
    onInverseSurface: inverseOnSurface,
    inversePrimary: inversePrimary,
    surfaceTint: surfaceTint,
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
  static const Color infoText = Color(0xFF0F1E36);
  static const Color infoBorder = Color(0xFFCBD5E1);
}
