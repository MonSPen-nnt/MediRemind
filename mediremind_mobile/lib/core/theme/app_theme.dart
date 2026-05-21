import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_decorations.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static const double fontSizeBody = 20;
  static const double fontSizeLabel = 18;
  static const double fontSizeTitle = 34;
  static const double fontSizeSubtitle = 22;
  static const double fontSizeButton = 20;
  static const double minTouchTarget = 58;

  static ThemeData get light {
    final textTheme = AppTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: textTheme.bodyLarge?.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.backgroundBottom,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
        ),
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        prefixIconColor: AppColors.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(elevation: 0, shadowColor: Colors.transparent),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, minTouchTarget),
          textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
