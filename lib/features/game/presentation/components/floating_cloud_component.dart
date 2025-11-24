import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 背景に浮かぶ装飾用の画像（飴、ジンジャーブレッドなど）
enum FloatingDecorationType {
  cloud,
  star,
}

/// 背景に浮かぶ装飾（雲や星）
class FloatingCloudComponent extends PositionComponent {
  final Vector2 gameSize;
  final double speed;
  final double scaleFactor;
  final FloatingDecorationType type;
  double _time = 0.0;

  FloatingCloudComponent({
    required this.gameSize,
    required Vector2 initialPosition,
    this.speed = 20.0,
    this.scaleFactor = 1.0,
    required this.type,
  }) {
    position = initialPosition;
    size = Vector2(100 * scaleFactor, 100 * scaleFactor);
    priority = -90; // 背景より前、ゲーム要素より後ろ

    // ランダムな時間オフセットでアニメーションをずらす
    _time = math.Random().nextDouble() * 100;
  }

  @override
  void update(double dt) {
    super.update(dt);

    _time += dt;

    // 左から右へ移動
    position.x += speed * dt;

    // 画面外に出たら左端に戻す
    if (position.x > gameSize.x + size.x) {
      position.x = -size.x;
      // Y位置をランダムに変更
      final random = math.Random();
      position.y = random.nextDouble() * gameSize.y * 0.8; // 画面の上80%にランダム配置
    }

    // ふわふわとした動き
    final baseY = position.y;
    if (type == FloatingDecorationType.cloud) {
      position.y = baseY + math.sin(_time * 0.5) * 0.5;
    } else {
      // 星はキラキラ回転させる（描画側で処理）
      position.y = baseY + math.sin(_time * 1.0) * 1.0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (type == FloatingDecorationType.cloud) {
      _renderCloud(canvas);
    } else {
      _renderStar(canvas);
    }
  }

  /// 雲の描画
  void _renderCloud(Canvas canvas) {
    final cloudRadius = size.y * 0.4;

    // 雲の構成要素（円の相対位置）
    final cloudBubbles = [
      Offset(size.x * 0.5, size.y * 0.5),
      Offset(size.x * 0.3, size.y * 0.55),
      Offset(size.x * 0.7, size.y * 0.55),
      Offset(size.x * 0.4, size.y * 0.35),
      Offset(size.x * 0.6, size.y * 0.35),
    ];

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    for (final bubble in cloudBubbles) {
      canvas.drawCircle(bubble, cloudRadius, paint);
    }

    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.1);

    for (final bubble in cloudBubbles) {
      canvas.drawCircle(bubble, cloudRadius * 0.8, highlightPaint);
    }
  }

  /// 星の描画
  void _renderStar(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final outerRadius = size.x * 0.4;
    final innerRadius = size.x * 0.15;

    // 星のきらめきアニメーション
    final opacity = 0.5 + 0.5 * math.sin(_time * 3.0).abs();

    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.6 * opacity)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * math.pi * 2 / 5;
      final x = center.dx + math.cos(angle) * outerRadius;
      final y = center.dy + math.sin(angle) * outerRadius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      final nextAngle = angle + math.pi / 5;
      final nextX = center.dx + math.cos(nextAngle) * innerRadius;
      final nextY = center.dy + math.sin(nextAngle) * innerRadius;
      path.lineTo(nextX, nextY);
    }
    path.close();

    canvas.drawPath(path, paint);

    // 中心核
    final corePaint = Paint()
      ..color = Colors.white.withOpacity(0.9 * opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerRadius, corePaint);
  }
}
