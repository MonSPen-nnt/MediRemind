import 'package:flutter/material.dart';

abstract final class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 700);
  static const Duration page = Duration(milliseconds: 450);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve bounce = Curves.elasticOut;

  /// Khoảng [start, end] cho Interval — luôn nằm trong [0, 1], không phụ thuộc số widget.
  static ({double start, double end}) staggerInterval(int index, int total) {
    if (total <= 1) return (start: 0, end: 1);

    const window = 0.7;
    const span = 0.3;
    final step = window / total;
    final start = (index * step).clamp(0.0, 1.0 - span);
    var end = (start + span).clamp(0.0, 1.0);
    if (end <= start) end = (start + 0.05).clamp(0.0, 1.0);
    return (start: start, end: end);
  }
}
