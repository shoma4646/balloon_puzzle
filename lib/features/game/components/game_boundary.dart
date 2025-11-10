import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/forge2d.dart' as forge2d;

/// ゲーム境界（画面の端）
class GameBoundary extends BodyComponent {
  final Vector2 size;

  GameBoundary({required this.size});

  @override
  Body createBody() {
    final bodyDef = forge2d.BodyDef(
      position: Vector2.zero(),
      type: forge2d.BodyType.static,
    );

    final body = world.createBody(bodyDef);

    final wallThickness = 1.0;

    // 左の壁
    final leftWall = forge2d.EdgeShape()
      ..set(
        Vector2(0, 0),
        Vector2(0, size.y),
      );
    body.createFixture(forge2d.FixtureDef(leftWall));

    // 右の壁
    final rightWall = forge2d.EdgeShape()
      ..set(
        Vector2(size.x, 0),
        Vector2(size.x, size.y),
      );
    body.createFixture(forge2d.FixtureDef(rightWall));

    // 下の壁
    final bottomWall = forge2d.EdgeShape()
      ..set(
        Vector2(0, size.y),
        Vector2(size.x, size.y),
      );
    body.createFixture(forge2d.FixtureDef(bottomWall));

    return body;
  }
}
