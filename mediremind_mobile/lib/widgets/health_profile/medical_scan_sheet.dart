import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/medical_scan_result.dart';
import '../auth/primary_button.dart';
import '../common/glass_surface.dart';

/// Màn quét tài liệu y tế — UI mock (chưa tích hợp camera/OCR thật).
class MedicalScanSheet extends StatefulWidget {
  const MedicalScanSheet({super.key, required this.onApply});

  final ValueChanged<MedicalScanResult> onApply;

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<MedicalScanResult> onApply,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      transitionDuration: AppAnimations.page,
      pageBuilder: (_, __, ___) => MedicalScanSheet(onApply: onApply),
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: AppAnimations.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(
              CurvedAnimation(parent: animation, curve: AppAnimations.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<MedicalScanSheet> createState() => _MedicalScanSheetState();
}

enum _ScanPhase { preview, processing, result }

class _MedicalScanSheetState extends State<MedicalScanSheet>
    with TickerProviderStateMixin {
  _ScanPhase _phase = _ScanPhase.preview;
  late final AnimationController _scanLine;
  late final AnimationController _pulse;
  MedicalScanResult? _result;

  @override
  void initState() {
    super.initState();
    _scanLine = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLine.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() => _phase = _ScanPhase.processing);
    await Future<void>.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;
    setState(() {
      _phase = _ScanPhase.result;
      _result = const MedicalScanResult(
        bloodType: 'O+',
        conditions: ['Cao huyết áp'],
        allergies: ['Penicillin'],
      );
    });
  }

  void _apply() {
    if (_result != null) {
      widget.onApply(_result!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildBody()),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          ),
          Expanded(
            child: Text(
              _phase == _ScanPhase.result
                  ? 'Kết quả quét'
                  : 'Quét hồ sơ / đơn thuốc',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: AppAnimations.easeOut,
      child: switch (_phase) {
        _ScanPhase.preview => _buildPreview(key: const ValueKey('preview')),
        _ScanPhase.processing =>
          _buildProcessing(key: const ValueKey('processing')),
        _ScanPhase.result => _buildResult(key: const ValueKey('result')),
      },
    );
  }

  Widget _buildPreview({required Key key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      ),
                    ),
                  ),
                  CustomPaint(painter: _ViewfinderPainter()),
                  AnimatedBuilder(
                    animation: _scanLine,
                    builder: (_, __) {
                      return Align(
                        alignment: Alignment(0, -1 + _scanLine.value * 2),
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 36),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.primary.withValues(alpha: 0.9),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.6),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) {
                        final s = 1 + math.sin(_pulse.value * math.pi) * 0.08;
                        return Transform.scale(
                          scale: s,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: const Icon(
                              Icons.document_scanner_rounded,
                              color: Colors.white70,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Đặt đơn thuốc hoặc sổ khám bệnh\nvào khung hình',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  height: 1.45,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Demo UI — OCR thật sẽ được tích hợp sau',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryLight,
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProcessing({required Key key}) {
    return Center(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Đang nhận diện thông tin...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhóm máu · Bệnh nền · Dị ứng',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white54,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult({required Key key}) {
    final r = _result!;
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 56),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Đã nhận diện xong!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassSurface(
            padding: const EdgeInsets.all(20),
            blur: 12,
            child: Column(
              children: [
                _ResultRow(
                  icon: Icons.bloodtype_rounded,
                  label: 'Nhóm máu',
                  value: r.bloodType ?? '—',
                  tint: AppColors.error,
                ),
                _ResultRow(
                  icon: Icons.medical_information_outlined,
                  label: 'Bệnh nền',
                  value: r.conditions.isEmpty
                      ? 'Không phát hiện'
                      : r.conditions.join(', '),
                  tint: AppColors.secondary,
                ),
                _ResultRow(
                  icon: Icons.warning_amber_rounded,
                  label: 'Dị ứng',
                  value: r.allergies.isEmpty
                      ? 'Không phát hiện'
                      : r.allergies.join(', '),
                  tint: AppColors.accentWarm,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Bạn có thể chỉnh sửa lại sau khi áp dụng',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white54,
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
      child: switch (_phase) {
        _ScanPhase.preview => PrimaryButton(
            label: 'Chụp & quét ngay',
            icon: Icons.camera_alt_rounded,
            onPressed: _startScan,
          ),
        _ScanPhase.processing => const SizedBox.shrink(),
        _ScanPhase.result => PrimaryButton(
            label: 'Áp dụng vào hồ sơ',
            icon: Icons.check_rounded,
            onPressed: _apply,
          ),
      },
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.tint,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tint, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
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

class _ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.85)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const len = 28.0;
    const pad = 32.0;
    final w = size.width;
    final h = size.height;

    void corner(Offset o, bool top, bool left) {
      final dx = left ? 1 : -1;
      final dy = top ? 1 : -1;
      canvas.drawLine(o, o + Offset(dx * len, 0), paint);
      canvas.drawLine(o, o + Offset(0, dy * len), paint);
    }

    corner(const Offset(pad, pad), true, true);
    corner(Offset(w - pad, pad), true, false);
    corner(Offset(pad, h - pad), false, true);
    corner(Offset(w - pad, h - pad), false, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
