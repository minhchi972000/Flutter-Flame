import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_flame_game/adventure/levels/level.dart';
import 'package:flutter_flame_game/adventure/player/player.dart';

class AdventureGame extends FlameGame with HasKeyboardHandlerComponents {
  AdventureGame();

  late LevelAdventure level;
  late final CameraComponent cam;
  late PlayerAdventure player;

  // @override
  // Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    player = PlayerAdventure();

    level = LevelAdventure(levelName: 'adventure/level_1', player: player);

    final windowWidth = size.x;
    final windowHeight = size.y;
    cam = CameraComponent(world: level, viewport: FixedSizeViewport(windowWidth, windowHeight));

    cam.viewfinder.anchor = Anchor.center;
    cam.viewfinder.zoom = 2.0;

    final x = (size.x - windowWidth) / 2;
    final y = (size.y - windowHeight) / 2;
    cam.viewport.position = Vector2(x, y);
    cam.follow(player);

    addAll([cam, level]);

    super.onLoad();
  }
}
