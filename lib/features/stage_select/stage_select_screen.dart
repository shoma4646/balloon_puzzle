import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/stage_provider.dart';
import '../../shared/constants/app_colors.dart';
import '../game/game_screen.dart';
import 'widgets/stage_card.dart';

/// ステージ選択画面
class StageSelectScreen extends ConsumerWidget {
  const StageSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(stageListProvider);

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
          child: Column(
            children: [
              // ヘッダー
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // 戻るボタン
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textWhite,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'ステージ選択',
                      style: TextStyle(
                        fontSize: 28,
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
                  ],
                ),
              ),
              // ステージリスト
              Expanded(
                child: stagesAsync.when(
                  data: (stages) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: stages.length,
                      itemBuilder: (context, index) {
                        final stage = stages[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: StageCard(
                            stage: stage,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(
                                    stageData: stage,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.textWhite,
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      'エラーが発生しました: $error',
                      style: const TextStyle(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
