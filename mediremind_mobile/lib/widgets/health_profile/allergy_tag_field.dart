import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../auth/auth_text_field.dart';

class AllergyTagField extends StatefulWidget {
  const AllergyTagField({
    super.key,
    required this.controller,
    required this.tags,
    required this.onTagsChanged,
    this.quickOptions = const [
      'Penicillin',
      'Aspirin',
      'Paracetamol',
      'Kháng sinh',
      'IbuProfen',
    ],
  });

  final TextEditingController controller;
  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;
  final List<String> quickOptions;

  @override
  State<AllergyTagField> createState() => _AllergyTagFieldState();
}

class _AllergyTagFieldState extends State<AllergyTagField> {
  void _addTag(String raw) {
    final tag = raw.trim();
    if (tag.isEmpty) return;
    if (widget.tags.contains(tag)) return;
    widget.onTagsChanged([...widget.tags, tag]);
    widget.controller.clear();
  }

  void _removeTag(String tag) {
    widget.onTagsChanged(widget.tags.where((t) => t != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: widget.controller,
          label: 'Dị ứng thuốc / thực phẩm',
          hint: 'Nhập và nhấn + để thêm',
          icon: Icons.warning_amber_rounded,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: _addTag,
          suffix: IconButton(
            onPressed: () => _addTag(widget.controller.text),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            ),
          ),
        ),
        if (widget.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.tags.map((tag) {
                return Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  deleteIcon: const Icon(Icons.close_rounded, size: 20),
                  onDeleted: () => _removeTag(tag),
                  backgroundColor: AppColors.accentWarmSoft,
                  side: BorderSide(
                    color: AppColors.accentWarm.withValues(alpha: 0.4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Gợi ý nhanh',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.quickOptions.map((opt) {
            final added = widget.tags.contains(opt);
            return FilterChip(
              label: Text(opt),
              selected: added,
              onSelected: (_) {
                if (added) {
                  _removeTag(opt);
                } else {
                  _addTag(opt);
                }
              },
              selectedColor: AppColors.accentWarmSoft,
              checkmarkColor: AppColors.accentWarm,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: added ? AppColors.primaryDark : AppColors.textPrimary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDecorations.radiusSm),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
