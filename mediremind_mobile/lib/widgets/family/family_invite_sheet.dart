import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../auth/primary_button.dart';
import '../common/staggered_entrance.dart';

/// Mời liên kết bằng mã / QR — UI demo với animation cao cấp.
class FamilyInviteSheet extends StatefulWidget {
  const FamilyInviteSheet({super.key});

  static const _demoCode = 'MEDI-8K2F';
  static const _demoLink = 'https://mediremind.app/invite/MEDI-8K2F';

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FamilyInviteSheet(),
    );
  }

  @override
  State<FamilyInviteSheet> createState() => _FamilyInviteSheetState();
}

class _FamilyInviteSheetState extends State<FamilyInviteSheet>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _shimmer;
  late final AnimationController _ring;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
    _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _shimmer.dispose();
    _ring.dispose();
    super.dispose();
  }

  void _copy(String text, String msg) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text(msg),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var stagger = 0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  AppColors.backgroundBottom,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDecorations.radiusXl + 4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 40,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                StaggeredEntrance(
                  index: stagger++,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (b) =>
                            AppColors.titleGradient.createShader(b),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          'Mời người thân liên kết',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Chia sẻ mã hoặc quét QR để kết nối trong vài giây',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                StaggeredEntrance(
                  index: stagger++,
                  child: _QrShowcase(
                    pulse: _pulse,
                    shimmer: _shimmer,
                    ring: _ring,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                StaggeredEntrance(
                  index: stagger++,
                  child: _CodeDisplay(code: FamilyInviteSheet._demoCode),
                ),
                const SizedBox(height: AppSpacing.md),
                StaggeredEntrance(
                  index: stagger++,
                  child: PrimaryButton(
                    label: 'Sao chép mã mời',
                    icon: Icons.copy_all_rounded,
                    onPressed: () => _copy(
                      FamilyInviteSheet._demoCode,
                      'Đã sao chép mã mời',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                StaggeredEntrance(
                  index: stagger++,
                  child: OutlinedButton.icon(
                    onPressed: () => _copy(
                      FamilyInviteSheet._demoLink,
                      'Đã sao chép liên kết',
                    ),
                    icon: const Icon(Icons.link_rounded),
                    label: const Text('Sao chép liên kết mời'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 58),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                StaggeredEntrance(
                  index: stagger++,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Mã có hiệu lực 24 giờ (demo UI)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QrShowcase extends StatelessWidget {
  const _QrShowcase({
    required this.pulse,
    required this.shimmer,
    required this.ring,
  });

  final Animation<double> pulse;
  final Animation<double> shimmer;
  final Animation<double> ring;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([pulse, shimmer, ring]),
      builder: (_, __) {
        final scale = 1 + pulse.value * 0.04;
        final ringScale = 1 + ring.value * 0.15;

        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: ringScale,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(
                      alpha: 0.12 * (1 - ring.value),
                    ),
                    width: 2,
                  ),
                ),
              ),
            ),
            Transform.scale(
              scale: scale,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment(-1 + shimmer.value * 2, -1),
                    end: Alignment(1 + shimmer.value * 2, 1),
                    colors: [
                      AppColors.primaryLight,
                      Colors.white,
                      AppColors.accentSoft,
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(160, 160),
                      painter: _MockQrPainter(shimmer.value),
                    ),
                    Positioned(
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'MediRemind',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CodeDisplay extends StatelessWidget {
  const _CodeDisplay({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primarySoft,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Mã mời của bạn',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 40,
                  letterSpacing: 6,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ],
      ),
    );
  }
}

class _MockQrPainter extends CustomPainter {
  _MockQrPainter(this.phase);

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(42);
    final cell = size.width / 11;
    final paint = Paint()..style = PaintingStyle.fill;

    for (var row = 0; row < 11; row++) {
      for (var col = 0; col < 11; col++) {
        if (row < 3 && col < 3) continue;
        if (row < 3 && col > 7) continue;
        if (row > 7 && col < 3) continue;
        if (rnd.nextBool()) {
          final alpha = 0.7 + 0.3 * math.sin(phase * math.pi * 2 + row + col);
          paint.color = AppColors.textPrimary.withValues(alpha: alpha);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(col * cell + 1, row * cell + 1, cell - 2, cell - 2),
              const Radius.circular(2),
            ),
            paint,
          );
        }
      }
    }

    void drawFinder(Offset origin) {
      paint.color = AppColors.primary;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(origin.dx, origin.dy, cell * 3, cell * 3),
          const Radius.circular(4),
        ),
        paint,
      );
      paint.color = Colors.white;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            origin.dx + cell * 0.6,
            origin.dy + cell * 0.6,
            cell * 1.8,
            cell * 1.8,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      paint.color = AppColors.primary;
      canvas.drawRect(
        Rect.fromLTWH(
          origin.dx + cell * 1.1,
          origin.dy + cell * 1.1,
          cell * 0.8,
          cell * 0.8,
        ),
        paint,
      );
    }

    drawFinder(Offset.zero);
    drawFinder(Offset(cell * 8, 0));
    drawFinder(Offset(0, cell * 8));
  }

  @override
  bool shouldRepaint(covariant _MockQrPainter old) => old.phase != phase;
}
