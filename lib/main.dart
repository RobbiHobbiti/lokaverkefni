import 'dart:async';
import 'package:lokaverkfni/backGround/hitboxes.dart';
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


class Player extends SpriteAnimationComponent with CollisionCallbacks {
  bool isColliding = false;
  Vector2 velocity = Vector2.zero();

  Player() : super(size: Vector2(50, 50), position: Vector2(100, 100));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isColliding) {
      position += velocity * dt;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    isColliding = true;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    isColliding = false;
  }
}

class MyGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late SpriteAnimation downAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation idleAnimation;
  late Player player;
  late SpriteComponent playerSprite;
  late SpriteComponent background;
  final double moveSpeed = 100;
  final Set<LogicalKeyboardKey> _keysPressed = {};
  final double zoomLevel = 1.3;
  final double characterSize = 100;



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
      print('Background loaded: ${background.size}');
    } catch (e) {
      print('Error loading background: $e');;
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
    
    world.add((background)..add(player)..add(wall));

    // Set up camera
    try {
      await add(world);
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
      if (_keysPressed.contains(LogicalKeyboardKey.keyF)) {
        print('${player.position}'); // Idle
    }

    player.velocity = velocity;

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
  }
}