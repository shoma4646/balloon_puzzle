/// ゲーム結果モデル
class GameResult {
  /// 最終スコア
  final int finalScore;

  /// プレイ時間（秒）
  final double playTime;

  /// 最高コンボ数
  final int maxCombo;

  /// マージ回数
  final int mergeCount;

  /// ハイスコアを更新したかどうか
  final bool isNewHighScore;

  /// ステージ番号
  final int stageNumber;

  const GameResult({
    required this.finalScore,
    required this.playTime,
    required this.maxCombo,
    required this.mergeCount,
    required this.isNewHighScore,
    required this.stageNumber,
  });

  /// プレイ時間を分:秒形式で取得
  String get formattedPlayTime {
    final minutes = (playTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (playTime % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
