import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/stage_data.dart';
import '../shared/constants/stage_configs.dart';
import '../services/storage_service.dart';

part 'stage_provider.g.dart';

/// ステージ一覧を提供するプロバイダー
@riverpod
Future<List<StageData>> stageList(StageListRef ref) async {
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
}

/// 特定のステージデータを提供するプロバイダー
@riverpod
Future<StageData> stage(StageRef ref, int stageNumber) async {
  final storageService = ref.watch(storageServiceProvider);
  final stage = StageConfigs.getStage(stageNumber);

  final highScore = await storageService.getHighScore(stageNumber);
  final highCombo = await storageService.getHighCombo(stageNumber);

  return stage.copyWith(
    highScore: highScore,
    highCombo: highCombo,
  );
}
