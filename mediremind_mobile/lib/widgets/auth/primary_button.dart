import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_theme.dart';
import '../common/animated_pressable.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shine;

  @override
  void initState() {
    super.initState();
    _shine = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _shine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        );

    return AnimatedPressable(
      enabled: !widget.isLoading && widget.onPressed != null,
      onPressed: widget.onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
        child: Container(
          width: double.infinity,
          height: AppTheme.minTouchTarget,
          decoration: AppDecorations.primaryButton,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _shine,
                builder: (context, _) {
                  return Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(
                        -200 + _shine.value * 400,
                        0,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.buttonShine,
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (widget.isLoading)
                const SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 24),
                      const SizedBox(width: 10),
                    ],
                    Text(widget.label, style: labelStyle),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
