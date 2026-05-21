import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';

/// Logo thương hiệu có vòng quay nhẹ — điểm nhấn Welcome.
class BrandLogo extends StatefulWidget {
  const BrandLogo({super.key, this.size = 140});

  final double size;

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbit;

  @override
  void initState() {
    super.initState();
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;

    return SizedBox(
      width: s + 24,
      height: s + 24,
      child: AnimatedBuilder(
        animation: _orbit,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _orbit.value * 2 * math.pi,
                child: Container(
                  width: s + 20,
                  height: s + 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      width: 2,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.accentWarm,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentWarm.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child!,
            ],
          );
        },
        child: Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            shape: BoxShape.circle,
            boxShadow: AppDecorations.softShadow,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.medication_rounded,
                size: s * 0.42,
                color: Colors.white.withValues(alpha: 0.96),
              ),
              Positioned(
                right: s * 0.18,
                bottom: s * 0.2,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.accentWarm,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: AppDecorations.floatShadow,
                  ),
                  child: Icon(
                    Icons.alarm_rounded,
                    size: s * 0.14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
