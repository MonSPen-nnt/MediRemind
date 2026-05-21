import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind_mobile/core/theme/app_animations.dart';

void main() {
  test('staggerInterval stays within 0..1 for many items', () {
    for (var total = 1; total <= 20; total++) {
      for (var index = 0; index < total; index++) {
        final bounds = AppAnimations.staggerInterval(index, total);
        expect(bounds.start, greaterThanOrEqualTo(0));
        expect(bounds.start, lessThanOrEqualTo(1));
        expect(bounds.end, greaterThanOrEqualTo(0));
        expect(bounds.end, lessThanOrEqualTo(1));
        expect(bounds.end, greaterThanOrEqualTo(bounds.start));
      }
    }
  });
}
