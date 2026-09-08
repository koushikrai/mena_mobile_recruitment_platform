import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/theme/app_dimensions.dart';
import 'package:mena_recruitment/core/theme/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.colorScheme,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.colorScheme.surface,
        foregroundColor: AppColors.colorScheme.onSurface,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        constraints: const BoxConstraints(minHeight: 50),
        filled: true,
        fillColor: AppColors.colorScheme.surface,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.borderLg,
          borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderLg,
          borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderLg,
          borderSide: BorderSide(color: AppColors.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderLg,
          borderSide: BorderSide(color: AppColors.colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderLg,
          borderSide: BorderSide(color: AppColors.colorScheme.error, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderLg,
          ),
          backgroundColor: AppColors.colorScheme.primary,
          foregroundColor: AppColors.colorScheme.onPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderXl,
        ),
        elevation: 1,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: AppColors.surface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.colorScheme.surface.withOpacity(0.9), // For frosted glass effect wrapper
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.colorScheme.primary,
        unselectedItemColor: AppColors.colorScheme.onSurfaceVariant,
      ),
      chipTheme: ChipThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderFull,
        ),
        backgroundColor: AppColors.colorScheme.surfaceContainer,
        labelStyle: AppTypography.textTheme.labelMedium,
      ),
    );
  }
}
