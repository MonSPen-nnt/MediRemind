import 'package:flutter/material.dart';

import '../../core/theme/app_animations.dart';

/// Xuất hiện lần lượt — fade + slide + scale nhẹ.
class StaggeredEntrance extends StatefulWidget {
  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.delayPerItem = const Duration(milliseconds: 80),
  });

  final int index;
  final Widget child;
  final Duration delayPerItem;

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _anim = CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut);
    Future<void>.delayed(widget.delayPerItem * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final t = _anim.value;
        return Transform.translate(
          offset: Offset(0, 36 * (1 - t)),
          child: Transform.scale(
            scale: 0.92 + 0.08 * t,
            child: Opacity(opacity: t, child: child),
          ),
        );
      },
      child: widget.child,
    );
  }
}
