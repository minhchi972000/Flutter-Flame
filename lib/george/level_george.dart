import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_flame_game/george/player_george.dart';
import 'package:flutter_flame_game/src/my_game.dart';

class LevelGeorge extends World with HasGameRef<MyGame> {
  final String levelName;
  final PlayerGeorge player;

  LevelGeorge({required this.levelName, required this.player});

  late SpriteComponent background;

  @override
  FutureOr<void> onLoad() async {
    Sprite sprite = await Sprite.load("george/background.png");

    background =
        SpriteComponent()
          ..sprite = sprite
          ..size = sprite.originalSize;
    add(background);

    return super.onLoad();
  }
}
