import 'package:flame/components.dart';
import 'package:lokaverkfni/main.dart';
import 'package:lokaverkfni/player/playerClass.dart';
import 'package:lokaverkfni/backGround/hitboxes.dart';
import 'package:flame/collisions.dart';

class MyBorder extends PositionComponent with CollisionCallbacks {
  MyBorder({required Vector2 size,Vector2? position,}) : 
  super(size: size,position: position ?? Vector2.zero(),);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    debugMode = true; // Shows the hitbox for debugging
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      print('Player collided with border at $intersectionPoints');
    }
  }
}