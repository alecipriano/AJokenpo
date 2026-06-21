import 'package:flutter_test/flutter_test.dart';
import 'package:jokenpo/main.dart';

void main() {
  testWidgets('Jokenpo smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JokenpoApp());

    // Verify that the title is displayed.
    expect(find.text('JOKENPÔ'), findsOneWidget);
    expect(find.text('DESAFIE A MÁQUINA'), findsOneWidget);
    expect(find.text('SUA ESCOLHA:'), findsOneWidget);
  });
}
