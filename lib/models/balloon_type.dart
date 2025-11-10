import 'package:flutter/material.dart';
import '../shared/constants/app_colors.dart';
import '../shared/constants/game_constants.dart';

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
  static BalloonType random() {
    final randomIndex = DateTime.now().microsecondsSinceEpoch % 5;
    return BalloonType.values[randomIndex];
  }
}
