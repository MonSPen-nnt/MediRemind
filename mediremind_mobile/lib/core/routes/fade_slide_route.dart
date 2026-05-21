import 'package:flutter/material.dart';

import '../theme/app_animations.dart';

PageRoute<T> fadeSlideRoute<T>({
  required Widget page,
  required RouteSettings settings,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: AppAnimations.page,
    reverseTransitionDuration: AppAnimations.normal,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: AppAnimations.easeOut,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(curved),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}
