import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class SkyBackgroundComponent extends ParallaxComponent {
  @override
  Future<void> onLoad() async {
    final parallaxImages = [
      game.loadParallaxImage(
        'sky.png',
        filterQuality: FilterQuality.none,
        repeat: ImageRepeat.repeat,
      ),
      game.loadParallaxImage(
        'cloud.png',
        filterQuality: FilterQuality.none,
        repeat: ImageRepeat.repeat,
      ),
      game.loadParallaxImage(
        'small_cloud.png',
        filterQuality: FilterQuality.none,
        repeat: ImageRepeat.repeat,
      ),
    ];

    final result = await Future.wait(parallaxImages);

    final layers = result.map(
      (image) => ParallaxLayer(
        image,
        velocityMultiplier: Vector2(4.0, 0),
      ),
    ).toList();

    parallax = Parallax(layers, baseVelocity: Vector2(10.0, 0));
  }
}
