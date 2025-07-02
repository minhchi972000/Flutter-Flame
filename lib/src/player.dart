import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter_flame_game/src/collisions/collision_block.dart';
import 'package:flutter_flame_game/src/collisions/collision_utils.dart';
import 'package:flutter_flame_game/src/collisions/custom_hitbox.dart';
import 'package:flutter_flame_game/src/my_game.dart';

enum PlayerState {
  idleUp("character-up", 1),
  idleDown("character-down", 1),
  idleRight("character-right", 1),
  idleLeft("character-left", 1),

  walkUp("character-up", 4),
  walkDown("character-down", 4),
  walkRight("character-right", 4),
  walkLeft("character-left", 4);

  final String assetName;
  final int frameCount;
  const PlayerState(this.assetName, this.frameCount);
}

enum WalkDirection { up, down, right, left }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<MyGame>, KeyboardHandler {
  Player({super.position});

  late final Vector2 startingPosition;

  late final SpriteAnimation walkUpAnimation;
  late final SpriteAnimation walkDownAnimation;
  late final SpriteAnimation walkRightAnimation;
  late final SpriteAnimation walkLeftAnimation;

  late final SpriteAnimation idleUpAnimation;
  late final SpriteAnimation idleDownAnimation;
  late final SpriteAnimation idleRightAnimation;
  late final SpriteAnimation idleLeftAnimation;

  Vector2 velocity = Vector2.zero();
  double moveSpeed = 100;

  double horizontalMovement = 0;
  double verticalMovement = 0;

  WalkDirection lastWalkDirection = WalkDirection.down;

  CustomHitbox hitbox = const CustomHitbox(
    offsetX: 18,
    offsetY: 28,
    width: 12,
    height: 4,
  );

  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    startingPosition = position;

    _loadAllAnimations();

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerPosition(dt);
    _checkHorizontalCollisions();
    _checkVerticalCollisions();

    super.update(dt);
  }

  void _updatePlayerState() {
    PlayerState playerState = switch (lastWalkDirection) {
      WalkDirection.down => PlayerState.idleDown,
      WalkDirection.up => PlayerState.idleUp,
      WalkDirection.left => PlayerState.idleLeft,
      WalkDirection.right => PlayerState.idleRight,
    };

    if (velocity.x > 0) {
      playerState = PlayerState.walkRight;
    }

    if (velocity.x < 0) {
      playerState = PlayerState.walkLeft;
    }

    if (velocity.y > 0) {
      playerState = PlayerState.walkDown;
    }

    if (velocity.y < 0) {
      playerState = PlayerState.walkUp;
    }

    current = playerState;
  }

  void _updatePlayerPosition(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;

    velocity.y = verticalMovement * moveSpeed;
    position.y += velocity.y * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.x > 0) {
          velocity.x = 0;
          position.x = block.x - hitbox.width - hitbox.offsetX;
          break;
        }

        if (velocity.x < 0) {
          velocity.x = 0;
          position.x = block.x + block.width - hitbox.offsetX;
          break;
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.y > 0) {
          velocity.y = 0;
          position.y = block.y - hitbox.height - hitbox.offsetY;
          break;
        }

        if (velocity.y < 0) {
          velocity.y = 0;
          position.y = block.y + block.height - hitbox.offsetY;
          break;
        }
      }
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;

    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (!isLeftKeyPressed && !isRightKeyPressed) {
      final isUpKeyPressed =
          keysPressed.contains(LogicalKeyboardKey.keyW) ||
          keysPressed.contains(LogicalKeyboardKey.arrowUp);
      final isDownKeyPressed =
          keysPressed.contains(LogicalKeyboardKey.keyS) ||
          keysPressed.contains(LogicalKeyboardKey.arrowDown);

      verticalMovement += isUpKeyPressed ? -1 : 0;
      verticalMovement += isDownKeyPressed ? 1 : 0;

      if (verticalMovement > 0) {
        lastWalkDirection = WalkDirection.down;
      } else if (verticalMovement < 0) {
        lastWalkDirection = WalkDirection.up;
      }
    } else {
      horizontalMovement += isLeftKeyPressed ? -1 : 0;
      horizontalMovement += isRightKeyPressed ? 1 : 0;

      if (horizontalMovement > 0) {
        lastWalkDirection = WalkDirection.right;
      } else if (horizontalMovement < 0) {
        lastWalkDirection = WalkDirection.left;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleUpAnimation = _spriteAnimation(PlayerState.idleUp);
    idleDownAnimation = _spriteAnimation(PlayerState.idleDown);
    idleRightAnimation = _spriteAnimation(PlayerState.idleRight);
    idleLeftAnimation = _spriteAnimation(PlayerState.idleLeft);

    walkUpAnimation = _spriteAnimation(PlayerState.walkUp);
    walkDownAnimation = _spriteAnimation(PlayerState.walkDown);
    walkRightAnimation = _spriteAnimation(PlayerState.walkRight);
    walkLeftAnimation = _spriteAnimation(PlayerState.walkLeft);

    animations = {
      PlayerState.idleUp: idleUpAnimation,
      PlayerState.idleDown: idleDownAnimation,
      PlayerState.idleRight: idleRightAnimation,
      PlayerState.idleLeft: idleLeftAnimation,

      PlayerState.walkUp: walkUpAnimation,
      PlayerState.walkDown: walkDownAnimation,
      PlayerState.walkRight: walkRightAnimation,
      PlayerState.walkLeft: walkLeftAnimation,
    };

    current = PlayerState.idleDown;
  }

  SpriteAnimation _spriteAnimation(PlayerState state) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("characters/${state.assetName}.png"),
      SpriteAnimationData.sequenced(
        amount: state.frameCount,
        stepTime: 0.1,
        textureSize: Vector2.all(48),
      ),
    );
  }
}
