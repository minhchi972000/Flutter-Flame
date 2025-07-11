import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_flame_game/adventure/adventure_game.dart';
import 'package:flutter_flame_game/adventure/player/player.dart';

class LevelAdventure extends World with HasGameReference<AdventureGame> {
  final String levelName;
  final PlayerAdventure player;

  LevelAdventure({required this.levelName, required this.player});
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));

    add(level);

    _spawnObject();

    super.onLoad();
  }

  void _spawnObject() {
    final spawnPointPlayer = level.tileMap.getLayer<ObjectGroup>("Spawnpoints");
    if (spawnPointPlayer != null) {
      for (final spawnPoint in spawnPointPlayer.objects) {
        switch (spawnPoint.class_) {
          case "PlayerAdventure":
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
        }
      }
    }
  }
}
