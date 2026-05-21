import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';

class MetricSliderCard extends StatelessWidget {
  const MetricSliderCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.icon,
    this.formatValue,
  });

  final String label;
  final double value;
  final String unit;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final IconData icon;
  final String Function(double)? formatValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = formatValue?.call(value) ?? value.round().toString();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
                children: [
                  TextSpan(text: display),
                  TextSpan(
                    text: ' $unit',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primaryLight,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.12),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
