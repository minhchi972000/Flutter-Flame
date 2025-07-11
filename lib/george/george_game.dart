import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';

class GeorgeGame extends FlameGame with HasKeyboardHandlerComponents, TapDetector, HasCollisionDetection {
  GeorgeGame();

  late SpriteAnimation downAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation idleAnimation;

  late GeorgeComponent george;
  // late SpriteComponent background;
  late double mapWidth;
  late double mapHeight;
  late final CameraComponent cameraComponent;

  // 0=idle, 1=down, 2=left, 3=up, 4=right
  int direction = 0;
  double animationSpeed = 0.1;
  final double characterSize = 100;
  final double characterSpeed = 80;

  Future<void> startBgmMusic() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('music.mp3');
  }

  String soundStrackName() {
    return FlameAudio.bgm.audioPlayer.source.toString();
  }

  @override
  FutureOr<void> onLoad() async {
    final homeMap = await TiledComponent.load('george/map.tmx', Vector2.all(16));

    // add(homeMap);

    mapWidth = homeMap.tileMap.map.width * 16;
    mapHeight = homeMap.tileMap.map.height * 16;

    // final backgroundSprite = Sprite(await images.load("george/background.png"));
    // background =
    //     SpriteComponent()
    //       ..sprite = backgroundSprite
    //       ..size = backgroundSprite.originalSize;
    // add(background);
    startBgmMusic();
    overlays.add('ButtonController');

    final spriteSheet = SpriteSheet(image: await images.load("george/george2.png"), srcSize: Vector2(48, 48));

    downAnimation = spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);
    upAnimation = spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 4);
    leftAnimation = spriteSheet.createAnimation(row: 2, stepTime: animationSpeed, to: 4);
    rightAnimation = spriteSheet.createAnimation(row: 3, stepTime: animationSpeed, to: 4);
    idleAnimation = spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 1);

    george =
        GeorgeComponent()
          ..animation = idleAnimation
          ..position = Vector2(100, 200)
          ..size = Vector2.all(characterSize);
    add(george);

    // Create the world and add components
    final world = World();
    await add(world);
    // await world.add(background);
    await world.add(george);

    // Set up the camera
    cameraComponent = CameraComponent(world: world);
    cameraComponent.follow(george); // Make the camera follow george
    cameraComponent.setBounds(Rectangle.fromLTRB(0, 0, mapWidth, mapHeight)); // Set the bounds to the background size

    await add(cameraComponent);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // canvas.drawRect(
    //   Rectangle(0, 0, 100, 100),
    //   Paint()..color = Color.fromARGB(255, 255, 0, 0),
    // );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 0=idle, 1=down, 2=left, 3=up, 4=right
    switch (direction) {
      case 0:
        george.animation = idleAnimation;
        break;
      case 1:
        george.animation = downAnimation;
        if (george.y < mapHeight - george.height) {
          george.y += characterSpeed * dt;
        }
        break;
      case 2:
        george.animation = leftAnimation;
        if (george.x > 0) {
          george.x -= characterSpeed * dt;
        }
        break;
      case 3:
        george.animation = upAnimation;
        if (george.y > 0) {
          george.y -= characterSpeed * dt;
        }
        break;
      case 4:
        george.animation = rightAnimation;
        if (george.x < mapWidth - george.width) {
          george.x += characterSpeed * dt;
        }
        break;
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    direction += 1;
    if (direction > 4) {
      direction = 0;
    }
  }

  void reload() {
    removeAll(children);
    onLoad();
  }
}

class FriendComponent extends PositionComponent with CollisionCallbacks {
  FriendComponent({super.position, super.size}) {
    // Add a rectangular hitbox
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // Handle collision start (e.g., when collision begins)
    print('Collision started with $other');
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    // Handle collision end (e.g., when collision stops)
    print('Collision ended with $other');
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // Handle ongoing collision (called every frame during collision)
    print('Colliding with $other at $intersectionPoints');
  }
}

// Example of another collidable component
class GeorgeComponent extends SpriteAnimationComponent with CollisionCallbacks {
  GeorgeComponent({super.position, super.size}) {
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('OtherComponent collided with $other');
  }
}
