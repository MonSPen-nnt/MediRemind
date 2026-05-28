import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/family_member.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/primary_button.dart';
import '../../widgets/common/staggered_entrance.dart';
import '../../widgets/family/family_hero_banner.dart';
import '../../widgets/family/family_invite_sheet.dart';
import '../../widgets/family/family_member_card.dart';
import '../../widgets/family/family_quick_action_tile.dart';
import '../../widgets/family/family_section_header.dart';

class FamilyLinkScreen extends StatefulWidget {
  const FamilyLinkScreen({super.key});

  @override
  State<FamilyLinkScreen> createState() => _FamilyLinkScreenState();
}

class _FamilyLinkScreenState extends State<FamilyLinkScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fabEnter;
  late List<FamilyMember> _members;
  int _staggerSeed = 0;

  @override
  void initState() {
    super.initState();
    _members = [
      const FamilyMember(
        id: '1',
        name: 'Nguyễn Thị Lan',
        relationship: 'Con gái',
        phone: '0901 234 567',
        status: FamilyLinkStatus.linked,
        canViewSchedule: true,
        canReceiveAlerts: true,
      ),
      const FamilyMember(
        id: '2',
        name: 'Trần Văn Minh',
        relationship: 'Con trai',
        phone: '0918 888 999',
        status: FamilyLinkStatus.pending,
      ),
      const FamilyMember(
        id: '3',
        name: 'Phạm Thu Hà',
        relationship: 'Vợ',
        phone: '0987 654 321',
        status: FamilyLinkStatus.incoming,
        canViewSchedule: true,
        canReceiveAlerts: true,
        canEditSchedule: true,
      ),
    ];
    _fabEnter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _fabEnter.dispose();
    super.dispose();
  }

  List<FamilyMember> get _linked =>
      _members.where((m) => m.status == FamilyLinkStatus.linked).toList();

  List<FamilyMember> get _pending => _members
      .where(
        (m) =>
            m.status == FamilyLinkStatus.pending ||
            m.status == FamilyLinkStatus.incoming,
      )
      .toList();

  void _acceptInvite(FamilyMember m) {
    setState(() {
      final i = _members.indexWhere((e) => e.id == m.id);
      if (i >= 0) {
        _members[i] = FamilyMember(
          id: m.id,
          name: m.name,
          relationship: m.relationship,
          phone: m.phone,
          status: FamilyLinkStatus.linked,
          canViewSchedule: m.canViewSchedule,
          canReceiveAlerts: m.canReceiveAlerts,
          canEditSchedule: m.canEditSchedule,
        );
      }
      _staggerSeed++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.celebration_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Đã liên kết với ${m.name}')),
          ],
        ),
      ),
    );
  }

  void _declineInvite(FamilyMember m) {
    setState(() {
      _members.removeWhere((e) => e.id == m.id);
      _staggerSeed++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã từ chối lời mời')),
    );
  }

  @override
  Widget build(BuildContext context) {
    var stagger = 0;
    int nextStagger() => stagger++;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildAppBar(context)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      StaggeredEntrance(
                        key: ValueKey('hero_$_staggerSeed'),
                        index: nextStagger(),
                        child: FamilyHeroBanner(
                          linkedCount: _linked.length,
                          pendingCount: _pending.length,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      StaggeredEntrance(
                        key: ValueKey('actions_$_staggerSeed'),
                        index: nextStagger(),
                        child: _buildQuickActions(context),
                      ),
                      if (_pending.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        StaggeredEntrance(
                          index: nextStagger(),
                          child: FamilySectionHeader(
                            title: 'Lời mời & chờ xác nhận',
                            icon: Icons.mark_email_unread_rounded,
                            accent: AppColors.accent,
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentSoft,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_pending.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ..._pending.map(
                          (m) => StaggeredEntrance(
                            key: ValueKey('p_${m.id}_$_staggerSeed'),
                            index: nextStagger(),
                            child: FamilyMemberCard(
                              member: m,
                              onTap: () => _openDetail(m),
                              onAccept: m.status == FamilyLinkStatus.incoming
                                  ? () => _acceptInvite(m)
                                  : null,
                              onDecline: m.status == FamilyLinkStatus.incoming
                                  ? () => _declineInvite(m)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      StaggeredEntrance(
                        index: nextStagger(),
                        child: FamilySectionHeader(
                          title: 'Đã liên kết',
                          icon: Icons.family_restroom_rounded,
                          accent: AppColors.primary,
                          trailing: Text(
                            '${_linked.length} người',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      if (_linked.isEmpty)
                        StaggeredEntrance(
                          index: nextStagger(),
                          child: _buildEmptyLinked(context),
                        )
                      else
                        ..._linked.map(
                          (m) => StaggeredEntrance(
                            key: ValueKey('l_${m.id}_$_staggerSeed'),
                            index: nextStagger(),
                            child: FamilyMemberCard(
                              member: m,
                              onTap: () => _openDetail(m),
                            ),
                          ),
                        ),
                      const SizedBox(height: 110),
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
            child: _buildFloatingBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 4),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => AppColors.titleGradient.createShader(b),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'Liên kết người thân',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Text(
                  'Gắn kết gia đình, an tâm mỗi ngày',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
          _GlassIconButton(
            icon: Icons.qr_code_scanner_rounded,
            onTap: () => FamilyInviteSheet.show(context),
            highlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FamilyQuickActionTile(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Thêm SĐT',
              subtitle: 'Mời qua số điện thoại',
              gradient: AppColors.heroGradient,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.addFamilyMember,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FamilyQuickActionTile(
              icon: Icons.qr_code_2_rounded,
              label: 'Mã / QR',
              subtitle: 'Chia sẻ mã mời nhanh',
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => FamilyInviteSheet.show(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyLinked(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_alt_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Chưa có người thân',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Bắt đầu bằng cách thêm SĐT hoặc chia sẻ mã mời',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBar(BuildContext context) {
    return SlideTransition(
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
          child: PrimaryButton(
            label: 'Thêm người thân',
            icon: Icons.add_rounded,
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.addFamilyMember,
            ),
          ),
        ),
      ),
    );
  }

  void _openDetail(FamilyMember member) {
    Navigator.pushNamed(
      context,
      AppRoutes.familyMemberDetail,
      arguments: member,
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlight
          ? AppColors.primary.withValues(alpha: 0.15)
          : Colors.white.withValues(alpha: 0.6),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            size: highlight ? 26 : 22,
            color: highlight ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
