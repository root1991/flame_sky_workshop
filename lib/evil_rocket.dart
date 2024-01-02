import 'package:flame/components.dart';
import 'package:flame_work_shop/bullet.dart';
import 'package:flame_work_shop/game.dart';
import 'package:flame/collisions.dart';

class EvilRocketComponent extends SpriteAnimationComponent
    with HasGameRef<SkyGame>, CollisionCallbacks {
  EvilRocketComponent({super.position});

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    size = Vector2(170, 100);

    animation = await game.loadSpriteAnimation(
      'rocket.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.1,
        textureSize: Vector2.all(800),
      ),
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x -= 300 * dt;

    if (position.x < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is BulletComponent) {
      removeFromParent();
      game.score++;
    }
  }
}
