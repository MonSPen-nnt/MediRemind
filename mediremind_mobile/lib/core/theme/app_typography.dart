import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_theme.dart';

abstract final class AppTypography {
  static TextTheme get textTheme {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return base.copyWith(
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: AppTheme.fontSizeTitle,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.12,
        letterSpacing: -0.8,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: AppTheme.fontSizeSubtitle,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.3,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: AppTheme.fontSizeBody,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: AppTheme.fontSizeLabel,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.45,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: AppTheme.fontSizeButton,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }
}
