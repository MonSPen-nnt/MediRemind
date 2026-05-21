import 'package:flutter/material.dart';

import '../../core/theme/app_animations.dart';

/// Nút có hiệu ứng nhấn thu nhỏ nhẹ.
class AnimatedPressable extends StatefulWidget {
  const AnimatedPressable({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool enabled;

  @override
  State<AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<AnimatedPressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: AppAnimations.fast,
        curve: AppAnimations.easeOut,
        child: widget.child,
      ),
    );
  }
}
