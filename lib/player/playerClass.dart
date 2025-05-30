import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:lokaverkfni/backGround/borders.dart';
import 'package:lokaverkfni/backGround/hitboxes.dart';



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

class Player extends SpriteAnimationComponent with CollisionCallbacks {

  MovementState movementState = MovementState.idle;
  Vector2 velocity = Vector2.zero();
  final double moveSpeed = 150;
  late RectangleHitbox hitbox;
  late Vector2 previousPosition;

  Player() : super(size: Vector2(100, 100), position: Vector2(1200, 700));


  // Movement handeling
  void handleMovement(
  Set<LogicalKeyboardKey> keysPressed, {
  required SpriteAnimation idleAnimation,
  required SpriteAnimation upAnimation,
  required SpriteAnimation downAnimation,
  required SpriteAnimation leftAnimation,
  required SpriteAnimation rightAnimation,
}) {
  velocity = Vector2.zero();
  movementState = MovementState.idle;

  if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
    movementState = MovementState.movingUp;
    velocity.y -= moveSpeed;
  }
  if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
    movementState = MovementState.movingDown;
    velocity.y += moveSpeed;
  }
  if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
    movementState = MovementState.movingLeft;
    velocity.x -= moveSpeed;
  }
  if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
    movementState = MovementState.movingRight;
    velocity.x += moveSpeed;
  }
  if (keysPressed.contains(LogicalKeyboardKey.keyF)) {
    print('Player position: $position');
  }

  // Update animation
  switch (movementState) {
    case MovementState.idle:
      animation = idleAnimation;
      break;
    case MovementState.movingDown:
      animation = downAnimation;
      break;
    case MovementState.movingUp:
      animation = upAnimation;
      break;
    case MovementState.movingRight:
      animation = rightAnimation;
      break;
    case MovementState.movingLeft:
      animation = leftAnimation;
      break;
    }
  }


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final hitboxSize = size * 0.7; // hitbox stærð
    final hitboxPosition = (size - hitboxSize) / 2; // miðja hitbox
    hitbox = RectangleHitbox(position: hitboxPosition, size: hitboxSize);
    add(hitbox);
    debugMode = true; // Optional, to visualize the hitbox
  }
  
// previousPosition er fyrir collision stopping
  @override
  void update(double dt) {
    super.update(dt);
    previousPosition = position.clone();
    position += velocity * dt;
  }


// Collision handling
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is MyTopBorder ||
        other is MyBottomBorder ||
        other is MyLeftBorder ||
        other is MyRightBorder ||
        other is Wall ||
        other is sign||
        other is smallWater||
        other is puddle||
        other is bottomBridge||
        other is bigWater||
        other is waterLeft) {
      // Reset position and velocity on collision
        position = previousPosition;
        velocity = Vector2.zero();
      final playerRect = hitbox.toAbsoluteRect();
      final borderRect = other.children
          .whereType<RectangleHitbox>()
          .first
          .toAbsoluteRect();
      final overlapX = (min(playerRect.right, borderRect.right) -
          max(playerRect.left, borderRect.left))
        .clamp(0.0, double.infinity);
      final overlapY = (min(playerRect.bottom, borderRect.bottom) -
          max(playerRect.top, borderRect.top))
        .clamp(0.0, double.infinity);
      if (overlapX > 0 && overlapY > 0) {
        if (overlapX < overlapY) {
          // Collided horizontally, correct X
          if (playerRect.center.dx < borderRect.center.dx) {
            position.x -= overlapX;
          } else {
            position.x += overlapX;
          }
          velocity.x = 0;
        } else {
          // Collided vertically, correct Y
          if (playerRect.center.dy < borderRect.center.dy) {
            position.y -= overlapY;
          } else {
            position.y += overlapY;
          }
          velocity.y = 0;
        }
      }
    }
    final normal = (position - other.position).normalized();
    if (velocity.dot(normal) < 0) {
      velocity -= normal.scaled(velocity.dot(normal));
    }
    print('Player collision at: $intersectionPoints, velocity: $velocity');
  }


  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }
}