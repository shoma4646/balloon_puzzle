import 'package:flutter/material.dart';
import '../../config/platform_config.dart';
import 'game_time_of_day.dart';

/// ステージのデータ
class StageData {
  /// ステージ番号（1-5）
  final int stageNumber;

  /// ステージ名
  final String name;

  /// 説明
  final String description;

  /// 難易度（1-5）
  final int difficulty;

  /// 雲の棚の配置設定リスト
  final List<PlatformConfig> platforms;

  /// ハイスコア
  final int highScore;

  /// 最高コンボ数
  final int highCombo;

  /// 時間帯（背景のテーマ）
  final GameTimeOfDay timeOfDay;

  const StageData({
    required this.stageNumber,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.platforms,
    this.highScore = 0,
    this.highCombo = 0,
    this.timeOfDay = GameTimeOfDay.day,
  });

  /// コピーを作成
  StageData copyWith({
    int? stageNumber,
    String? name,
    String? description,
    int? difficulty,
    List<PlatformConfig>? platforms,
    int? highScore,
    int? highCombo,
    GameTimeOfDay? timeOfDay,
  }) {
    return StageData(
      stageNumber: stageNumber ?? this.stageNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      platforms: platforms ?? this.platforms,
      highScore: highScore ?? this.highScore,
      highCombo: highCombo ?? this.highCombo,
      timeOfDay: timeOfDay ?? this.timeOfDay,
    );
  }
}
