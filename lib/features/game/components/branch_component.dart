import 'dart:math';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart' as forge2d;

/// 枝コンポーネント
class BranchComponent extends BodyComponent {
  final Vector2 position;
  final double length;
  final double angle;
  final double thickness = 20.0;

  BranchComponent({
    required this.position,
    required this.length,
    this.angle = 0.0,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = true;
  }

  @override
  Body createBody() {
    final bodyDef = forge2d.BodyDef(
      position: position,
      type: forge2d.BodyType.static,
      angle: angle * pi / 180, // 度数法からラジアンに変換
      userData: this,
    );

    final body = world.createBody(bodyDef);

    // 矩形の形状を作成（枝）
    final shape = forge2d.PolygonShape();
    shape.setAsBox(
      length / 2,
      thickness / 2,
      Vector2.zero(),
      0,
    );

    final fixtureDef = forge2d.FixtureDef(
      shape,
      friction: 0.8, // 高い摩擦係数で風船が引っかかりやすく
      restitution: 0.1, // 低い反発係数
    );

    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // シンプルなフラットデザインの枝を描画
    final branchRect = Rect.fromCenter(
      center: Offset.zero,
      width: length,
      height: thickness,
    );

    // 枝の本体（茶色）
    final branchPaint = Paint()
      ..color = const Color(0xFF8B5A3C)
      ..style = PaintingStyle.fill;

    canvas.drawRect(branchRect, branchPaint);

    // 枝の輪郭線（濃い茶色）
    final outlinePaint = Paint()
      ..color = const Color(0xFF5D3A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(branchRect, outlinePaint);
  }
}
