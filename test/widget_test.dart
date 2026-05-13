import 'package:flutter_test/flutter_test.dart';

import 'package:test_task_evencir/main.dart';

void main() {
  testWidgets('Splash then bottom nav with four tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Nutrition'), findsWidgets);
    expect(find.text('Plan'), findsWidgets);
    expect(find.text('Mood'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);

    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Training Calendar'), findsOneWidget);

    await tester.tap(find.text('Mood'));
    await tester.pumpAndSettle();
    expect(find.textContaining('check-ins'), findsOneWidget);
  });
}
