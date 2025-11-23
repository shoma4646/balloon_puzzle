import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/game_constants.dart';

/// 風船のタイプ（8段階）
enum BalloonType {
  level1,
  level2,
  level3,
  level4,
  level5,
  level6,
  level7,
  level8;

  /// レベル番号を取得（1-8）
  int get level => index + 1;

  /// 風船の色を取得
  Color get color {
    switch (this) {
      case BalloonType.level1:
        return AppColors.balloonRed;
      case BalloonType.level2:
        return AppColors.balloonOrange;
      case BalloonType.level3:
        return AppColors.balloonYellow;
      case BalloonType.level4:
        return AppColors.balloonYellowGreen;
      case BalloonType.level5:
        return AppColors.balloonGreen;
      case BalloonType.level6:
        return AppColors.balloonCyan;
      case BalloonType.level7:
        return AppColors.balloonBlue;
      case BalloonType.level8:
        return AppColors.balloonPurple;
    }
  }

  /// 風船のサイズ倍率を取得
  double get sizeMultiplier {
    return GameConstants.balloonSizeMultipliers[index];
  }

  /// 風船の実際のサイズを取得
  double get size {
    return GameConstants.balloonBaseSize * sizeMultiplier;
  }

  /// 風船の半径を取得
  double get radius => size / 2;

  /// 風船を離す時のポイントを取得
  int get releasePoint {
    return GameConstants.baseReleasePoint * level;
  }

  /// マージボーナスを取得
  int get mergeBonus {
    return GameConstants.baseMergeBonus * level;
  }

  /// 次のレベルの風船を取得（Lv.8の場合はnull）
  BalloonType? get nextLevel {
    if (this == BalloonType.level8) return null;
    return BalloonType.values[index + 1];
  }

  /// 最大レベルかどうか
  bool get isMaxLevel => this == BalloonType.level8;

  /// レベル番号から風船タイプを取得
  static BalloonType fromLevel(int level) {
    if (level < 1 || level > 8) {
      throw ArgumentError('Level must be between 1 and 8');
    }
    return BalloonType.values[level - 1];
  }

  /// ランダムな風船タイプを取得（Lv.1-5のみ）
  static final _random = Random();

  /// 基本的なランダム生成（重み付き確率）
  /// Lv.1: 40%, Lv.2: 30%, Lv.3: 20%, Lv.4: 8%, Lv.5: 2%
  static BalloonType random() {
    final rand = _random.nextInt(100);
    if (rand < 40) return BalloonType.level1;
    if (rand < 70) return BalloonType.level2;
    if (rand < 90) return BalloonType.level3;
    if (rand < 98) return BalloonType.level4;
    return BalloonType.level5;
  }

  /// スコアに応じた難易度でランダム生成
  /// スコアが高いほど高レベルの風船が出やすくなる
  static BalloonType randomWithDifficulty(int score) {
    // 難易度レベルを計算（1000点ごとに1段階上昇、最大5段階）
    final difficultyLevel = (score / 1000).floor().clamp(0, 5);

    final rand = _random.nextInt(100);

    switch (difficultyLevel) {
      case 0: // 0-999点: Lv.1-3が中心
        if (rand < 50) return BalloonType.level1;
        if (rand < 85) return BalloonType.level2;
        return BalloonType.level3;

      case 1: // 1000-1999点: Lv.1-4
        if (rand < 40) return BalloonType.level1;
        if (rand < 70) return BalloonType.level2;
        if (rand < 90) return BalloonType.level3;
        return BalloonType.level4;

      case 2: // 2000-2999点: 標準バランス
        if (rand < 40) return BalloonType.level1;
        if (rand < 70) return BalloonType.level2;
        if (rand < 90) return BalloonType.level3;
        if (rand < 98) return BalloonType.level4;
        return BalloonType.level5;

      case 3: // 3000-3999点: 高レベル増加
        if (rand < 30) return BalloonType.level1;
        if (rand < 60) return BalloonType.level2;
        if (rand < 85) return BalloonType.level3;
        if (rand < 96) return BalloonType.level4;
        return BalloonType.level5;

      case 4: // 4000-4999点: さらに高レベル増加
        if (rand < 25) return BalloonType.level1;
        if (rand < 50) return BalloonType.level2;
        if (rand < 75) return BalloonType.level3;
        if (rand < 92) return BalloonType.level4;
        return BalloonType.level5;

      default: // 5000点以上: 最高難易度
        if (rand < 20) return BalloonType.level1;
        if (rand < 45) return BalloonType.level2;
        if (rand < 70) return BalloonType.level3;
        if (rand < 88) return BalloonType.level4;
        return BalloonType.level5;
    }
  }
}
