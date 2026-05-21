import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class SetupProgressHeader extends StatelessWidget {
  const SetupProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final int currentStep;
  final int totalSteps;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (currentStep + 1) / totalSteps;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryLight,
                      AppColors.accentSoft.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'BƯỚC ${currentStep + 1} / $totalSteps',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ShaderMask(
            shaderCallback: (b) => AppColors.titleGradient.createShader(b),
            blendMode: BlendMode.srcIn,
            child: Text(
              title,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: AppColors.border.withValues(alpha: 0.5),
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: List.generate(totalSteps, (i) {
              final active = i <= currentStep;
              final current = i == currentStep;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
                  height: 6,
                  decoration: BoxDecoration(
                    color: active
                        ? (current ? AppColors.primary : AppColors.primaryLight)
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
