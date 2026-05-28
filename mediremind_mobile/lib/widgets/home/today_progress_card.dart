import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';

class TodayProgressCard extends StatefulWidget {
  const TodayProgressCard({
    super.key,
    required this.takenCount,
    required this.totalCount,
    required this.streakDays,
  });

  final int takenCount;
  final int totalCount;
  final int streakDays;

  @override
  State<TodayProgressCard> createState() => _TodayProgressCardState();
}

class _TodayProgressCardState extends State<TodayProgressCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant TodayProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.takenCount != widget.takenCount) {
      _progress.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = widget.totalCount == 0
        ? 0.0
        : widget.takenCount / widget.totalCount;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _progress,
            builder: (_, __) {
              final value = ratio * _progress.value;
              return SizedBox(
                width: 88,
                height: 88,
                child: CustomPaint(
                  painter: _RingPainter(progress: value),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.takenCount}/${widget.totalCount}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                        ),
                        Text(
                          'liều',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiến độ hôm nay',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  ratio >= 1
                      ? 'Tuyệt vời! Bạn đã uống đủ thuốc hôm nay.'
                      : 'Còn ${widget.totalCount - widget.takenCount} liều cần uống trong ngày.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 12),
                _StreakBadge(days: widget.streakDays),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentWarmSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentWarm.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: AppColors.accentWarm, size: 20),
          const SizedBox(width: 6),
          Text(
            '$days ngày liên tiếp',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentWarm,
                ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const stroke = 8.0;

    final bg = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);

    final fg = Paint()
      ..shader = AppColors.heroGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}
