import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/medical_scan_result.dart';
import '../common/animated_pressable.dart';
import '../common/glass_surface.dart';
import 'allergy_tag_field.dart';
import 'blood_type_grid.dart';
import 'input_mode_toggle.dart';
import 'medical_scan_sheet.dart';
import 'medical_section_header.dart';
import 'option_chip.dart';

class MedicalInfoStep extends StatefulWidget {
  const MedicalInfoStep({
    super.key,
    required this.bloodType,
    required this.conditions,
    required this.allergyTags,
    required this.allergiesController,
    required this.bloodTypes,
    required this.conditionsList,
    required this.conditionIcons,
    required this.onBloodTypeChanged,
    required this.onConditionsChanged,
    required this.onAllergyTagsChanged,
  });

  final String? bloodType;
  final List<String> conditions;
  final List<String> allergyTags;
  final TextEditingController allergiesController;
  final List<String> bloodTypes;
  final List<String> conditionsList;
  final Map<String, IconData> conditionIcons;
  final ValueChanged<String?> onBloodTypeChanged;
  final ValueChanged<List<String>> onConditionsChanged;
  final ValueChanged<List<String>> onAllergyTagsChanged;

  @override
  State<MedicalInfoStep> createState() => _MedicalInfoStepState();
}

class _MedicalInfoStepState extends State<MedicalInfoStep> {
  static const _otherChipLabel = 'Khác..';

  MedicalInputMode _mode = MedicalInputMode.manual;

  Set<String> get _predefinedConditions => widget.conditionsList.toSet();

  List<String> get _customConditions => widget.conditions
      .where((c) => !_predefinedConditions.contains(c))
      .toList();

  void _toggleCondition(String c) {
    final list = List<String>.from(widget.conditions);
    if (c == 'Không có') {
      widget.onConditionsChanged([c]);
      return;
    }
    list.remove('Không có');
    if (list.contains(c)) {
      list.remove(c);
    } else {
      list.add(c);
    }
    widget.onConditionsChanged(list);
  }

  void _removeCustomCondition(String name) {
    final list = List<String>.from(widget.conditions)..remove(name);
    widget.onConditionsChanged(list);
  }

  Future<void> _showOtherConditionDialog() async {
    final controller = TextEditingController();
    final added = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
          ),
          title: Text(
            'Bệnh nền khác',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Tên bệnh',
              hintText: 'VD: Viêm khớp, Động kinh...',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
            onSubmitted: (v) {
              if (v.trim().isNotEmpty) Navigator.pop(context, v.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) Navigator.pop(context, text);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (added == null || added.isEmpty || !mounted) return;

    if (_predefinedConditions.contains(added)) {
      _toggleCondition(added);
      return;
    }

    final list = List<String>.from(widget.conditions)
      ..remove('Không có');
    if (!list.contains(added)) list.add(added);
    widget.onConditionsChanged(list);
  }

  void _applyScanResult(MedicalScanResult result) {
    if (result.bloodType != null) {
      widget.onBloodTypeChanged(result.bloodType);
    }
    if (result.conditions.isNotEmpty) {
      widget.onConditionsChanged(result.conditions);
    }
    if (result.allergies.isNotEmpty) {
      widget.onAllergyTagsChanged([
        ...widget.allergyTags,
        ...result.allergies.where((a) => !widget.allergyTags.contains(a)),
      ]);
    }
    setState(() => _mode = MedicalInputMode.manual);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã áp dụng thông tin từ bản quét')),
    );
  }

  Future<void> _openScan() async {
    await MedicalScanSheet.show(context, onApply: _applyScanResult);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputModeToggle(
            mode: _mode,
            onChanged: (m) => setState(() => _mode = m),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _mode == MedicalInputMode.scan
                ? _buildScanPromo(key: const ValueKey('scan'))
                : _buildManualForm(key: const ValueKey('manual')),
          ),
        ],
      ),
    );
  }

  Widget _buildScanPromo({required Key key}) {
    return Column(
      key: key,
      children: [
        AnimatedPressable(
          onPressed: _openScan,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryDark.withValues(alpha: 0.9),
                  AppColors.accent.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Quét đơn thuốc / sổ khám',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tự động điền nhóm máu, bệnh nền,\ndị ứng thuốc (demo UI)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Mở camera quét',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.primaryDark,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Hoặc chuyển sang "Nhập tay" để điền thủ công',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildManualForm({required Key key}) {
    return GlassSurface(
      key: key,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MedicalSectionHeader(
            title: 'Nhóm máu',
            subtitle: 'Chọn đúng nhóm để cảnh báo an toàn',
            icon: Icons.bloodtype_rounded,
            tint: AppColors.error,
          ),
          BloodTypeGrid(
            types: widget.bloodTypes,
            selected: widget.bloodType,
            onSelected: (v) => widget.onBloodTypeChanged(v),
          ),
          const SizedBox(height: AppSpacing.xl),
          const MedicalSectionHeader(
            title: 'Bệnh nền',
            subtitle: 'Chọn tất cả bệnh đang điều trị',
            icon: Icons.medical_information_outlined,
            tint: AppColors.secondary,
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...widget.conditionsList.map((c) {
                return OptionChip(
                  label: c,
                  icon: widget.conditionIcons[c],
                  selected: widget.conditions.contains(c),
                  onTap: () => _toggleCondition(c),
                );
              }),
              OptionChip(
                label: _otherChipLabel,
                icon: Icons.add_circle_outline_rounded,
                selected: _customConditions.isNotEmpty,
                onTap: _showOtherConditionDialog,
              ),
            ],
          ),
          if (_customConditions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bệnh đã nhập',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _customConditions.map((name) {
                return Chip(
                  label: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  deleteIcon: const Icon(Icons.close_rounded, size: 20),
                  onDeleted: () => _removeCustomCondition(name),
                  backgroundColor: AppColors.accentSoft,
                  side: BorderSide(
                    color: AppColors.accent.withValues(alpha: 0.35),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          const MedicalSectionHeader(
            title: 'Dị ứng thuốc',
            subtitle: 'Ghi rõ để tránh nhắc nhầm thuốc',
            icon: Icons.warning_amber_rounded,
            tint: AppColors.accentWarm,
          ),
          AllergyTagField(
            controller: widget.allergiesController,
            tags: widget.allergyTags,
            onTagsChanged: widget.onAllergyTagsChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: _openScan,
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Quét tài liệu thay vì nhập'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
