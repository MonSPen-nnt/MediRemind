import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/health_profile.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/primary_button.dart';
import '../../widgets/auth/secondary_button.dart';
import '../../widgets/common/glass_surface.dart';
import '../../widgets/health_profile/medical_info_step.dart';
import '../../widgets/health_profile/metric_slider_card.dart';
import '../../widgets/health_profile/option_chip.dart';
import '../../widgets/health_profile/profile_summary_tile.dart';
import '../../widgets/health_profile/setup_progress_header.dart';

class HealthProfileSetupScreen extends StatefulWidget {
  const HealthProfileSetupScreen({super.key});

  @override
  State<HealthProfileSetupScreen> createState() =>
      _HealthProfileSetupScreenState();
}

class _HealthProfileSetupScreenState extends State<HealthProfileSetupScreen> {
  static const _stepMeta = [
    (
      title: 'Thông tin cá nhân',
      subtitle: 'Giúp chúng tôi gọi đúng tên và nhắc phù hợp lứa tuổi.',
      icon: Icons.person_outline_rounded,
    ),
    (
      title: 'Chỉ số cơ thể',
      subtitle: 'Chiều cao, cân nặng hỗ trợ theo dõi sức khỏe tốt hơn.',
      icon: Icons.monitor_heart_outlined,
    ),
    (
      title: 'Tiền sử y tế',
      subtitle: 'Dị ứng & bệnh nền — an toàn khi nhắc uống thuốc.',
      icon: Icons.health_and_safety_outlined,
    ),
    (
      title: 'Xác nhận hồ sơ',
      subtitle: 'Kiểm tra lại trước khi bắt đầu nhắc nhở.',
      icon: Icons.verified_user_outlined,
    ),
  ];

  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  int _step = 0;
  bool _isSaving = false;

  DateTime? _dob;
  String? _gender;
  double _height = 165;
  double _weight = 60;
  String? _bloodType;
  final List<String> _conditions = [];
  final List<String> _allergyTags = [];

