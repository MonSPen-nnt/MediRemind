import 'package:flutter/material.dart';

import '../../core/theme/app_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/family_member.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/primary_button.dart';
import '../../widgets/auth/secondary_button.dart';
import '../../widgets/common/glass_surface.dart';
import '../../widgets/common/staggered_entrance.dart';
import '../../widgets/family/family_section_header.dart';
import '../../widgets/family/permission_toggle_card.dart';

class FamilyMemberDetailScreen extends StatefulWidget {
  const FamilyMemberDetailScreen({super.key, required this.member});

  final FamilyMember member;

  @override
  State<FamilyMemberDetailScreen> createState() =>
      _FamilyMemberDetailScreenState();
}

class _FamilyMemberDetailScreenState extends State<FamilyMemberDetailScreen>
    with TickerProviderStateMixin {
  late bool _canView;
  late bool _canAlert;
  late bool _canEdit;
  late final AnimationController _avatarPulse;
  late final AnimationController _fabEnter;

  @override
  void initState() {
    super.initState();
    _canView = widget.member.canViewSchedule;
    _canAlert = widget.member.canReceiveAlerts;
    _canEdit = widget.member.canEditSchedule;
    _avatarPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _fabEnter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _avatarPulse.dispose();
    _fabEnter.dispose();
    super.dispose();
  }

  Future<void> _confirmUnlink() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
        ),
        title: Row(
          children: [
            Icon(Icons.link_off_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            const Text('Hủy liên kết?'),
          ],
        ),
        content: Text(
          'Bạn có chắc muốn hủy liên kết với ${widget.member.name}? '
          'Người này sẽ không xem được lịch uống thuốc của bạn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Giữ lại'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hủy liên kết'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã hủy liên kết ${widget.member.name}')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.member;
    final theme = Theme.of(context);
    var stagger = 0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            child: Column(
              children: [
                StaggeredEntrance(
                  index: stagger++,
                  child: _buildAppBar(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 130),
                    child: Column(
                      children: [
                        StaggeredEntrance(
                          index: stagger++,
                          child: GlassSurface(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              children: [
                                AnimatedBuilder(
                                  animation: _avatarPulse,
                                  builder: (_, __) {
                                    final glow =
                                        0.15 + _avatarPulse.value * 0.15;
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: glow),
                                            blurRadius: 24 +
                                                _avatarPulse.value * 12,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        width: 96,
                                        height: 96,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.heroGradient,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                        ),
                                        child: Text(
                                          m.initials,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 34,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  m.name,
                                  style:
                                      theme.textTheme.headlineLarge?.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primarySoft,
                                        Colors.white,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Text(
                                    m.relationship,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundBottom,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.phone_rounded,
                                        size: 20,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        m.phone,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _StatusPill(status: m.status),
                              ],
                            ),
                          ),
                        ),
                        if (m.status == FamilyLinkStatus.linked) ...[
                          const SizedBox(height: AppSpacing.md),
                          StaggeredEntrance(
                            index: stagger++,
                            child: GlassSurface(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FamilySectionHeader(
                                    title: 'Quyền truy cập',
                                    icon: Icons.tune_rounded,
                                    accent: AppColors.primary,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  PermissionToggleCard(
                                    title: 'Xem lịch uống thuốc',
                                    subtitle: 'Theo dõi giờ uống hàng ngày',
                                    icon: Icons.calendar_month_outlined,
                                    value: _canView,
                                    onChanged: (v) =>
                                        setState(() => _canView = v),
                                  ),
                                  PermissionToggleCard(
                                    title: 'Nhận cảnh báo',
                                    subtitle: 'Khi quên uống hoặc trễ giờ',
                                    icon: Icons.notifications_active_outlined,
                                    value: _canAlert,
                                    tint: AppColors.accentWarm,
                                    onChanged: (v) =>
                                        setState(() => _canAlert = v),
                                  ),
                                  PermissionToggleCard(
                                    title: 'Chỉnh sửa lịch',
                                    subtitle: 'Thêm / sửa nhắc nhở',
                                    icon: Icons.edit_calendar_outlined,
                                    value: _canEdit,
                                    tint: AppColors.accent,
                                    onChanged: (v) =>
                                        setState(() => _canEdit = v),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  PrimaryButton(
                                    label: 'Lưu thay đổi',
                                    icon: Icons.save_rounded,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Đã lưu quyền truy cập'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (m.status == FamilyLinkStatus.linked)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _fabEnter,
                  curve: AppAnimations.easeOut,
                )),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundBottom.withValues(alpha: 0),
                        AppColors.backgroundBottom.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SecondaryButton(
                      label: 'Hủy liên kết',
                      onPressed: _confirmUnlink,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.6),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ShaderMask(
              shaderCallback: (b) => AppColors.titleGradient.createShader(b),
              blendMode: BlendMode.srcIn,
              child: Text(
                'Chi tiết người thân',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final FamilyLinkStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (status) {
      FamilyLinkStatus.linked => (
          'Đã liên kết',
          AppColors.success,
          Icons.verified_rounded,
        ),
      FamilyLinkStatus.pending => (
          'Chờ xác nhận',
          AppColors.accentWarm,
          Icons.hourglass_top_rounded,
        ),
      FamilyLinkStatus.incoming => (
          'Lời mời đang chờ',
          AppColors.accent,
          Icons.mail_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: color,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
