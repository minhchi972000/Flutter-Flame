import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class GeorgeGame extends FlameGame
    with HasKeyboardHandlerComponents, TapDetector {
  GeorgeGame();

  late SpriteAnimation downAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation idleAnimation;

  late SpriteAnimationComponent george;

  // 0=idle, 1=down, 2=left, 3=up, 4=right
  int direction = 0;
  double animationSpeed = 0.1;
  final double characterSize = 300;

  @override
  FutureOr<void> onLoad() async {
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
        george.x -= 1;
        break;
      case 3:
        george.animation = upAnimation;
        george.y -= 1;
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
