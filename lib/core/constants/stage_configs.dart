import 'package:flutter/material.dart';
import '../config/platform_config.dart';
import '../domain/entities/stage_data.dart';
import '../domain/entities/game_time_of_day.dart';

/// ステージ設定の定義
class StageConfigs {
  StageConfigs._();

  /// エンドレスモード: シンプルな雲の棚構成
  static const StageData endless = StageData(
    stageNumber: 0,
    name: 'エンドレスモード',
    description: 'ハイスコアを目指そう！',
    difficulty: 0,
    timeOfDay: GameTimeOfDay.day,
    platforms: [
      // HUDの下に大きな雲の棚
      PlatformConfig(
        xRatio: 0.5,
        yRatio: 0.15, // HUDの下（画面の15%の位置）
        lengthRatio: 0.95, // 画面幅の95%で長く
      ),
    ],
  );

  /// ステージ1: チュートリアル（朝）
  static const StageData stage1 = StageData(
    stageNumber: 1,
    name: 'チュートリアル',
    description: '基本的な操作を学ぼう',
    difficulty: 1,
    timeOfDay: GameTimeOfDay.morning,
    platforms: [],
  );

  /// ステージ2: 基本（昼）
  static const StageData stage2 = StageData(
    stageNumber: 2,
    name: '基本',
    description: '雲の棚を使いこなそう',
    difficulty: 2,
    timeOfDay: GameTimeOfDay.day,
    platforms: [],
  );

  /// ステージ3: 中級（夕方）
  static const StageData stage3 = StageData(
    stageNumber: 3,
    name: '中級',
    description: '3つの雲で戦略的にプレイ',
    difficulty: 3,
    timeOfDay: GameTimeOfDay.evening,
    platforms: [],
  );

  /// ステージ4: 上級（朝）
  static const StageData stage4 = StageData(
    stageNumber: 4,
    name: '上級',
    description: '複雑な配置に挑戦',
    difficulty: 4,
    timeOfDay: GameTimeOfDay.morning,
    platforms: [],
  );

  /// ステージ5: エキスパート（夕方）
  static const StageData stage5 = StageData(
    stageNumber: 5,
    name: 'エキスパート',
    description: '最高難易度に挑め',
    difficulty: 5,
    timeOfDay: GameTimeOfDay.evening,
    platforms: [],
  );

  /// 全ステージのリスト
  static const List<StageData> allStages = [
    stage1,
    stage2,
    stage3,
    stage4,
    stage5,
  ];

  /// ステージ番号からステージデータを取得
  static StageData getStage(int stageNumber) {
    if (stageNumber < 1 || stageNumber > 5) {
      throw ArgumentError('Stage number must be between 1 and 5');
    }
    return allStages[stageNumber - 1];
  }
}
