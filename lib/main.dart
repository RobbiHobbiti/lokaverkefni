import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokaverkfni/backGround/borders.dart';
import 'package:lokaverkfni/backGround/hitboxes.dart';
import 'player/playerClass.dart';
import 'player/sword.dart';
import 'player/inventory.dart';


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
            overlayBuilderMap: {
              'Inventory': (context, game) => InventoryOverlay(player: (game as MyGame).player),
            },
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

    // Load sword
    try {
      final Sprite swordSprite = await loadSprite('sword.png');
      final sword = SwordComponent(
        sprite: swordSprite,
        position: Vector2(1200, 500),
      )
      ..priority = 1;
      world.add(sword);
      print('Sword loaded: ${sword.position}');
    } catch (e) {
      print('Error loading sword sprite: $e');
    }



  // Border hitboxin
    final topBorder = MyTopBorder(
      size: Vector2(2600, 40),
      position: Vector2(0, -40),
    );

    final bottomBorder = MyBottomBorder(
      size: Vector2(2600, 40),
      position: Vector2(0, size.y),
    );

    final leftBorder = MyLeftBorder(
      size: Vector2(40, size.y + 40),
      position: Vector2(-40, -40),
    );

    final rightBorder = MyRightBorder(
      size: Vector2(40, size.y + 40),
      position: Vector2(size.x, -40),
    );

    // Adda öllum hitboxum/player/backgroundi í world
    world.add(background);
    world.add(player);
    world.add(topBorder);
    world.add(bottomBorder);
    world.add(leftBorder);
    world.add(rightBorder);
    world.add(wall);
    world.add(Sign);
    world.add(SmallWater);
    world.add(Puddle);
    world.add(BottomBridge);
    world.add(BigWater);
    world.add(WaterLeft);


    // Set up camera
    try {
      // Adda wrrold inní leikinn
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
    super.onKeyEvent(event, keysPressed);
    _keysPressed.clear();
    _keysPressed.addAll(keysPressed);

  if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyF) {
    player.inventoryOpen = !player.inventoryOpen;
    if (player.inventoryOpen) {
      overlays.add('Inventory');
    } else {
      overlays.remove('Inventory');
    }
  }

    player.handleMovement(
      _keysPressed,
      idleAnimation: idleAnimation,
      upAnimation: upAnimation,
      downAnimation: downAnimation,
      leftAnimation: leftAnimation,
      rightAnimation: rightAnimation,
    );

    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}