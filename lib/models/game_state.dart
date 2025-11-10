import 'balloon_type.dart';
import 'game_status.dart';

/// ゲーム状態を管理するモデル
class GameState {
  /// 現在のスコア
  final int score;

  /// 現在のコンボ数
  final int combo;

  /// 経過時間（秒）
  final double elapsedTime;

  /// ゲームステータス
  final GameStatus status;

  /// 次に出現する風船タイプのリスト
  final List<BalloonType> nextBalloonTypes;

  /// マージ回数
  final int mergeCount;

  /// 最後のマージ時刻（コンボ判定用）
  final double? lastMergeTime;

  /// ゲームオーバーライン超過開始時刻
  final double? gameOverLineExceededTime;

  const GameState({
    this.score = 0,
    this.combo = 0,
    this.elapsedTime = 0.0,
    this.status = GameStatus.idle,
    this.nextBalloonTypes = const [],
    this.mergeCount = 0,
    this.lastMergeTime,
    this.gameOverLineExceededTime,
  });

  /// 初期状態を作成
  factory GameState.initial() {
    return GameState(
      nextBalloonTypes: List.generate(
        3,
        (_) => BalloonType.random(),
      ),
    );
  }

  /// コンボ倍率を取得
  double get comboMultiplier {
    if (combo == 0) return 1.0;
    if (combo >= 4) return 3.0;
    return [1.0, 1.5, 2.0, 2.5, 3.0][combo];
  }

  /// コピーを作成
  GameState copyWith({
    int? score,
    int? combo,
    double? elapsedTime,
    GameStatus? status,
    List<BalloonType>? nextBalloonTypes,
    int? mergeCount,
    double? lastMergeTime,
    double? gameOverLineExceededTime,
    bool clearLastMergeTime = false,
    bool clearGameOverLineExceededTime = false,
  }) {
    return GameState(
      score: score ?? this.score,
      combo: combo ?? this.combo,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      status: status ?? this.status,
      nextBalloonTypes: nextBalloonTypes ?? this.nextBalloonTypes,
      mergeCount: mergeCount ?? this.mergeCount,
      lastMergeTime: clearLastMergeTime ? null : (lastMergeTime ?? this.lastMergeTime),
      gameOverLineExceededTime: clearGameOverLineExceededTime
          ? null
          : (gameOverLineExceededTime ?? this.gameOverLineExceededTime),
    );
  }
}