  static const _genders = ['Nam', 'Nữ', 'Khác'];
  static const _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-', 'Chưa rõ',
  ];
  static const _conditionsList = [
    'Tiểu đường',
    'Cao huyết áp',
    'Tim mạch',
    'Hen suyễn',
    'Suy thận',
    'Không có',
  ];
  static const _conditionIcons = {
    'Tiểu đường': Icons.bloodtype_outlined,
    'Cao huyết áp': Icons.favorite_outline_rounded,
    'Tim mạch': Icons.monitor_heart_outlined,
    'Hen suyễn': Icons.air_rounded,
    'Suy thận': Icons.water_drop_outlined,
    'Không có': Icons.check_circle_outline_rounded,
  };

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _allergiesController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  HealthProfile get _profile => HealthProfile(
        displayName: _nameController.text.trim(),
        dateOfBirth: _dob,
        gender: _gender,
        heightCm: _height,
        weightKg: _weight,
        bloodType: _bloodType,
        allergies: _allergyTags.isNotEmpty
            ? _allergyTags.join(', ')
            : _allergiesController.text.trim(),
        conditions: List.from(_conditions),
        emergencyName: _emergencyNameController.text.trim(),
        emergencyPhone: _emergencyPhoneController.text.trim(),
      );

  String _formatDob() {
    if (_dob == null) return 'Chưa chọn';
    final d = _dob!;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  String _bmiLabel(double bmi) {
    if (bmi < 18.5) return 'Thiếu cân';
    if (bmi < 25) return 'Bình thường';
    if (bmi < 30) return 'Thừa cân';
    return 'Béo phì';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 40),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
      helpText: 'Chọn ngày sinh',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  bool _validateStep() {
    switch (_step) {
      case 0:
        if (_nameController.text.trim().isEmpty) {
          _showError('Vui lòng nhập họ tên');
          return false;
        }
        if (_dob == null) {
          _showError('Vui lòng chọn ngày sinh');
          return false;
        }
        if (_gender == null) {
          _showError('Vui lòng chọn giới tính');
          return false;
        }
        return true;
      case 1:
        return true;
      case 2:
        if (_bloodType == null) {
          _showError('Vui lòng chọn nhóm máu');
          return false;
        }
        return true;
      case 3:
        if (_emergencyNameController.text.trim().isEmpty ||
            _emergencyPhoneController.text.trim().isEmpty) {
          _showError('Vui lòng nhập liên hệ khẩn cấp');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _next() {
    if (!_validateStep()) return;
    if (_step < _stepMeta.length - 1) {
      setState(() => _step++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.maybePop(context);
    }
  }

  Future<void> _finish() async {
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
      arguments: _profile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final meta = _stepMeta[_step];
    final isLast = _step == _stepMeta.length - 1;
    final profile = _profile;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SetupProgressHeader(
                  currentStep: _step,
                  totalSteps: _stepMeta.length,
                  title: meta.title,
                  subtitle: meta.subtitle,
                  icon: meta.icon,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStep0(),
                      _buildStep1(profile),
                      _buildStep2(),
                      _buildStep3(profile),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
                  child: Row(
                    children: [
                      if (_step > 0)
                        Expanded(
                          child: SecondaryButton(
                            label: 'Quay lại',
                            onPressed: _back,
                          ),
                        ),
                      if (_step > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: _step == 0 ? 1 : 2,
                        child: PrimaryButton(
                          label: isLast ? 'Bắt đầu sử dụng' : 'Tiếp tục',
                          icon: isLast
                              ? Icons.rocket_launch_rounded
                              : Icons.arrow_forward_rounded,
                          isLoading: isLast && _isSaving,
                          onPressed: _next,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep0() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: GlassSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _nameController,
              label: 'Họ và tên',
              hint: 'Tên hiển thị trên app',
              icon: Icons.badge_outlined,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            _DatePickerTile(
              label: _formatDob(),
              onTap: _pickDate,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Giới tính',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            OptionChipWrap(
              options: _genders,
              selected: _gender,
              icons: const {
                'Nam': Icons.male_rounded,
                'Nữ': Icons.female_rounded,
                'Khác': Icons.person_rounded,
              },
              onChanged: (v) => setState(() => _gender = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1(HealthProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          MetricSliderCard(
            label: 'Chiều cao',
            value: _height,
            unit: 'cm',
            min: 100,
            max: 220,
            divisions: 120,
            icon: Icons.height_rounded,
            onChanged: (v) => setState(() => _height = v),
          ),
          const SizedBox(height: AppSpacing.md),
          MetricSliderCard(
            label: 'Cân nặng',
            value: _weight,
            unit: 'kg',
            min: 30,
            max: 150,
            divisions: 120,
            icon: Icons.fitness_center_rounded,
            onChanged: (v) => setState(() => _weight = v),
          ),
          const SizedBox(height: AppSpacing.md),
          _BmiInsightCard(
            bmi: profile.bmi,
            label: _bmiLabel(profile.bmi),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return MedicalInfoStep(
      bloodType: _bloodType,
      conditions: _conditions,
      allergyTags: _allergyTags,
      allergiesController: _allergiesController,
      bloodTypes: _bloodTypes,
      conditionsList: _conditionsList,
      conditionIcons: _conditionIcons,
      onBloodTypeChanged: (v) => setState(() => _bloodType = v),
      onConditionsChanged: (list) => setState(() {
        _conditions
          ..clear()
          ..addAll(list);
      }),
      onAllergyTagsChanged: (tags) => setState(() {
        _allergyTags
          ..clear()
          ..addAll(tags);
      }),
    );
  }

  Widget _buildStep3(HealthProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          GlassSurface(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Liên hệ khẩn cấp',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                AuthTextField(
                  controller: _emergencyNameController,
                  label: 'Họ tên người liên hệ',
                  icon: Icons.contact_emergency_outlined,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                AuthTextField(
                  controller: _emergencyPhoneController,
                  label: 'Số điện thoại',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GlassSurface(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.summarize_rounded,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Tóm tắt hồ sơ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ProfileSummaryTile(
                  icon: Icons.person_rounded,
                  label: 'Họ tên',
                  value: profile.displayName,
                ),
                ProfileSummaryTile(
                  icon: Icons.cake_rounded,
                  label: 'Ngày sinh',
                  value: '${_formatDob()}${profile.age != null ? ' · ${profile.age} tuổi' : ''}',
                  tint: AppColors.secondary,
                ),
                ProfileSummaryTile(
                  icon: Icons.wc_rounded,
                  label: 'Giới tính',
                  value: profile.gender ?? '—',
                ),
                ProfileSummaryTile(
                  icon: Icons.straighten_rounded,
                  label: 'Chiều cao / Cân nặng',
                  value:
                      '${profile.heightCm.round()} cm · ${profile.weightKg.round()} kg',
                  tint: AppColors.accent,
                ),
                ProfileSummaryTile(
                  icon: Icons.bloodtype_rounded,
                  label: 'Nhóm máu',
                  value: profile.bloodType ?? '—',
                  tint: AppColors.error,
                ),
                ProfileSummaryTile(
                  icon: Icons.medical_information_outlined,
                  label: 'Bệnh nền',
                  value: profile.conditions.isEmpty
                      ? 'Không ghi nhận'
                      : profile.conditions.join(', '),
                ),
                ProfileSummaryTile(
                  icon: Icons.warning_amber_rounded,
                  label: 'Dị ứng thuốc',
                  value: profile.allergies.isNotEmpty
                      ? profile.allergies
                      : 'Không ghi nhận',
                  tint: AppColors.accentWarm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isEmpty = label == 'Chưa chọn';

    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
            border: Border.all(
              color: isEmpty ? AppColors.border : AppColors.primary,
              width: isEmpty ? 1.5 : 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngày sinh',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isEmpty
                                ? AppColors.textMuted
                                : AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _BmiInsightCard extends StatelessWidget {
  const _BmiInsightCard({required this.bmi, required this.label});

  final double bmi;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.8),
            AppColors.accentSoft.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(
              bmi.toStringAsFixed(1),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 26,
                    color: AppColors.primaryDark,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chỉ số BMI',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        color: AppColors.primaryDark,
                      ),
                ),
                Text(
                  'Tham khảo — không thay thế tư vấn bác sĩ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
