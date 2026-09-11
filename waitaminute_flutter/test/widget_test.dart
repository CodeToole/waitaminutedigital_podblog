import 'package:flutter_test/flutter_test.dart';
import 'package:waitaminute_flutter/main.dart';

void main() {
  testWidgets('WaitaminuteApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WaitaminuteApp());
    expect(find.text('WAITAMINUTE'), findsOneWidget);
  });
}
