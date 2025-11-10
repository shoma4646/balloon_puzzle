import 'branch_config.dart';

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

  /// 枝の配置設定リスト
  final List<BranchConfig> branches;

  /// ハイスコア
  final int highScore;

  /// 最高コンボ数
  final int highCombo;

  const StageData({
    required this.stageNumber,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.branches,
    this.highScore = 0,
    this.highCombo = 0,
  });

  /// コピーを作成
  StageData copyWith({
    int? stageNumber,
    String? name,
    String? description,
    int? difficulty,
    List<BranchConfig>? branches,
    int? highScore,
    int? highCombo,
  }) {
    return StageData(
      stageNumber: stageNumber ?? this.stageNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      branches: branches ?? this.branches,
      highScore: highScore ?? this.highScore,
      highCombo: highCombo ?? this.highCombo,
    );
  }
}
