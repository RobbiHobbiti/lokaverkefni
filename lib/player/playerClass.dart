import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:lokaverkfni/backGround/hitboxes.dart';
import 'package:lokaverkfni/main.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks {

  MovementState movementState = MovementState.idle;
  Vector2 velocity = Vector2.zero();
  final double moveSpeed = 150;
  late RectangleHitbox hitbox;

  Player() : super(size: Vector2(100, 100), position: Vector2(1200, 700));

  

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final hitboxSize = size * 0.8;
    final hitboxPosition = (size - hitboxSize) / 2;
    hitbox = RectangleHitbox(position: hitboxPosition, size: hitboxSize);
    add(hitbox);
    debugMode = true; // Optional, to visualize the hitbox
  }
  

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollisionStart(intersectionPoints, other);
  if (other is Wall) {
    final playerRect = hitbox.toAbsoluteRect();
    final wallRect = other.hitbox.toAbsoluteRect();
    final overlapX = min(playerRect.right, wallRect.right) - max(playerRect.left, wallRect.left).clamp(0.0, double.infinity);
    final overlapY = min(playerRect.bottom, wallRect.bottom) - max(playerRect.top, wallRect.top).clamp(0.0, double.infinity);
    if (overlapX > 0 && overlapY > 0) {
      if (overlapX < overlapY) {
        if (position.x < other.position.x) {
          position.x -= overlapX;
        } else {
          position.x += overlapX;
        }
      } else {
        if (position.y < other.position.y) {
          position.y -= overlapY;
        } else {
          position.y += overlapY;
        }
      }
    }
    final normal = (position - other.position).normalized();
    if (velocity.dot(normal) < 0) {
      velocity -= normal.scaled(velocity.dot(normal));
    }
    print('Player collision at: $intersectionPoints, velocity: $velocity');
  }
}

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }
}
