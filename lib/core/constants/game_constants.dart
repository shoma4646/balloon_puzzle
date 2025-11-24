/// ゲーム全体で使用する定数
class GameConstants {
  GameConstants._();

  // 物理演算
  static const double gravity = 0.0; // 重力なし（浮力のみで制御）
  static const double airResistance = 0.999; // 空気抵抗（速度の減衰率）
  static const double buoyancyForce = 1500.0; // 基本浮力

  // 風船のサイズ（相対値）
  static const double balloonBaseSize = 20.0;
  static const List<double> balloonSizeMultipliers = [
    1.0, // Lv.1
    1.3, // Lv.2
    1.6, // Lv.3
    1.9, // Lv.4
    2.2, // Lv.5
    2.5, // Lv.6
    2.8, // Lv.7
    3.1, // Lv.8
  ];

  // スコアリング
  static const int baseReleasePoint = 10; // 風船を離す基本ポイント
  static const int baseMergeBonus = 50; // マージボーナスの基本値
  static const int maxBalloonPopBonus = 1000; // Lv.8風船消滅ボーナス

  // コンボシステム
  static const double comboTimeout = 5.0; // コンボタイムアウト（秒）
  static const List<double> comboMultipliers = [
    1.0, // コンボなし
    1.5, // 1コンボ
    2.0, // 2コンボ
    2.5, // 3コンボ
    3.0, // 4コンボ以上（最大）
  ];

  // ゲームオーバー
  static const double gameOverLineRatio = 0.98; // 画面上部からの比率（0.98 = 上から2%の位置）
  static const double gameOverGracePeriod = 0.5; // 猶予時間（秒）

  // 風船のプレビュー数（運要素を高めるため2個に削減）
  static const int balloonPreviewCount = 2;

  // 風船配置の制限
  static const double balloonSpawnCooldown = 1.0; // 風船配置のクールダウン（秒）

  // 画面サイズ関連
  static const double gameCanvasRatio = 0.75; // ゲームキャンバスの画面比率

  // ステージ数
  static const int totalStages = 5;

  // パフォーマンス
  static const int maxBalloons = 50; // 最大風船数
  static const int targetFps = 60; // 目標FPS
}
