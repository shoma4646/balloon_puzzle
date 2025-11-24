// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balloon_puzzle/features/title/presentation/screens/title_screen.dart';
import 'package:balloon_puzzle/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:balloon_puzzle/core/services/audio_service.dart';

void main() {
  setUp(() {
    AudioService().isTestMode = true;
  });

  testWidgets('TitleScreen smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );
    // AnimatedBackground has an infinite animation, so pumpAndSettle will time out.
    // We pump for a specific duration to allow FutureBuilder to complete.
    await tester.pump(const Duration(seconds: 2));

    // Verify that TitleScreen is built
    expect(find.byType(TitleScreen), findsOneWidget);

    // Verify that START button is displayed
    expect(find.text('GAME START'), findsOneWidget);

    // Verify that our title is displayed.
    // Using exact match for multi-line text
    expect(find.text('Balloon\nPuzzle'), findsOneWidget);
  });
}
