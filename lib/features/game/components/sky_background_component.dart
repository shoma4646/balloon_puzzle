import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// 青空と雲を描画する背景コンポーネント
class SkyBackgroundComponent extends PositionComponent {
  final Vector2 gameSize;
  final Random _random = Random(42); // 固定シードで常に同じ雲の配置

  SkyBackgroundComponent({required this.gameSize}) {
    position = Vector2.zero();
    size = gameSize;
    priority = -100; // 最背面に描画
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 青空のグラデーション（上から下に向かって明るくなる）
    final skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF87CEEB), // 空色（上部）
        const Color(0xFFB0E0E6), // より明るい空色（下部）
      ],
    );

    final skyRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final skyPaint = Paint()..shader = skyGradient.createShader(skyRect);

    canvas.drawRect(skyRect, skyPaint);

    // 雲を描画
    _drawClouds(canvas);
  }

  /// 雲を描画
  void _drawClouds(Canvas canvas) {
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // 複数の雲を配置
    _drawCloud(canvas, cloudPaint, Offset(size.x * 0.2, size.y * 0.15), 60.0);
    _drawCloud(canvas, cloudPaint, Offset(size.x * 0.6, size.y * 0.1), 80.0);
    _drawCloud(canvas, cloudPaint, Offset(size.x * 0.8, size.y * 0.25), 50.0);
    _drawCloud(canvas, cloudPaint, Offset(size.x * 0.15, size.y * 0.35), 70.0);
    _drawCloud(canvas, cloudPaint, Offset(size.x * 0.5, size.y * 0.4), 55.0);
  }

  /// 単一の雲を描画（複数の円で構成）
  void _drawCloud(Canvas canvas, Paint paint, Offset center, double scale) {
    // 雲は複数の円で構成される
    // 中央の大きな円
    canvas.drawCircle(center, scale * 0.6, paint);

    // 左側の円
    canvas.drawCircle(
      Offset(center.dx - scale * 0.5, center.dy + scale * 0.1),
      scale * 0.5,
      paint,
    );

    // 右側の円
    canvas.drawCircle(
      Offset(center.dx + scale * 0.5, center.dy + scale * 0.1),
      scale * 0.5,
      paint,
    );

    // 上部の小さな円
    canvas.drawCircle(
      Offset(center.dx - scale * 0.15, center.dy - scale * 0.3),
      scale * 0.4,
      paint,
    );

    canvas.drawCircle(
      Offset(center.dx + scale * 0.15, center.dy - scale * 0.3),
      scale * 0.4,
      paint,
    );
  }
}
