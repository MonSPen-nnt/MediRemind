import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Vòng sóng khi thành công — cảm giác hoàn thành cao cấp.
class SuccessBurst extends StatefulWidget {
  const SuccessBurst({super.key, required this.child});

  final Widget child;

  @override
  State<SuccessBurst> createState() => _SuccessBurstState();
}

class _SuccessBurstState extends State<SuccessBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            for (var i = 0; i < 3; i++)
              Transform.scale(
                scale: 0.6 + _c.value * (0.5 + i * 0.25),
                child: Opacity(
                  opacity: (1 - _c.value) * (0.35 - i * 0.08),
                  child: Container(
                    width: 120 + i * 24,
                    height: 120 + i * 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }
}
