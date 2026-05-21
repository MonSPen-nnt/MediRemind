import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Nền mesh gradient + orbs mờ chuyển động chậm.
class AuthBackground extends StatefulWidget {
  const AuthBackground({super.key, this.animate = true});

  final bool animate;

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _controller?.value ?? 0.0;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _BlurredOrb(
            size: 280,
            top: -80 + t * 24,
            right: -70,
            colors: [
              AppColors.primary.withValues(alpha: 0.35),
              AppColors.accent.withValues(alpha: 0.2),
            ],
          ),
          _BlurredOrb(
            size: 220,
            bottom: 60 - t * 20,
            left: -60,
            colors: [
              AppColors.secondary.withValues(alpha: 0.28),
              AppColors.accentSoft.withValues(alpha: 0.4),
            ],
          ),
          _BlurredOrb(
            size: 140,
            top: 220 + t * 12,
            left: 40,
            colors: [
              AppColors.accentWarm.withValues(alpha: 0.25),
              AppColors.primaryLight.withValues(alpha: 0.5),
            ],
          ),
          // Lưới chấm tinh tế
          CustomPaint(painter: _DotGridPainter()),
        ],
      ),
    );
  }
}

class _BlurredOrb extends StatelessWidget {
  const _BlurredOrb({
    required this.size,
    required this.colors,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final double size;
  final List<Color> colors;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: colors),
          ),
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      for (var y = 0.0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pulse nhẹ cho logo Welcome.
class PulsingLogo extends StatefulWidget {
  const PulsingLogo({super.key, required this.child});

  final Widget child;

  @override
  State<PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<PulsingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + math.sin(_controller.value * math.pi) * 0.035;
        return Transform.scale(scale: scale, child: child);
      },
      child: widget.child,
    );
  }
}
