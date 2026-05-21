import 'package:flutter/material.dart';

/// Palette cao cấp — teal tin cậy + lavender nhẹ, dễ đọc mọi lứa tuổi.
abstract final class AppColors {
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF115E59);
  static const Color primaryLight = Color(0xFFCCFBF1);
  static const Color primarySoft = Color(0xFFF0FDFA);

  static const Color secondary = Color(0xFF0284C7);
  static const Color accent = Color(0xFF7C3AED);
  static const Color accentSoft = Color(0xFFEDE9FE);
  static const Color accentWarm = Color(0xFFF59E0B);
  static const Color accentWarmSoft = Color(0xFFFEF3C7);

  static const Color backgroundTop = Color(0xFFECFDF5);
  static const Color backgroundMid = Color(0xFFE0F2FE);
  static const Color backgroundBottom = Color(0xFFF8FAFC);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFAFEFE);
  static const Color surfaceGlass = Color(0xD9FFFFFF);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF0D9488);

  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF0891B2), Color(0xFF6366F1)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient titleGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundTop, backgroundMid, backgroundBottom],
  );

  static const LinearGradient buttonShine = LinearGradient(
    colors: [
      Color(0x00FFFFFF),
      Color(0x55FFFFFF),
      Color(0x00FFFFFF),
    ],
    begin: Alignment(-1.5, 0),
    end: Alignment(2.5, 0),
  );
}
