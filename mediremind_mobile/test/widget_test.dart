import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind_mobile/main.dart';

void main() {
  testWidgets('Welcome screen shows branding', (WidgetTester tester) async {
    await tester.pumpWidget(const MediRemindApp());
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('MediRemind'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Tạo tài khoản mới'), findsOneWidget);
  });

  testWidgets('Welcome navigates to login', (WidgetTester tester) async {
    await tester.pumpWidget(const MediRemindApp());
    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Chào mừng trở lại'), findsOneWidget);
  });
}
