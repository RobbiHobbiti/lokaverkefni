import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/collisions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FocusableActionDetector(
          autofocus: true,
          onFocusChange: (hasFocus) {
            print('Focus changed: $hasFocus');
          },
          child: GameWidget(
            game: MyGame(),
          ),
        ),
      ),
    );
  }
}


class MyGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late SpriteAnimation downAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation idleAnimation;

  late SpriteAnimationComponent player;
  late SpriteComponent background;
  final double moveSpeed = 200;
  final Set<LogicalKeyboardKey> _keysPressed = {};
  final double zoomLevel = 1.5;
  final double characterSize = 100;

  // 0 = idle, 1 = down, 2 = up, 3 = right, 4 = left
  int direction = 0;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    // Load background
    try {
      final Sprite backgroundSprite = await loadSprite('demoBackground.png');
      background = SpriteComponent(
        sprite: backgroundSprite,
        size: size,
        position: Vector2(0, 0),
      );
      add(background);
      print('Background loaded: ${background.size}');
    } catch (e) {
      print('Error loading background: $e');
      add(background);
    }

    // Load sprite sheet
    try {
      final SpriteSheet spriteSheet = SpriteSheet(
        image: await images.load('runAnimation.png'),
        srcSize: Vector2(40, 40),
      );

      // Create animations for each direction
      downAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.09, from: 1, to: 6);
      upAnimation = spriteSheet.createAnimation(row: 1, stepTime: 0.09, from: 1, to: 6);
      rightAnimation = spriteSheet.createAnimation(row: 2, stepTime: 0.09, from: 1, to: 6);
      leftAnimation = spriteSheet.createAnimation(row: 3, stepTime: 0.09, from: 1, to: 6);
      idleAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.09, from: 0, to: 1);

      player = SpriteAnimationComponent()
        ..animation = idleAnimation
        ..position = Vector2(1280, 675)
        ..size = Vector2.all(characterSize);

      add(player);
      print('Player loaded at position: ${player.position}');
    } catch (e) {
      print('Error loading sprite sheet or animations: $e');
      
    }

    // Set up camera
    try {
      await add(world ..add(background)..add(player));
      camera = CameraComponent.withFixedResolution(
        world: world,
        width: size.x / zoomLevel,
        height: size.y / zoomLevel,
      );
      camera.follow(player);
      camera.viewfinder.zoom = zoomLevel;
      add(camera);
    } catch (e) {
      print('Error setting up camera: $e');
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    print('Keys pressed: $keysPressed');
    _keysPressed.clear();
    _keysPressed.addAll(keysPressed);
    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Reset direction to idle
    direction = 0;
    Vector2 velocity = Vector2.zero();

    // Check which keys are pressed
    if (_keysPressed.contains(LogicalKeyboardKey.keyW)) {
      direction = 2; // Up
      velocity.y -= moveSpeed;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyS)) {
      direction = 1; // Down
      velocity.y += moveSpeed;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyA)) {
      direction = 4; // Left
      velocity.x -= moveSpeed;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyD)) {
      direction = 3; // Right
      velocity.x += moveSpeed;
    }

    // Update player animation based on direction
    switch (direction) {
      case 0:
        player.animation = idleAnimation;
        break;
      case 1:
        player.animation = downAnimation;
        break;
      case 2:
        player.animation = upAnimation;
        break;
      case 3:
        player.animation = rightAnimation;
        break;
      case 4:
        player.animation = leftAnimation;
        break;
    }

    // Update player position
    player.position += velocity * dt;
  }
}