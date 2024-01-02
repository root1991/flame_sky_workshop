import 'package:flame/components.dart';
import 'package:flame_work_shop/evil_rocket.dart';
import 'package:flame_work_shop/game.dart';
import 'package:flame/collisions.dart';

class BulletComponent extends SpriteAnimationComponent
    with HasGameRef<SkyGame>, CollisionCallbacks {
  BulletComponent({super.position});

  static const BULLET_SPEED = 300;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    size = Vector2(120, 50);

    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.1,
        textureSize: Vector2.all(450),
      ),
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x += BULLET_SPEED * dt;

    if (position.x > game.size.x) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EvilRocketComponent) {
      removeFromParent();
    }
  }
}
