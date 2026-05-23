import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/health_profile.dart';
import '../../models/medication_dose.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/common/staggered_entrance.dart';
import '../../widgets/family/family_section_header.dart';
import '../../widgets/home/home_bottom_nav.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/home_quick_action.dart';
import '../../widgets/home/medication_dose_card.dart';
import '../../widgets/home/next_dose_hero.dart';
import '../../widgets/home/today_progress_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.profile});

  final HealthProfile? profile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  int _staggerSeed = 0;
  late List<MedicationDose> _doses;

  @override
  void initState() {
    super.initState();
    _doses = _demoDoses();
  }

  String get _displayName {
    final name = widget.profile?.displayName.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'Bạn';
  }

  String get _dateLabel {
    const weekdays = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];
    final now = DateTime.now();
    final weekday = weekdays[now.weekday - 1];
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    return '$weekday, $day/$month/${now.year}';
  }

  int get _takenCount =>
      _doses.where((d) => d.status == DoseStatus.taken).length;

  MedicationDose? get _nextDose {
    for (final d in _doses) {
      if (d.status == DoseStatus.upcoming || d.status == DoseStatus.pending) {
        return d;
      }
    }
    return null;
  }

  List<MedicationDose> _demoDoses() {
    return [
      const MedicationDose(
        id: '1',
        medicineName: 'Vitamin D3',
        dosage: '1 viên · sau bữa sáng',
        scheduledTime: TimeOfDay(hour: 7, minute: 0),
        status: DoseStatus.taken,
        icon: Icons.wb_sunny_rounded,
      ),
      const MedicationDose(
        id: '2',
        medicineName: 'Metformin',
        dosage: '500mg · 1 viên',
        scheduledTime: TimeOfDay(hour: 12, minute: 0),
        status: DoseStatus.upcoming,
        note: 'Uống sau ăn trưa 15 phút',
      ),
      const MedicationDose(
        id: '3',
        medicineName: 'Metformin',
        dosage: '500mg · 1 viên',
        scheduledTime: TimeOfDay(hour: 18, minute: 0),
        status: DoseStatus.pending,
      ),
      const MedicationDose(
        id: '4',
        medicineName: 'Omeprazole',
        dosage: '20mg · trước khi ngủ',
        scheduledTime: TimeOfDay(hour: 21, minute: 0),
        status: DoseStatus.pending,
        icon: Icons.nightlight_round,
      ),
    ];
  }

  void _markTaken(String id) {
    setState(() {
      final index = _doses.indexWhere((d) => d.id == id);
      if (index < 0) return;

      _doses[index] = _doses[index].copyWith(status: DoseStatus.taken);

      var foundUpcoming = false;
      _doses = _doses.map((d) {
        if (d.status == DoseStatus.upcoming) {
          foundUpcoming = true;
          return d;
        }
        if (!foundUpcoming &&
            d.status == DoseStatus.pending &&
            d.id != id) {
          foundUpcoming = true;
          return d.copyWith(status: DoseStatus.upcoming);
        }
        return d;
      }).toList();

      _staggerSeed++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Đã ghi nhận uống thuốc lúc ${_nowLabel()}')),
          ],
        ),
      ),
    );
  }

  String _nowLabel() {
    final now = TimeOfDay.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _onNavTap(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.familyLink);
      return;
    }
    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tính năng đang phát triển')),
      );
      return;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    var stagger = 0;
    final next = _nextDose;
    final profile = widget.profile;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      StaggeredEntrance(
                        index: stagger++,
                        child: HomeHeader(
                          displayName: _displayName,
                          dateLabel: _dateLabel,
                          onNotificationTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Không có thông báo mới'),
                              ),
                            );
                          },
                        ),
                      ),
                      if (profile != null &&
                          (profile.allergies.isNotEmpty ||
                              profile.bloodType != null)) ...[
                        const SizedBox(height: AppSpacing.md),
                        StaggeredEntrance(
                          index: stagger++,
                          child: _HealthAlertStrip(profile: profile),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      StaggeredEntrance(
                        index: stagger++,
                        child: TodayProgressCard(
                          takenCount: _takenCount,
                          totalCount: _doses.length,
                          streakDays: 5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      StaggeredEntrance(
                        key: ValueKey('next_$_staggerSeed'),
                        index: stagger++,
                        child: NextDoseHero(
                          dose: next,
                          onMarkTaken: next == null
                              ? () {}
                              : () => _markTaken(next.id),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      StaggeredEntrance(
                        index: stagger++,
                        child: const FamilySectionHeader(
                          title: 'Lịch uống hôm nay',
                          icon: Icons.medication_rounded,
                          accent: AppColors.primary,
                        ),
                      ),
                      ..._doses.map(
                        (d) => StaggeredEntrance(
                          key: ValueKey('dose_${d.id}_$_staggerSeed'),
                          index: stagger++,
                          child: MedicationDoseCard(
                            dose: d,
                            onMarkTaken: d.status == DoseStatus.taken ||
                                    d.status == DoseStatus.skipped
                                ? null
                                : () => _markTaken(d.id),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      StaggeredEntrance(
                        index: stagger++,
                        child: const FamilySectionHeader(
                          title: 'Truy cập nhanh',
                          icon: Icons.bolt_rounded,
                          accent: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      StaggeredEntrance(
                        index: stagger++,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            HomeQuickAction(
                              icon: Icons.add_circle_rounded,
                              label: 'Thêm thuốc',
                              gradient: AppColors.heroGradient,
                              onTap: () => _showComingSoon('Thêm thuốc'),
                            ),
                            HomeQuickAction(
                              icon: Icons.groups_rounded,
                              label: 'Người thân',
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.accent,
                                  AppColors.secondary,
                                ],
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.familyLink,
                              ),
                            ),
                            HomeQuickAction(
                              icon: Icons.health_and_safety_rounded,
                              label: 'Hồ sơ SK',
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.secondary,
                                  AppColors.primary,
                                ],
                              ),
                              onTap: () => _showComingSoon('Hồ sơ sức khỏe'),
                            ),
                            HomeQuickAction(
                              icon: Icons.history_rounded,
                              label: 'Lịch sử',
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.accentWarm,
                                  Color(0xFFEA580C),
                                ],
                              ),
                              onTap: () => _showComingSoon('Lịch sử uống thuốc'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HomeBottomNav(
              currentIndex: _navIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature — đang phát triển')),
    );
  }
}

class _HealthAlertStrip extends StatelessWidget {
  const _HealthAlertStrip({required this.profile});

  final HealthProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accentWarmSoft.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
        border: Border.all(
          color: AppColors.accentWarm.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.accentWarm),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String get _message {
    final parts = <String>[];
    if (profile.bloodType != null && profile.bloodType != 'Chưa rõ') {
      parts.add('Nhóm máu ${profile.bloodType}');
    }
    if (profile.allergies.isNotEmpty) {
      parts.add('Dị ứng: ${profile.allergies}');
    }
    return parts.join(' · ');
  }
}
