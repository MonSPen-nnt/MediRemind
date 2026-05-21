import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../common/animated_pressable.dart';

class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    AppColors.primaryLight,
                    AppColors.surface,
                  ],
                )
              : null,
          color: selected ? null : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 22,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? AppColors.primaryDark
                        : AppColors.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionChipWrap extends StatelessWidget {
  const OptionChipWrap({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.multiSelect = false,
    this.icons,
  });

  final List<String> options;
  final dynamic selected;
  final ValueChanged<String> onChanged;
  final bool multiSelect;
  final Map<String, IconData>? icons;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final isSelected = multiSelect
            ? (selected as List<String>).contains(opt)
            : selected == opt;
        return OptionChip(
          label: opt,
          icon: icons?[opt],
          selected: isSelected,
          onTap: () => onChanged(opt),
        );
      }).toList(),
    );
  }
}
