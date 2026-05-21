import 'package:flutter/material.dart';

import '../../core/theme/app_animations.dart';

class AnimatedAuthBody extends StatefulWidget {
  const AnimatedAuthBody({super.key, required this.children});

  final List<Widget> children;

  @override
  State<AnimatedAuthBody> createState() => _AnimatedAuthBodyState();
}

class _AnimatedAuthBodyState extends State<AnimatedAuthBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500 + widget.children.length * 80,
      ),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.children.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(total, (index) {
        final bounds = AppAnimations.staggerInterval(index, total);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = Interval(
              bounds.start,
              bounds.end,
              curve: AppAnimations.easeOut,
            ).transform(_controller.value);
            final slide = Curves.easeOutBack.transform(t.clamp(0.0, 1.2));
            return Transform.translate(
              offset: Offset(0, 32 * (1 - slide)),
              child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
            );
          },
          child: widget.children[index],
        );
      }),
    );
  }
}
