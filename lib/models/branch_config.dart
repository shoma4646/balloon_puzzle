/// 枝の配置設定
class BranchConfig {
  /// 枝のX座標（画面幅に対する比率: 0.0-1.0）
  final double xRatio;

  /// 枝のY座標（画面高さに対する比率: 0.0-1.0）
  final double yRatio;

  /// 枝の長さ（画面幅に対する比率: 0.0-1.0）
  final double lengthRatio;

  /// 枝の角度（度数法: 0-360）
  final double angle;

  const BranchConfig({
    required this.xRatio,
    required this.yRatio,
    required this.lengthRatio,
    this.angle = 0.0,
  });

  /// 実際の座標を計算
  double getActualX(double screenWidth) => screenWidth * xRatio;

  /// 実際のY座標を計算
  double getActualY(double screenHeight) => screenHeight * yRatio;

  /// 実際の長さを計算
  double getActualLength(double screenWidth) => screenWidth * lengthRatio;
}
