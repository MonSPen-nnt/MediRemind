import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/family_member.dart';
import '../common/animated_pressable.dart';

class FamilyMemberCard extends StatefulWidget {
  const FamilyMemberCard({
    super.key,
    required this.member,
    required this.onTap,
    this.onAccept,
    this.onDecline,
  });

  final FamilyMember member;
  final VoidCallback onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  State<FamilyMemberCard> createState() => _FamilyMemberCardState();
}

class _FamilyMemberCardState extends State<FamilyMemberCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _glow;

  @override
  void initState() {
    super.initState();
    if (widget.member.status == FamilyLinkStatus.incoming) {
      _glow = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glow?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.member;
    final isIncoming = m.status == FamilyLinkStatus.incoming;
    final isPending = m.status == FamilyLinkStatus.pending;

    Widget card = AnimatedPressable(
      onPressed: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
          boxShadow: [
            BoxShadow(
              color: (isIncoming ? AppColors.accent : AppColors.primary)
                  .withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
          child: Stack(
            children: [
              if (isIncoming)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.06),
                          AppColors.primaryLight.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  border: Border.all(
                    color: isIncoming
                        ? AppColors.accent.withValues(alpha: 0.45)
                        : isPending
                            ? AppColors.accentWarm.withValues(alpha: 0.4)
                            : AppColors.border,
                    width: isIncoming || isPending ? 2 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _Avatar(initials: m.initials, status: m.status),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontSize: 20),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  m.relationship,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.primaryDark,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_rounded,
                                    size: 16,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    m.phone,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _StatusBadge(status: m.status),
                      ],
                    ),
                    if (isIncoming &&
                        widget.onAccept != null &&
                        widget.onDecline != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: widget.onDecline,
                              icon: const Icon(Icons.close_rounded, size: 20),
                              label: const Text('Từ chối'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: widget.onAccept,
                              icon: const Icon(Icons.check_rounded, size: 20),
                              label: const Text('Chấp nhận'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (isPending) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _PendingBar(),
                    ] else ...[
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (m.canViewSchedule)
                            _PermChip(
                              label: 'Xem lịch',
                              icon: Icons.calendar_month_rounded,
                            ),
                          if (m.canReceiveAlerts)
                            _PermChip(
                              label: 'Cảnh báo',
                              icon: Icons.notifications_active_rounded,
                            ),
                          if (m.canEditSchedule)
                            _PermChip(
                              label: 'Chỉnh lịch',
                              icon: Icons.edit_calendar_rounded,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (_glow != null) {
      card = AnimatedBuilder(
        animation: _glow!,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent
                      .withValues(alpha: 0.15 + _glow!.value * 0.2),
                  blurRadius: 20 + _glow!.value * 12,
                ),
              ],
            ),
            child: child,
          );
        },
        child: card,
      );
    }

    return card;
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.status});

  final String initials;
  final FamilyLinkStatus status;

  @override
  Widget build(BuildContext context) {
    final gradient = switch (status) {
      FamilyLinkStatus.linked => AppColors.heroGradient,
      FamilyLinkStatus.pending => const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        ),
      FamilyLinkStatus.incoming => const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF0891B2)],
        ),
    };

    return Container(
      width: 62,
      height: 62,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: AppDecorations.softShadow,
      ),
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final FamilyLinkStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (status) {
      FamilyLinkStatus.linked => (
          'Đã liên kết',
          AppColors.success,
          Icons.link_rounded,
        ),
      FamilyLinkStatus.pending => (
          'Chờ xác nhận',
          AppColors.accentWarm,
          Icons.hourglass_top_rounded,
        ),
      FamilyLinkStatus.incoming => (
          'Lời mời mới',
          AppColors.accent,
          Icons.mail_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PendingBar extends StatefulWidget {
  @override
  State<_PendingBar> createState() => _PendingBarState();
}

class _PendingBarState extends State<_PendingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đang chờ người thân xác nhận...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.accentWarm,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: 0.3 + (_c.value * 0.5),
                minHeight: 6,
                backgroundColor: AppColors.accentWarmSoft,
                color: AppColors.accentWarm,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PermChip extends StatelessWidget {
  const _PermChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.8),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
