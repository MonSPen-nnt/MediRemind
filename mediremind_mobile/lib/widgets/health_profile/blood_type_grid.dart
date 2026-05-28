import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../common/animated_pressable.dart';

class BloodTypeGrid extends StatelessWidget {
  const BloodTypeGrid({
    super.key,
    required this.types,
    required this.selected,
    required this.onSelected,
  });

  final List<String> types;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.35,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        final isSelected = selected == type;
        return _BloodTypeCard(
          type: type,
          selected: isSelected,
          onTap: () => onSelected(type),
        );
      },
    );
  }
}

class _BloodTypeCard extends StatelessWidget {
  const _BloodTypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final String type;
  final bool selected;
  final VoidCallback onTap;

  Color get _tint {
    if (type.startsWith('A')) return const Color(0xFFDC2626);
    if (type.startsWith('B')) return const Color(0xFF2563EB);
    if (type.startsWith('O')) return const Color(0xFFEA580C);
    if (type.startsWith('AB')) return const Color(0xFF7C3AED);
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_tint.withValues(alpha: 0.15), Colors.white],
                )
              : null,
          color: selected ? null : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          border: Border.all(
            color: selected ? _tint : AppColors.border,
            width: selected ? 2.5 : 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _tint.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_rounded,
              color: selected ? _tint : AppColors.textMuted,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              type,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: selected ? _tint : AppColors.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
