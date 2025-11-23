import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/presentation/theme/app_theme.dart';
import 'features/title/presentation/screens/title_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Puzzle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const TitleScreen(),
    );
  }
}
