import 'package:flutter/material.dart';
import '../../../shared/constants/app_colors.dart';

/// ゲームのHUD（スコア、時間表示）
class GameHud extends StatelessWidget {
  final int score;
  final double elapsedTime;
  final VoidCallback onPause;

  const GameHud({
    super.key,
    required this.score,
    required this.elapsedTime,
    required this.onPause,
  });

  String _formatTime(double seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.overlayDark.withOpacity(0.7),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
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
                  const Text(
                    'SCORE',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    score.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
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
                  const Text(
                    'TIME',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(elapsedTime),
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
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
