import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../health_profile/option_chip.dart';

class RelationshipSelector extends StatelessWidget {
  const RelationshipSelector({
    super.key,
    required this.options,
    required this.icons,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final Map<String, IconData> icons;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mối quan hệ',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((rel) {
            return OptionChip(
              label: rel,
              icon: icons[rel],
              selected: selected == rel,
              onTap: () => onSelected(rel),
            );
          }).toList(),
        ),
      ],
    );
  }
}
