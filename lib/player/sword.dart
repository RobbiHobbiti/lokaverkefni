import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:lokaverkfni/player/playerClass.dart';

class SwordComponent extends SpriteComponent with CollisionCallbacks {
  SwordComponent({required Sprite sprite, required Vector2 position})
      : super(sprite: sprite, size: Vector2(100, 100), position: position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    debugMode = true;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      other.inventory.add('sword');
      removeFromParent(); // Remove sword from world
      print('Sword collected! Inventory: ${other.inventory}');
    }
  }
}