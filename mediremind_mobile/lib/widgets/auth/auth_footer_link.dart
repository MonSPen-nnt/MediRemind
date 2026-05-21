import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.prefix,
    required this.linkText,
    required this.onTap,
  });

  final String prefix;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDecorations.radiusSm),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(prefix, style: theme.textTheme.bodyMedium),
          TextButton(
            onPressed: onTap,
            child: Text(
              linkText,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
