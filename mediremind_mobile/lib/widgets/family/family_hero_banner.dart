import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';

/// Banner hero với vòng kết nối gia đình animated.
class FamilyHeroBanner extends StatefulWidget {
  const FamilyHeroBanner({
    super.key,
    required this.linkedCount,
    required this.pendingCount,
  });

  final int linkedCount;
  final int pendingCount;

  @override
  State<FamilyHeroBanner> createState() => _FamilyHeroBannerState();
}

class _FamilyHeroBannerState extends State<FamilyHeroBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbit;

  @override
  void initState() {
    super.initState();
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.accent.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1.5),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: AnimatedBuilder(
                      animation: _orbit,
                      builder: (_, __) {
                        return CustomPaint(
                          painter: _ConnectionPainter(_orbit.value),
                          child: Center(
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: AppColors.heroGradient,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: AppDecorations.softShadow,
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (b) =>
                              AppColors.titleGradient.createShader(b),
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            'Gia đình đồng hành',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kết nối để cùng theo dõi lịch uống thuốc và nhận cảnh báo kịp thời.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.45,
                              ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _MiniStat(
                                value: widget.linkedCount,
                                label: 'Đã liên kết',
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _MiniStat(
                                value: widget.pendingCount,
                                label: 'Đang chờ',
                                color: AppColors.accentWarm,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  _ConnectionPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.32;
    const dots = 3;

    for (var i = 0; i < dots; i++) {
      final angle = (i / dots) * 2 * math.pi + progress * 2 * math.pi;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      final paint = Paint()
        ..color = AppColors.primary.withValues(alpha: 0.35)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(center, Offset(x, y), paint);
      canvas.drawCircle(
        Offset(x, y),
        10,
        Paint()..color = AppColors.secondary.withValues(alpha: 0.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter old) =>
      old.progress != progress;
}
