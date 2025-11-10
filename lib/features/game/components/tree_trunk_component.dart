import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart' as forge2d;

/// 木の幹コンポーネント
class TreeTrunkComponent extends BodyComponent {
  final Vector2 position;
  final double height;
  final double width;

  TreeTrunkComponent({
    required this.position,
    required this.height,
    this.width = 40.0,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
  }

  @override
  Body createBody() {
    final bodyDef = forge2d.BodyDef(
      position: position,
      type: forge2d.BodyType.static,
    );

    final body = world.createBody(bodyDef);

    // 縦長の長方形を作成
    final shape = forge2d.PolygonShape();
    shape.setAsBox(
      width / 2,
      height / 2,
      forge2d.Vector2(0, 0),
      0,
    );

    final fixtureDef = forge2d.FixtureDef(
      shape,
      friction: 0.5,
      restitution: 0.3,
    );

    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // シンプルなフラットデザインの木の幹を描画
    final trunkRect = Rect.fromCenter(
      center: Offset.zero,
      width: width,
      height: height,
    );

    // 幹の本体（茶色）
    final trunkPaint = Paint()
      ..color = const Color(0xFF8B5A3C)
      ..style = PaintingStyle.fill;

    canvas.drawRect(trunkRect, trunkPaint);

    // 幹の輪郭線（濃い茶色）
    final outlinePaint = Paint()
      ..color = const Color(0xFF5D3A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(trunkRect, outlinePaint);

    // 木の質感を表現する縦線を追加
    final texturePaint = Paint()
      ..color = const Color(0xFF5D3A1A).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 幹の左側に縦線
    canvas.drawLine(
      Offset(-width * 0.25, -height / 2),
      Offset(-width * 0.25, height / 2),
      texturePaint,
    );

    // 幹の右側に縦線
    canvas.drawLine(
      Offset(width * 0.25, -height / 2),
      Offset(width * 0.25, height / 2),
      texturePaint,
    );
  }
}
