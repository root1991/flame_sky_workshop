import 'package:flame_work_shop/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  runApp(GameWidget.controlled(gameFactory: SkyGame.new));
}
