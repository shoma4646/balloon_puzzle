import 'package:flame/components.dart' hide Vector2;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart' as forge2d;
import 'package:vector_math/vector_math.dart' as vm;

import '../../domain/entities/balloon_type.dart';
import '../../../../core/constants/game_constants.dart';
import '../effects/effect_factory.dart';

/// 風船コンポーネント
class BalloonComponent extends BodyComponent {
  @override
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
    final buoyancyMultiplier =
        balloonType.sizeMultiplier * balloonType.sizeMultiplier;
    final buoyancy =
        Vector2(0, -GameConstants.buoyancyForce * buoyancyMultiplier);
    body.applyForce(buoyancy);

    // 初速度（横方向のランダムな微小速度）
    final randomVelocityX =
        (DateTime.now().microsecondsSinceEpoch % 100 - 50) / 100.0;
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
    final buoyancyMultiplier =
        balloonType.sizeMultiplier * balloonType.sizeMultiplier;
    final buoyancy =
        Vector2(0, -GameConstants.buoyancyForce * buoyancyMultiplier);
    body.applyForce(buoyancy);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final radius = balloonType.size / 2;

    // 1. 光るグラデーション（メインの球体）
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          balloonType.color.withOpacity(0.8),
          balloonType.color,
        ],
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    canvas.drawCircle(Offset.zero, radius, paint);

    // 2. 内部の光沢（ハイライト）
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.7),
          Colors.transparent,
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    canvas.drawCircle(Offset.zero, radius, highlightPaint);

    // 3. 外側の発光（グロー効果）
    // 注: Canvasでのシャドウ描画はコストが高いので、必要に応じて調整
    final shadowPath = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));
    canvas.drawShadow(
      shadowPath,
      balloonType.color.withOpacity(0.6),
      10.0, // elevation
      true, // transparentOccluder
    );

    // 4. 縁取り（薄く）
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset.zero, radius, borderPaint);

    // 5. レベル表示
    final textPainter = TextPainter(
      text: TextSpan(
        text: balloonType.level.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: balloonType.color.withOpacity(0.8),
              blurRadius: 10,
            ),
            const Shadow(
              color: Colors.black26,
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
          // エフェクト追加
          // Vector2(64) -> Vector2(standard) 変換
          parent?.add(EffectFactory.createPopEffect(
            position: vm.Vector2(body.position.x, body.position.y),
            color: balloonType.color,
          ));

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
            // エフェクト追加
            // Vector2(64) -> Vector2(standard) 変換
            parent?.add(EffectFactory.createMergeEffect(
              position: vm.Vector2(midPosition.x, midPosition.y),
              color: balloonType.color,
            ));

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
