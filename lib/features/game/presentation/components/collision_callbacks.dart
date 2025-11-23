import 'package:flame_forge2d/flame_forge2d.dart';
import 'balloon_component.dart';

/// 衝突コールバック
class BalloonContactListener extends ContactListener {
  @override
  void beginContact(Contact contact) {
    final fixtureA = contact.fixtureA;
    final fixtureB = contact.fixtureB;

    final bodyA = fixtureA.body;
    final bodyB = fixtureB.body;

    final userDataA = bodyA.userData;
    final userDataB = bodyB.userData;

    // 両方が風船コンポーネントの場合
    if (userDataA is BalloonComponent && userDataB is BalloonComponent) {
      userDataA.onCollisionWithBalloon(userDataB);
    }
  }

  @override
  void endContact(Contact contact) {
    // 必要に応じて実装
  }

  @override
  void preSolve(Contact contact, Manifold oldManifold) {
    // 必要に応じて実装
  }

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {
    // 必要に応じて実装
  }
}
