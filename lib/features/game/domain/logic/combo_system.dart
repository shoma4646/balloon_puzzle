import 'dart:math' as math;

/// コンボシステムを管理するクラス
class ComboSystem {
  /// 現在のコンボ数
  int _comboCount = 0;

  /// コンボ受付時間の残り時間
  double _comboTimer = 0.0;

  /// コンボ受付時間（秒）
  static const double comboDuration = 2.0;

  /// 最大コンボボーナス倍率
  static const double maxComboMultiplier = 3.0;

  /// コンボを加算する
  /// 戻り値: 現在のコンボ数
  int addCombo() {
    _comboCount++;
    _comboTimer = comboDuration;
    return _comboCount;
  }

  /// 時間経過による更新
  void update(double dt) {
    if (_comboTimer > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) {
        reset();
      }
    }
  }

  /// コンボをリセットする
  void reset() {
    _comboCount = 0;
    _comboTimer = 0.0;
  }

  /// 現在のコンボボーナス倍率を取得
  /// コンボ数に応じて倍率が上昇（例: 1コンボ=1.0倍, 2コンボ=1.1倍, ...）
  double get comboMultiplier {
    if (_comboCount <= 1) return 1.0;

    // 1コンボにつき0.1倍加算、最大3.0倍まで
    final multiplier = 1.0 + (_comboCount - 1) * 0.1;
    return math.min(multiplier, maxComboMultiplier);
  }

  /// 現在のコンボ数
  int get comboCount => _comboCount;

  /// コンボ中かどうか
  bool get isInCombo => _comboCount > 0 && _comboTimer > 0;

  /// コンボタイマーの進行状況 (0.0 - 1.0)
  double get timerProgress {
    if (_comboTimer <= 0) return 0.0;
    return _comboTimer / comboDuration;
  }
}
