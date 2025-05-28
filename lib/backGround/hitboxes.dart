import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

// x 537 y 292


 final wall = Wall(
  position: Vector2(537, 292),
  size: Vector2(1100, 40),
 );

class Wall extends SpriteComponent with CollisionCallbacks {
  Wall({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

   @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('wall.png');
    add(RectangleHitbox());
  }


  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('Wall collided with: $other');
  }
}