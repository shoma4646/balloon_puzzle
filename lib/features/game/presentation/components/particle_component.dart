import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// パーティクルの種類
enum ParticleType {
  sparkle, // キラキラ（マージ用）
  burst, // 破裂（ポップ用）
  star, // 星型
}

/// 単一のパーティクル
class Particle extends PositionComponent {
  final Vector2 velocity;
  final Color color;
  final double maxLifetime;
  final ParticleType type;
  final double initialSize;

  double _lifetime = 0.0;

  Particle({
    required Vector2 position,
    required this.velocity,
    required this.color,
    required this.maxLifetime,
    required this.type,
    required this.initialSize,
  }) {
    this.position = position;
    size = Vector2.all(initialSize);
    priority = 100; // 前面に描画
  }

  @override
  void update(double dt) {
    super.update(dt);

    _lifetime += dt;

    // 寿命を超えたら削除
    if (_lifetime >= maxLifetime) {
      removeFromParent();
      return;
    }

    // 位置を更新（速度による移動）
    position += velocity * dt;

    // 重力効果（下方向への加速）
    if (type == ParticleType.burst) {
      velocity.y += 200 * dt; // 下向きの加速度
    }

    // サイズをフェードアウト
    final progress = _lifetime / maxLifetime;
    final currentSize = initialSize * (1 - progress);
    size = Vector2.all(currentSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final progress = _lifetime / maxLifetime;
    final alpha = (1 - progress).clamp(0.0, 1.0);

    switch (type) {
      case ParticleType.sparkle:
        _renderSparkle(canvas, alpha);
        break;
      case ParticleType.burst:
        _renderBurst(canvas, alpha);
        break;
      case ParticleType.star:
        _renderStar(canvas, alpha);
        break;
    }
  }

  /// キラキラパーティクルを描画
  void _renderSparkle(Canvas canvas, double alpha) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    // 十字型の輝き
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final radius = size.x / 2;

    // 縦線
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: radius * 0.3,
        height: radius * 2,
      ),
      paint,
    );

    // 横線
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: radius * 2,
        height: radius * 0.3,
      ),
      paint,
    );

    // 中心の円
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius * 0.5,
      paint..color = Colors.white.withValues(alpha: alpha * 0.8),
    );
  }

  /// 破裂パーティクルを描画
  void _renderBurst(Canvas canvas, double alpha) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
  }

  /// 星型パーティクルを描画
  void _renderStar(Canvas canvas, double alpha) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final radius = size.x / 2;

    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);

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

/// パーティクルエミッター（パーティクルを生成・管理）
class ParticleEmitter extends Component {
  final Vector2 position;
  final Color color;
  final ParticleType type;
  final int particleCount;
  final double spreadRadius;

  ParticleEmitter({
    required this.position,
    required this.color,
    required this.type,
    this.particleCount = 10,
    this.spreadRadius = 100.0,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final random = math.Random();

    // パーティクルを生成
    for (var i = 0; i < particleCount; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = random.nextDouble() * spreadRadius + 50;
      final velocity = Vector2(
        math.cos(angle) * speed,
        math.sin(angle) * speed,
      );

      final particleColor = _getParticleColor(random);
      final lifetime = random.nextDouble() * 0.5 + 0.5; // 0.5〜1.0秒
      final size = random.nextDouble() * 6 + 4; // 4〜10px

      final particle = Particle(
        position: position.clone(),
        velocity: velocity,
        color: particleColor,
        maxLifetime: lifetime,
        type: type,
        initialSize: size,
      );

      parent?.add(particle);
    }

    // エミッター自体はパーティクル生成後に削除
    removeFromParent();
  }

  /// パーティクルの色を取得（ランダムなバリエーション）
  Color _getParticleColor(math.Random random) {
    switch (type) {
      case ParticleType.sparkle:
        // キラキラは黄色〜白のグラデーション
        return [
          const Color(0xFFFFD700), // 金色
          const Color(0xFFFFE66D), // 明るい黄色
          Colors.white,
          const Color(0xFFFFB347), // オレンジ
        ][random.nextInt(4)];

      case ParticleType.burst:
        // 破裂は元の色のバリエーション
        return color;

      case ParticleType.star:
        // 星は白〜黄色
        return random.nextBool() ? Colors.white : const Color(0xFFFFE66D);
    }
  }
}
