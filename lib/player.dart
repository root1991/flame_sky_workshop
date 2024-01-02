import 'package:flame/components.dart';
import 'package:flame_work_shop/bullet.dart';
import 'package:flame_work_shop/evil_rocket.dart';
import 'package:flame_work_shop/game.dart';
import 'package:flame/collisions.dart';

class PlayerComponent extends SpriteAnimationComponent
    with HasGameRef<SkyGame>, CollisionCallbacks {
  MovingState state = MovingState.still;
  static const MOVEMENT_SPEED = 1000;
  int _lives = 3;
  late SpriteAnimation _explotionAnimation;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    position = game.size / 2;

    size = Vector2(200, 170);

    animation = await game.loadSpriteAnimation(
      'plane_sprite.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.1,
        textureSize: Vector2.all(450),
      ),
    );
    _explotionAnimation = await game.loadSpriteAnimation(
      'purple_explosion.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );
    add(RectangleHitbox(anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (state) {
      case MovingState.up:
        moveUp(dt);

      case MovingState.down:
        moveDown(dt);

      case MovingState.right:
        moveRight(dt);

      case MovingState.left:
        moveLeft(dt);

      case MovingState.still:
      // Nothing
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is EvilRocketComponent) {
      _lives--;
      other.removeFromParent();
    }
    if (_lives == 0) {
      animation = _explotionAnimation;
      Future.delayed(const Duration(milliseconds: 500), () {
        removeFromParent();
        game.finishGame();
      });
    }
  }

  void moveUp(double dt) {
    position.y -= MOVEMENT_SPEED * dt;
  }

  void moveDown(double dt) {
    position.y += MOVEMENT_SPEED * dt;
  }

  void moveRight(double dt) {
    position.x += MOVEMENT_SPEED * dt;
  }

  void moveLeft(double dt) {
    position.x -= MOVEMENT_SPEED * dt;
  }

  void shoot() {
    game.add(
      BulletComponent(
        position: Vector2(position.x + 100, position.y + 20),
      ),
    );
  }
}

enum MovingState { still, up, down, right, left }
