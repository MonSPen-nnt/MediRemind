import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_theme.dart';
import '../common/animated_pressable.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: AppTheme.minTouchTarget,
        decoration: AppDecorations.secondaryButton,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
