import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// 木の葉の茂みコンポーネント
class TreeFoliageComponent extends PositionComponent {
  final Vector2 treePosition;
  final double foliageWidth;
  static const double foliageHeight = 500.0; // 高さを固定

  TreeFoliageComponent({
    required this.treePosition,
    this.foliageWidth = 150.0,
  }) {
    position = Vector2(treePosition.x, 0);
    size = Vector2(foliageWidth, foliageHeight); // 高さは固定値を使用
    priority = 10; // 木の幹より前面に描画
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 葉の茂みを複数の円で構成してもこもこ感を表現
    final foliagePaint = Paint()
      ..color = const Color(0xFF4CAF50) // 緑色
      ..style = PaintingStyle.fill;

    final darkFoliagePaint = Paint()
      ..color = const Color(0xFF388E3C) // 濃い緑色（影）
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFF2E7D32) // さらに濃い緑色（輪郭線）
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 中央に大きな円（高さベースでサイズを決定）
    final centerRadius = foliageHeight * 0.35;
    final center = Offset(0, centerRadius);

    // 影（濃い緑）を少しずらして描画
    canvas.drawCircle(
      Offset(center.dx + 2, center.dy + 2),
      centerRadius,
      darkFoliagePaint,
    );

    // メインの葉
    canvas.drawCircle(center, centerRadius, foliagePaint);
    canvas.drawCircle(center, centerRadius, outlinePaint);

    // 左側のもこもこ
    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.25, centerRadius * 0.8),
      centerRadius * 0.7,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // 右側のもこもこ
    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.25, centerRadius * 0.8),
      centerRadius * 0.7,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // 上部のもこもこ（小さめ）
    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.1, centerRadius * 0.3),
      centerRadius * 0.5,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.1, centerRadius * 0.3),
      centerRadius * 0.5,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // 下部のもこもこ（左右）
    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.35, centerRadius * 1.2),
      centerRadius * 0.6,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.35, centerRadius * 1.2),
      centerRadius * 0.6,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // 追加のもこもこ（中層・左右）
    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.18, centerRadius * 1.0),
      centerRadius * 0.55,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.18, centerRadius * 1.0),
      centerRadius * 0.55,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // 追加のもこもこ（上層・左右外側）
    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.3, centerRadius * 0.5),
      centerRadius * 0.45,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.3, centerRadius * 0.5),
      centerRadius * 0.45,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // 追加のもこもこ（最下部・左右外側）
    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.4, centerRadius * 1.35),
      centerRadius * 0.5,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.4, centerRadius * 1.35),
      centerRadius * 0.5,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // 最上部の小さなもこもこ（中央）
    _drawFoliageBubble(
      canvas,
      Offset(0, centerRadius * 0.15),
      centerRadius * 0.35,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // さらに横幅を広げるための追加もこもこ（左側）
    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.45, centerRadius * 0.9),
      centerRadius * 0.48,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.42, centerRadius * 1.1),
      centerRadius * 0.52,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(-foliageWidth * 0.38, centerRadius * 0.7),
      centerRadius * 0.42,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    // さらに横幅を広げるための追加もこもこ（右側）
    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.45, centerRadius * 0.9),
      centerRadius * 0.48,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.42, centerRadius * 1.1),
      centerRadius * 0.52,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );

    _drawFoliageBubble(
      canvas,
      Offset(foliageWidth * 0.38, centerRadius * 0.7),
      centerRadius * 0.42,
      foliagePaint,
      darkFoliagePaint,
      outlinePaint,
    );
  }

  /// 葉のもこもこの一部を描画
  void _drawFoliageBubble(
    Canvas canvas,
    Offset position,
    double radius,
    Paint mainPaint,
    Paint shadowPaint,
    Paint outlinePaint,
  ) {
    // 影
    canvas.drawCircle(
      Offset(position.dx + 1.5, position.dy + 1.5),
      radius,
      shadowPaint,
    );

    // メイン
    canvas.drawCircle(position, radius, mainPaint);

    // 輪郭線
    canvas.drawCircle(position, radius, outlinePaint);
  }
}
