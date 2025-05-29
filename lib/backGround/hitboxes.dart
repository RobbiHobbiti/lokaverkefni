import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

final wall = Wall(position: Vector2(570, 304), size: Vector2(1170, 80));

class Wall extends SpriteComponent with CollisionCallbacks {
  Wall({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('wall.png');
    add(RectangleHitbox(size: size)); // Use constructor size
    debugMode = true; // Visualize hitbox
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('Wall collided with: $other at $intersectionPoints');
  }
}