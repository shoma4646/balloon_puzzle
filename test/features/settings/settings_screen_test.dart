import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:balloon_puzzle/features/settings/presentation/screens/settings_screen.dart';
import 'package:balloon_puzzle/core/presentation/theme/app_theme.dart';

import 'package:balloon_puzzle/core/services/audio_service.dart';

void main() {
  setUp(() {
    AudioService().isTestMode = true;
  });

  testWidgets('SettingsScreen smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({
      'bgm_volume': 0.5,
      'se_volume': 0.8,
    });

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SettingsScreen(),
        ),
      ),
    );

    // AnimatedBackground has infinite animation
    await tester.pump(const Duration(seconds: 1));

    // Verify title
    expect(find.text('SETTINGS'), findsOneWidget);

    // Verify sliders exist
    expect(find.text('BGM Volume'), findsOneWidget);
    expect(find.text('SE Volume'), findsOneWidget);
    expect(find.byType(Slider), findsNWidgets(2));

    // Verify back button
    expect(find.text('BACK'), findsOneWidget);

    // Test interaction (Back button)
    await tester.tap(find.text('BACK'));
    await tester.pumpAndSettle();

    // Since we pushed SettingsScreen as 'home', popping it might close the app or do nothing in test env if no navigator history.
    // But we just want to ensure the button is tappable.
  });
}
