import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart' as forge2d;
import '../../../models/balloon_type.dart';
import '../../../shared/constants/game_constants.dart';

/// 風船コンポーネント
class BalloonComponent extends BodyComponent {
  final Vector2 position;
  final BalloonType balloonType;
  final Function(BalloonType fromType, BalloonType toType) onMerge;
  final VoidCallback onPop;

  bool _isMarkedForRemoval = false;

  BalloonComponent({
    required this.position,
    required this.balloonType,
    required this.onMerge,
    required this.onPop,
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
      type: forge2d.BodyType.dynamic,
      userData: this,
    );

    final body = world.createBody(bodyDef);

    // 円形の形状を作成
    final radius = balloonType.size / 2;
    final shape = forge2d.CircleShape()..radius = radius;

    final fixtureDef = forge2d.FixtureDef(
      shape,
      density: 0.1,
      friction: 0.3,
      restitution: 0.5, // 跳ね返り係数
    );

    body.createFixture(fixtureDef);

    // 浮力を適用（上向きの力）
    // サイズの二乗に比例させることで、大きい風船がより速く上昇
    final buoyancyMultiplier = balloonType.sizeMultiplier * balloonType.sizeMultiplier;
    final buoyancy = Vector2(0, -GameConstants.buoyancyForce * buoyancyMultiplier);
    body.applyForce(buoyancy);

    // 初速度（横方向のランダムな微小速度）
    final randomVelocityX = (DateTime.now().microsecondsSinceEpoch % 100 - 50) / 100.0;
    body.linearVelocity = Vector2(randomVelocityX, 0);

    return body;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 空気抵抗をシミュレート
    final velocity = body.linearVelocity;
    body.linearVelocity = velocity * GameConstants.airResistance;

    // 継続的に浮力を適用（Y軸は下向きが正なので、負の値で上向きの力）
    // サイズの二乗に比例させることで、大きい風船がより速く上昇
    final buoyancyMultiplier = balloonType.sizeMultiplier * balloonType.sizeMultiplier;
    final buoyancy = Vector2(0, -GameConstants.buoyancyForce * buoyancyMultiplier);
    body.applyForce(buoyancy);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final radius = balloonType.size / 2;

    // 風船を描画
    final paint = Paint()
      ..color = balloonType.color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, radius, paint);

    // 縁取り
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset.zero, radius, borderPaint);

    // レベル表示
    final textPainter = TextPainter(
      text: TextSpan(
        text: balloonType.level.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(
              color: Colors.black45,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  /// 他の風船と衝突した時の処理
  void onCollisionWithBalloon(BalloonComponent other) {
    // 既に削除予定の場合はスキップ
    if (_isMarkedForRemoval || other._isMarkedForRemoval) return;

    // 同じタイプの風船同士が衝突
    if (balloonType == other.balloonType) {
      // 最大レベルの風船同士が衝突した場合は消滅
      if (balloonType.isMaxLevel) {
        _isMarkedForRemoval = true;
        other._isMarkedForRemoval = true;

        // Forge2Dのワールドがロックされている可能性があるため、全ての操作を次のフレームで実行
        Future.microtask(() {
          removeFromParent();
          other.removeFromParent();
          onPop();
        });
      } else {
        // マージ処理
        final nextLevel = balloonType.nextLevel;
        if (nextLevel != null) {
          _isMarkedForRemoval = true;
          other._isMarkedForRemoval = true;

          // 2つの風船の中間位置に新しい風船を生成
          final midPosition = (body.position + other.body.position) / 2;

          // Forge2Dのワールドがロックされている可能性があるため、全ての操作を次のフレームで実行
          Future.microtask(() {
            final newBalloon = BalloonComponent(
              position: midPosition,
              balloonType: nextLevel,
              onMerge: onMerge,
              onPop: onPop,
            );

            // 親ゲームに追加
            parent?.add(newBalloon);

            // 古い風船を削除
            removeFromParent();
            other.removeFromParent();

            // マージコールバック
            onMerge(balloonType, nextLevel);
          });
        }
      }
    }
  }

  /// マージ予定フラグを取得
  bool get isMarkedForRemoval => _isMarkedForRemoval;
}
