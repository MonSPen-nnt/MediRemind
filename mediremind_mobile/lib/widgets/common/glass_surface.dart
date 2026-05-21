import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_decorations.dart';

/// Thẻ kính mờ — chiều sâu cao cấp.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.blur = 18,
  });

  final Widget child;
  final EdgeInsets padding;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: AppDecorations.glassCard.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
          ),
          child: child,
        ),
      ),
    );
  }
}
