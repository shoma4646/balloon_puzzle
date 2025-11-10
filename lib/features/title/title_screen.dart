import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import '../stage_select/stage_select_screen.dart';

/// タイトル画面
class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundSkyLight,
              AppColors.backgroundSky,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // タイトルロゴ
                const Text(
                  '🎈',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Balloon Puzzle',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                    shadows: [
                      Shadow(
                        color: AppColors.shadowColor,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '風船パズルゲーム',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textWhite,
                    shadows: [
                      Shadow(
                        color: AppColors.shadowColor,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                // STARTボタン
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StageSelectScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text('START'),
                ),
                const SizedBox(height: 20),
                // 設定ボタン
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: 設定画面に遷移
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('設定画面は実装中です'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings, color: AppColors.textWhite),
                  label: const Text(
                    '設定',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    side: const BorderSide(
                      color: AppColors.textWhite,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
