import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/medication_dose.dart';
import '../common/animated_pressable.dart';

class MedicationDoseCard extends StatelessWidget {
  const MedicationDoseCard({
    super.key,
    required this.dose,
    this.onMarkTaken,
    this.onSkip,
  });

  final MedicationDose dose;
  final VoidCallback? onMarkTaken;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = _statusStyle(dose.status);

    return AnimatedPressable(
      onPressed: dose.status == DoseStatus.pending ||
              dose.status == DoseStatus.upcoming
          ? onMarkTaken
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
          border: Border.all(
            color: dose.status == DoseStatus.upcoming
                ? AppColors.primary.withValues(alpha: 0.45)
                : AppColors.border,
            width: dose.status == DoseStatus.upcoming ? 2 : 1.5,
          ),
          boxShadow: dose.status == DoseStatus.upcoming
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : AppDecorations.softShadow,
        ),
        child: Row(
          children: [
            _TimeColumn(time: dose.timeLabel, color: color),
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(dose.icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dose.medicineName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                  ),
                  Text(
                    dose.dosage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            _StatusChip(label: label, color: color),
            if (dose.status == DoseStatus.pending ||
                dose.status == DoseStatus.upcoming) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onMarkTaken,
                icon: const Icon(Icons.check_circle_outline_rounded),
                color: AppColors.primary,
                tooltip: 'Đã uống',
              ),
            ],
          ],
        ),
      ),
    );
  }

  (String, Color, Color) _statusStyle(DoseStatus status) {
    return switch (status) {
      DoseStatus.taken => (
          'Đã uống',
          AppColors.success,
          AppColors.successLight,
        ),
      DoseStatus.upcoming => (
          'Sắp tới',
          AppColors.primary,
          AppColors.primarySoft,
        ),
      DoseStatus.pending => (
          'Chưa uống',
          AppColors.textSecondary,
          AppColors.backgroundBottom,
        ),
      DoseStatus.missed => (
          'Quên',
          AppColors.error,
          AppColors.error.withValues(alpha: 0.1),
        ),
      DoseStatus.skipped => (
          'Bỏ qua',
          AppColors.textMuted,
          AppColors.border.withValues(alpha: 0.5),
        ),
    };
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({required this.time, required this.color});

  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      child: Column(
        children: [
          Text(
            time,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                  fontSize: 16,
                ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 3,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
