import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.medical_services_rounded,
    this.stepLabel,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String? stepLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (stepLabel != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLight,
                  AppColors.accentSoft.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              stepLabel!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: AppDecorations.iconBadge(),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (b) =>
                        AppColors.titleGradient.createShader(b),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      title,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(subtitle!, style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
