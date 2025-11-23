import 'package:flame/components.dart' hide Vector2;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart' as forge2d;
import 'package:vector_math/vector_math.dart' as vm;

/// 雲の棚コンポーネント
/// 風船が引っかかる雲の形をした棚
class CloudPlatformComponent extends BodyComponent {
  final Vector2 position;
  final double length;
  final double thickness = 180.0; // 雲の厚さをさらに増やして自然な形に

  Sprite? _cloudSprite;

  CloudPlatformComponent({
    required this.position,
    required this.length,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false; // カスタムレンダリング（もくもくの雲）を使用

    // 雲の画像を読み込む
    // pubspec.yamlで assets/images/ を登録しているため、
    // Sprite.loadではファイル名のみを指定
    try {
      _cloudSprite = await Sprite.load('cloud_platform.png');
      print('✅ Cloud sprite loaded successfully');
    } catch (e) {
      print('❌ Failed to load cloud sprite: $e');
      // 画像が読み込めない場合はnullのままにして、フォールバックレンダリングを使用
    }
  }

  @override
  Body createBody() {
    final bodyDef = forge2d.BodyDef(
      position: position,
      type: forge2d.BodyType.static,
      userData: this,
    );

    final body = world.createBody(bodyDef);

    // シンプルなバー状の当たり判定
    // 雲の画像の下部に配置して、ギリギリ隠れるようにする
    final barHeight = thickness * 0.15; // 画像の下部15%の高さ
    final barY = thickness * 0.25; // 画像の下部に配置（上に移動）

    final shape = forge2d.PolygonShape();
    shape.setAsBox(
      length / 2 * 0.8, // 横幅を雲の長さの80%に
      barHeight / 2, // バーの高さ
      Vector2(0, barY), // 雲の下部に配置
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

    // 画像がある場合は画像を描画、ない場合はフォールバック
    if (_cloudSprite != null) {
      _renderCloudImage(canvas);
    } else {
      _renderCloud(canvas);
    }
  }

  /// 雲の画像を描画
  void _renderCloudImage(Canvas canvas) {
    final spriteSize = vm.Vector2(length, thickness);
    final spritePosition = vm.Vector2(-length / 2, -thickness / 2);

    canvas.save();
    _cloudSprite!.render(
      canvas,
      position: spritePosition,
      size: spriteSize,
    );
    canvas.restore();
  }

  /// 雲を描画
  void _renderCloud(Canvas canvas) {
    // 雲の本体（複数の円で構成）
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = const Color(0xFF90CAF9).withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // 影を描画
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: const Offset(2, 3),
          width: length,
          height: thickness,
        ),
        const Radius.circular(25),
      ),
      shadowPaint,
    );

    // 雲の本体を描画
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: length,
          height: thickness,
        ),
        const Radius.circular(25),
      ),
      cloudPaint,
    );

    // 雲のディテール（複数の円で凸凹感を出す）
    final detailPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    final bubbleRadius = thickness * 0.35;
    final bubbleCount = (length / (bubbleRadius * 2)).floor();

    for (var i = 0; i < bubbleCount; i++) {
      final x = -length / 2 + (i * length / bubbleCount) + bubbleRadius;
      canvas.drawCircle(
        Offset(x, -thickness * 0.2),
        bubbleRadius * 0.8,
        detailPaint,
      );
    }
  }
}
