import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_work_shop/evil_rocket.dart';
import 'package:flame_work_shop/player.dart';
import 'package:flame_work_shop/sky_background.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class SkyGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late PlayerComponent playerComponent;
  late Stream rocketsTimer;
  late StreamSubscription _rocketTimerSubscription;
  int score = 0;

  @override
  void onLoad() {
    startGame();
  }

  void startGame() {
    score = 0;
    removeAll(children);

    playerComponent = PlayerComponent();

    add(SkyBackgroundComponent());
    add(playerComponent);

    rocketsTimer = Stream.periodic(const Duration(seconds: 2), (timer) {
      Random random = Random();
      double yDelta = random.nextDouble();

      final rocket = EvilRocketComponent(
        position: Vector2(size.x, size.y * yDelta),
      );
      add(rocket);
    });
    _rocketTimerSubscription = rocketsTimer.listen((event) {});
  }

  void finishGame() {
    _rocketTimerSubscription.cancel();
    removeAll(children);
    add(
      TextComponent(
        text: 'GAME OVER your score is $score, \n Press r to restart',
        position: Vector2(size.x/2 - 400, size.y/2),
        textRenderer: TextPaint(
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
      ),
    );
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowDown:
          playerComponent.state = MovingState.down;

        case LogicalKeyboardKey.arrowUp:
          playerComponent.state = MovingState.up;

        case LogicalKeyboardKey.arrowLeft:
          playerComponent.state = MovingState.left;

        case LogicalKeyboardKey.arrowRight:
          playerComponent.state = MovingState.right;

        case LogicalKeyboardKey.space:
          playerComponent.shoot();

        case LogicalKeyboardKey.keyR:
          startGame();
      }
    } else {
      playerComponent.state = MovingState.still;
    }
    return KeyEventResult.handled;
  }
}
