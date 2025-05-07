import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
    runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {

  SpriteAnimationComponent player = SpriteAnimationComponent(size: Vector2(120 * 5, 80 * 5));

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    loadAnimation();

    add(player);
  }

  Future<void> loadAnimation() async {
    SpriteSheet spriteSheet = SpriteSheet(
      image: await images.load('_attackCombo2hit.png'), srcSize: Vector2(120, 80),
    );
    SpriteAnimation animation = spriteSheet.createAnimation(
      row: 0, stepTime: 0.05, from: 1, to: 9,
    );

    player.animation = animation;

  }

}