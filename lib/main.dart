import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
    runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {

  SpriteAnimationComponent player = SpriteAnimationComponent(size: Vector2(40 * 5, 40 * 5));

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    loadAnimation();

    add(player);
  }

  Future<void> loadAnimation() async {
    SpriteSheet spriteSheet = SpriteSheet(
      image: await images.load('run_down_40x40.png'), srcSize: Vector2(40, 40),
    );
    SpriteAnimation animation = spriteSheet.createAnimation(
      row: 0, stepTime: 0.09, from: 1, to: 6,
    );

    player.animation = animation;

  }

}