/// ゲームの状態
enum GameStatus {
  /// 待機中（ゲーム開始前）
  idle,

  /// プレイ中
  playing,

  /// 一時停止中
  paused,

  /// ゲームオーバー
  gameOver;

  /// ゲームが進行中かどうか
  bool get isPlaying => this == GameStatus.playing;

  /// ゲームが停止中かどうか
  bool get isPaused => this == GameStatus.paused;

  /// ゲームが終了しているかどうか
  bool get isGameOver => this == GameStatus.gameOver;

  /// ゲームが開始されていないかどうか
  bool get isIdle => this == GameStatus.idle;
}
