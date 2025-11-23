/// 雲の棚の配置設定
class PlatformConfig {
  /// 棚のX座標（画面幅に対する比率: 0.0-1.0）
  final double xRatio;

  /// 棚のY座標（画面高さに対する比率: 0.0-1.0）
  final double yRatio;

  /// 棚の長さ（画面幅に対する比率: 0.0-1.0）
  final double lengthRatio;

  const PlatformConfig({
    required this.xRatio,
    required this.yRatio,
    required this.lengthRatio,
  });

  /// 実際のX座標を計算
  double getActualX(double screenWidth) => screenWidth * xRatio;

  /// 実際のY座標を計算
  double getActualY(double screenHeight) => screenHeight * yRatio;

  /// 実際の長さを計算
  double getActualLength(double screenWidth) => screenWidth * lengthRatio;
}
