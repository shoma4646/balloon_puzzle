import '../../models/branch_config.dart';
import '../../models/stage_data.dart';

/// ステージ設定の定義
class StageConfigs {
  StageConfigs._();

  /// ステージ1: チュートリアル
  static const StageData stage1 = StageData(
    stageNumber: 1,
    name: 'チュートリアル',
    description: '基本的な操作を学ぼう',
    difficulty: 1,
    branches: [
      // 木の幹(画面右端+60px)から左に伸びる水平な枝
      BranchConfig(
        xRatio: 0.75,
        yRatio: 0.5,
        lengthRatio: 0.4,
        angle: 0.0, // 水平
      ),
    ],
  );

  /// ステージ2: 基本
  static const StageData stage2 = StageData(
    stageNumber: 2,
    name: '基本',
    description: '左右の枝を使いこなそう',
    difficulty: 2,
    branches: [
      BranchConfig(
        xRatio: 0.7,
        yRatio: 0.35,
        lengthRatio: 0.35,
        angle: 0.0, // 水平
      ),
      BranchConfig(
        xRatio: 0.7,
        yRatio: 0.65,
        lengthRatio: 0.35,
        angle: 0.0, // 水平
      ),
    ],
  );

  /// ステージ3: 中級
  static const StageData stage3 = StageData(
    stageNumber: 3,
    name: '中級',
    description: '3つの枝で戦略的にプレイ',
    difficulty: 3,
    branches: [
      BranchConfig(
        xRatio: 0.65,
        yRatio: 0.3,
        lengthRatio: 0.35,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.7,
        yRatio: 0.5,
        lengthRatio: 0.4,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.65,
        yRatio: 0.7,
        lengthRatio: 0.35,
        angle: 0.0,
      ),
    ],
  );

  /// ステージ4: 上級
  static const StageData stage4 = StageData(
    stageNumber: 4,
    name: '上級',
    description: '複雑な配置に挑戦',
    difficulty: 4,
    branches: [
      BranchConfig(
        xRatio: 0.6,
        yRatio: 0.25,
        lengthRatio: 0.3,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.65,
        yRatio: 0.4,
        lengthRatio: 0.35,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.65,
        yRatio: 0.6,
        lengthRatio: 0.35,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.6,
        yRatio: 0.75,
        lengthRatio: 0.3,
        angle: 0.0,
      ),
    ],
  );

  /// ステージ5: エキスパート
  static const StageData stage5 = StageData(
    stageNumber: 5,
    name: 'エキスパート',
    description: '最高難易度に挑め',
    difficulty: 5,
    branches: [
      BranchConfig(
        xRatio: 0.55,
        yRatio: 0.2,
        lengthRatio: 0.3,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.6,
        yRatio: 0.35,
        lengthRatio: 0.35,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.65,
        yRatio: 0.5,
        lengthRatio: 0.4,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.6,
        yRatio: 0.65,
        lengthRatio: 0.35,
        angle: 0.0,
      ),
      BranchConfig(
        xRatio: 0.55,
        yRatio: 0.8,
        lengthRatio: 0.3,
        angle: 0.0,
      ),
    ],
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
