import 'balloon_type.dart';

/// 風船の基本データモデル
class BalloonData {
  /// 風船のID
  final String id;

  /// 風船のタイプ
  final BalloonType type;

  /// 風船の位置（X座標）
  final double x;

  /// 風船の位置（Y座標）
  final double y;

  /// 風船の速度（X方向）
  final double velocityX;

  /// 風船の速度（Y方向）
  final double velocityY;

  const BalloonData({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    this.velocityX = 0.0,
    this.velocityY = 0.0,
  });

  /// コピーを作成
  BalloonData copyWith({
    String? id,
    BalloonType? type,
    double? x,
    double? y,
    double? velocityX,
    double? velocityY,
  }) {
    return BalloonData(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      velocityX: velocityX ?? this.velocityX,
      velocityY: velocityY ?? this.velocityY,
    );
  }
}
