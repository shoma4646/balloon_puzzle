import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 時間帯の種類
enum TimeOfDay {
  morning, // 朝
  day, // 昼
  evening, // 夕方
}

/// 青空を描画する背景コンポーネント
class SkyBackgroundComponent extends PositionComponent {
  final Vector2 gameSize;
  final TimeOfDay timeOfDay;
  double _animationTime = 0.0;

  SkyBackgroundComponent({
    required this.gameSize,
    this.timeOfDay = TimeOfDay.day,
  }) {
    position = Vector2.zero();
    size = gameSize;
    priority = -100; // 最背面に描画
  }

  @override
  void update(double dt) {
    super.update(dt);
    _animationTime += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 時間帯に応じたグラデーションを取得
    final skyGradient = _getSkyGradient();

    final skyRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final skyPaint = Paint()..shader = skyGradient.createShader(skyRect);

    canvas.drawRect(skyRect, skyPaint);

    // 太陽や星などの装飾を描画
    _drawDecorations(canvas);

    // 追加の装飾要素（鳥、星など）を描画
    _drawExtraDecorations(canvas);
  }

  /// 時間帯に応じたグラデーションを返す
  LinearGradient _getSkyGradient() {
    switch (timeOfDay) {
      case TimeOfDay.morning:
        // 朝焼け（オレンジから水色へ）
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB), // 明るい空色（上部）
            Color(0xFFFFB6C1), // ピンク（中間）
            Color(0xFFFFDAB9), // ピーチ（下部）
          ],
          stops: [0.0, 0.5, 1.0],
        );
      case TimeOfDay.day:
        // 昼間（青空）
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A90E2), // 濃い青（上部）
            Color(0xFF87CEEB), // 空色（中間）
            Color(0xFFB0E0E6), // 明るい空色（下部）
          ],
          stops: [0.0, 0.6, 1.0],
        );
      case TimeOfDay.evening:
        // 夕焼け（オレンジから紫へ）
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A5899), // 紫がかった青（上部）
            Color(0xFFFF6B6B), // オレンジ（中間）
            Color(0xFFFFB347), // 明るいオレンジ（下部）
          ],
          stops: [0.0, 0.5, 1.0],
        );
    }
  }

  /// 時間帯に応じた装飾を描画
  void _drawDecorations(Canvas canvas) {
    switch (timeOfDay) {
      case TimeOfDay.morning:
        // 朝の太陽（左上）
        _drawSun(canvas, Offset(size.x * 0.15, size.y * 0.15), 30,
            const Color(0xFFFFE66D));
        break;
      case TimeOfDay.day:
        // 昼の太陽（右上）
        _drawSun(canvas, Offset(size.x * 0.85, size.y * 0.12), 35,
            const Color(0xFFFFD700));
        break;
      case TimeOfDay.evening:
        // 夕方の太陽（右下寄り）
        _drawSun(canvas, Offset(size.x * 0.8, size.y * 0.65), 40,
            const Color(0xFFFF6B6B));
        break;
    }
  }

  /// 太陽を描画
  void _drawSun(Canvas canvas, Offset position, double radius, Color color) {
    // 太陽の光輪（グロー効果）
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(position, radius * 1.8, glowPaint);

    // 太陽本体（グラデーション）
    final sunGradient = RadialGradient(
      colors: [
        color.withValues(alpha: 1.0),
        color.withValues(alpha: 0.9),
        color.withValues(alpha: 0.7),
      ],
      stops: const [0.0, 0.7, 1.0],
    );

    final sunPaint = Paint()
      ..shader = sunGradient.createShader(
        Rect.fromCircle(center: position, radius: radius),
      );
    canvas.drawCircle(position, radius, sunPaint);

    // 太陽のハイライト
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.5);
    canvas.drawCircle(
      position + Offset(-radius * 0.3, -radius * 0.3),
      radius * 0.4,
      highlightPaint,
    );
  }

  /// 追加の装飾要素を描画
  void _drawExtraDecorations(Canvas canvas) {
    switch (timeOfDay) {
      case TimeOfDay.morning:
        // 朝：鳥を描画
        _drawBirds(canvas);
        break;
      case TimeOfDay.day:
        // 昼：動く雲を描画
        _drawFloatingClouds(canvas);
        break;
      case TimeOfDay.evening:
        // 夕方：星を描画
        _drawStars(canvas);
        break;
    }
  }

  /// 鳥を描画（シンプルなV字型）
  void _drawBirds(Canvas canvas) {
    final birdPaint = Paint()
      ..color = const Color(0xFF333333).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 3羽の鳥を描画
    for (var i = 0; i < 3; i++) {
      final offset = _animationTime * 30 + (i * 100); // ゆっくり移動
      final x = (offset % (size.x + 100)) - 50;
      final y = size.y * 0.2 + (i * 30);

      final bird = Path()
        ..moveTo(x - 8, y)
        ..lineTo(x, y - 5)
        ..lineTo(x + 8, y);

      canvas.drawPath(bird, birdPaint);
    }
  }

  /// 浮かぶ雲を描画
  void _drawFloatingClouds(Canvas canvas) {
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // 2つの小さな雲を描画
    for (var i = 0; i < 2; i++) {
      final offset = _animationTime * 15 + (i * 200); // ゆっくり移動
      final x = (offset % (size.x + 150)) - 75;
      final y = size.y * 0.25 + (i * 100);

      // 簡素な雲の形
      canvas.drawCircle(Offset(x, y), 20, cloudPaint);
      canvas.drawCircle(Offset(x + 15, y), 15, cloudPaint);
      canvas.drawCircle(Offset(x - 15, y), 15, cloudPaint);
    }
  }

  /// 星を描画
  void _drawStars(Canvas canvas) {
    // 点滅する星を5つ描画
    final random = math.Random(42); // シード固定で同じ位置に表示
    for (var i = 0; i < 5; i++) {
      final x = random.nextDouble() * size.x;
      final y = random.nextDouble() * size.y * 0.4; // 上部40%に配置

      // 点滅アニメーション
      final twinkle = (math.sin(_animationTime * 2 + i) + 1) / 2; // 0〜1
      final alpha = 0.3 + (twinkle * 0.7); // 0.3〜1.0

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      // 星型を描画
      _drawStar(canvas, Offset(x, y), 3, paint);
    }
  }

  /// 星型を描画
  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}
