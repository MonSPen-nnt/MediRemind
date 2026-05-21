import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppDecorations {
  static const double radiusXl = 28;
  static const double radiusLg = 22;
  static const double radiusMd = 16;
  static const double radiusSm = 12;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.14),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get floatShadow => [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.1),
          blurRadius: 40,
          offset: const Offset(0, 16),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  static BoxDecoration get glassCard => BoxDecoration(
        borderRadius: BorderRadius.circular(radiusXl),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1.5,
        ),
        boxShadow: cardShadow,
      );

  static BoxDecoration get primaryButton => BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get secondaryButton => BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration iconBadge({Color? tint}) => BoxDecoration(
        color: (tint ?? AppColors.primary).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radiusSm),
      );
}
