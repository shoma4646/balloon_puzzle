import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/glass_container.dart';

/// ゲームのHUD（スコア、時間表示）
class GameHud extends StatelessWidget {
  final int score;
  final double elapsedTime;
  final int comboCount;
  final VoidCallback onPause;

  const GameHud({
    super.key,
    required this.score,
    required this.elapsedTime,
    this.comboCount = 0,
    required this.onPause,
  });

  String _formatTime(double seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderRadius: 15,
      color: AppColors.glassWhite.withOpacity(0.05),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // スコア
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SCORE',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textWhite.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    score.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: AppColors.primary,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // コンボ表示（2コンボ以上で表示）
            if (comboCount > 1)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'COMBO',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.yellow.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$comboCount',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.orange,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // 時間
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TIME',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textWhite.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(elapsedTime),
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: AppColors.secondary,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // 一時停止ボタン
            IconButton(
              onPressed: onPause,
              icon: const Icon(
                Icons.pause_circle_filled,
                color: AppColors.textWhite,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
