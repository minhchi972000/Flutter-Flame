import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/experimental.dart';

class GeorgeGame extends FlameGame
    with HasKeyboardHandlerComponents, TapDetector {
  GeorgeGame();

  late SpriteAnimation downAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation idleAnimation;

  late SpriteAnimationComponent george;
  late SpriteComponent background;
  late final CameraComponent cameraComponent;

  // 0=idle, 1=down, 2=left, 3=up, 4=right
  int direction = 0;
  double animationSpeed = 0.1;
  final double characterSize = 100;

  @override
  FutureOr<void> onLoad() async {
    final backgroundSprite = Sprite(await images.load("george/background.png"));
    background =
        SpriteComponent()
          ..sprite = backgroundSprite
          ..size = backgroundSprite.originalSize;
    add(background);

    final spriteSheet = SpriteSheet(
      image: await images.load("george/george2.png"),
      srcSize: Vector2(48, 48),
    );

    downAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: animationSpeed,
      to: 4,
    );
    upAnimation = spriteSheet.createAnimation(
      row: 1,
      stepTime: animationSpeed,
      to: 4,
    );
    leftAnimation = spriteSheet.createAnimation(
      row: 2,
      stepTime: animationSpeed,
      to: 4,
    );
    rightAnimation = spriteSheet.createAnimation(
      row: 3,
      stepTime: animationSpeed,
      to: 4,
    );
    idleAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: animationSpeed,
      to: 1,
    );

    george =
        SpriteAnimationComponent()
          ..animation = idleAnimation
          ..position = Vector2(100, 200)
          ..size = Vector2.all(characterSize);
    add(george);

    // Create the world and add components
    final world = World();
    await add(world);
    await world.add(background);
    await world.add(george);

    // Set up the camera
    cameraComponent = CameraComponent(world: world);
    cameraComponent.follow(george); // Make the camera follow george
    cameraComponent.setBounds(
      Rectangle.fromLTRB(0, 0, background.size.x, background.size.y),
    ); // Set the bounds to the background size

    await add(cameraComponent);

    return super.onLoad();
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
        george.y += 1;
        break;
      case 2:
        george.animation = leftAnimation;
        if (george.x > 0) {
          george.x -= 1;
        }
        break;
      case 3:
        george.animation = upAnimation;
        if (george.y > 0) {
          george.y -= 1;
        }
        break;
      case 4:
        george.animation = rightAnimation;
        george.x += 1;
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
