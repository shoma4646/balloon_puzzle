import 'package:flutter/material.dart';
import '../../../../core/domain/entities/stage_data.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/glass_container.dart';

/// ステージカードウィジェット
class StageCard extends StatelessWidget {
  final StageData stage;
  final VoidCallback onTap;

  const StageCard({
    super.key,
    required this.stage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 20,
      color: AppColors.glassWhite.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ステージ番号と難易度
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STAGE ${stage.stageNumber}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      shadows: [
                        Shadow(
                          color: AppColors.shadowColor,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  // 難易度表示（星）
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < stage.difficulty
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ステージ名
              Text(
                stage.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 5),
              // 説明
              Text(
                stage.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textWhite.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 15),
              // ハイスコア
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ハイスコア',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textWhite.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        stage.highScore.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '最高コンボ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textWhite.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        stage.highCombo.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  // プレイボタン
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: AppColors.textWhite,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
