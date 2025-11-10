import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stage_data.dart';
import '../shared/constants/stage_configs.dart';
import '../services/storage_service.dart';

/// ステージ一覧を提供するプロバイダー
final stageListProvider = FutureProvider<List<StageData>>((ref) async {
  final storageService = ref.watch(storageServiceProvider);
  final stages = <StageData>[];

  for (final stage in StageConfigs.allStages) {
    final highScore = await storageService.getHighScore(stage.stageNumber);
    final highCombo = await storageService.getHighCombo(stage.stageNumber);

    stages.add(stage.copyWith(
      highScore: highScore,
      highCombo: highCombo,
    ));
  }

  return stages;
});

/// 特定のステージデータを提供するプロバイダー
final stageProvider = FutureProvider.family<StageData, int>((ref, stageNumber) async {
  final storageService = ref.watch(storageServiceProvider);
  final stage = StageConfigs.getStage(stageNumber);

  final highScore = await storageService.getHighScore(stageNumber);
  final highCombo = await storageService.getHighCombo(stageNumber);

  return stage.copyWith(
    highScore: highScore,
    highCombo: highCombo,
  );
});
