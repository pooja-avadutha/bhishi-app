import 'package:flutter_test/flutter_test.dart';
import 'package:bhishi_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BhishiApp());

    // Verify that the login screen is shown (Bhishi Manager text)
    expect(find.text('Bhishi Manager'), findsWidgets);
  });
}
