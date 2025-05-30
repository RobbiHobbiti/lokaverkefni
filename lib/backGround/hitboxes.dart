import 'package:flame/components.dart';
import 'package:flame/collisions.dart';


// veggur upp frá spawninu
final wall = Wall(position: Vector2(570, 304), size: Vector2(1170, 70));

class Wall extends PositionComponent with CollisionCallbacks {
  late final RectangleHitbox hitbox;

  Wall({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    add(RectangleHitbox(size: size)); // Use constructor size
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('Wall collided with: $other at $intersectionPoints');
  }
}


// Sign hitboxið hjá spawninu
final Sign = sign(position: Vector2(1047, 562), size: Vector2(65, 65));

class sign extends PositionComponent with CollisionCallbacks {
  late final RectangleHitbox hitbox;

  sign({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    add(RectangleHitbox(size: size)); // Use constructor size
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('Sign collided with: $other at $intersectionPoints');
  }
}

final SmallWater = smallWater(position: Vector2(771, 616), size: Vector2(203, 110));

class smallWater extends PositionComponent with CollisionCallbacks {
  late final RectangleHitbox hitbox;

  smallWater({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    add(RectangleHitbox(size: size)); // Use constructor size
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('smallWater collided with: $other at $intersectionPoints');
  }
}

final Puddle = puddle(position: Vector2(537, 706), size: Vector2(150, 130));

class puddle extends PositionComponent with CollisionCallbacks {
  late final RectangleHitbox hitbox;

  puddle({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    add(RectangleHitbox(size: size)); // Use constructor size
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('puddle collided with: $other at $intersectionPoints');
  }
}

final BottomBridge = bottomBridge(position: Vector2(767, 842), size: Vector2(209, 85));

class bottomBridge extends PositionComponent with CollisionCallbacks {
  late final RectangleHitbox hitbox;

  bottomBridge({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    add(RectangleHitbox(size: size)); // Use constructor size
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('bottomBrú collided with: $other at $intersectionPoints');
  }
}

final BigWater = bigWater(position: Vector2(767, 928), size: Vector2(970, 430));

class bigWater extends PositionComponent with CollisionCallbacks {
  late final RectangleHitbox hitbox;

  bigWater({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    add(RectangleHitbox(size: size)); // Use constructor size
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('bigWater collided with: $other at $intersectionPoints');
  }
}

final WaterLeft = waterLeft(position: Vector2(1522, 666), size: Vector2(215, 262));

class waterLeft extends PositionComponent with CollisionCallbacks {
  late final RectangleHitbox hitbox;

  waterLeft({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    add(RectangleHitbox(size: size)); // Use constructor size
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('waterleft collided with: $other at $intersectionPoints');
  }
}