import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokaverkfni/backGround/border.dart';
import 'player/playerClass.dart';

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

enum MovementState {
  idle(0, 0),
  movingUp(0, -1),
  movingDown(0, 1),
  movingRight(1, 0),
  movingLeft(-1, 0);

  final double xDirection;
  final double yDirection;

  const MovementState(this.xDirection, this.yDirection);
}

class MyGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late SpriteAnimation downAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation idleAnimation;
  late Player player;
  late SpriteComponent background;

  final double zoomLevel = 1.3;
  final double characterSize = 100;
  final Set<LogicalKeyboardKey> _keysPressed = {};

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
      print('Background loaded: ${background.size}');
    } catch (e) {
      print('Error loading background: $e');
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

      player = Player()
        ..animation = idleAnimation
        ..position = Vector2(1200, 700)
        ..size = Vector2.all(characterSize);

      print('Player loaded at position: ${player.position}');
    } catch (e) {
      print('Error loading sprite sheet or animations: $e');
    }


    world.add(background);
    world.add(player);

    final topBorder = MyBorder(
      size: Vector2(1352, 40),
      position: Vector2(0, 292),
    );

    world.add(topBorder);

    // Set up camera
    try {
      await add(world);
      camera = CameraComponent.withFixedResolution(
        world: world,
        width: size.x / zoomLevel,
        height: size.y / zoomLevel,
      );
      camera.follow(player);
      
      add(camera);
    } catch (e) {
      print('Error setting up camera: $e');
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
  super.onGameResize(gameSize);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keysPressed.clear();
    _keysPressed.addAll(keysPressed);

    // Update movement state and velocity
    player.velocity = Vector2.zero();
    player.movementState = MovementState.idle;

    if (_keysPressed.contains(LogicalKeyboardKey.keyW)) {
      player.movementState = MovementState.movingUp;
      player.velocity.y -= player.moveSpeed;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyS)) {
      player.movementState = MovementState.movingDown;
      player.velocity.y += player.moveSpeed;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyA)) {
      player.movementState = MovementState.movingLeft;
      player.velocity.x -= player.moveSpeed;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyD)) {
      player.movementState = MovementState.movingRight;
      player.velocity.x += player.moveSpeed;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyF)) {
      print('Player position: ${player.position}');
    }

    // Update player animation based on movement state
    switch (player.movementState) {
      case MovementState.idle:
        player.animation = idleAnimation;
        break;
      case MovementState.movingDown:
        player.animation = downAnimation;
        break;
      case MovementState.movingUp:
        player.animation = upAnimation;
        break;
      case MovementState.movingRight:
        player.animation = rightAnimation;
        break;
      case MovementState.movingLeft:
        player.animation = leftAnimation;
        break;
    }

    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}