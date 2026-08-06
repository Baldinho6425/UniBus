import 'package:flutter_test/flutter_test.dart';

import 'package:unibus/app.dart';

void main() {
  testWidgets('App starts on the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const UniBusApp());
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsOneWidget);
  });
}
