import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_flame_game/src/collisions/collision_block.dart';
import 'package:flutter_flame_game/src/my_game.dart';
import 'package:flutter_flame_game/src/player.dart';

class Level extends World with HasGameRef<MyGame> {
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent map;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    map = await TiledComponent.load("$levelName.tmx", Vector2.all(16));

    add(map);

    _spawnObject();

    _addCollisions();

    return super.onLoad();
  }

  void _spawnObject() {
    final spawnPointPlayer = map.tileMap.getLayer<ObjectGroup>("Spawnpoints");
    if (spawnPointPlayer != null) {
      for (final spawnPoint in spawnPointPlayer.objects) {
        switch (spawnPoint.class_) {
          case "Player":
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
        }
      }
    }
  }

  void _addCollisions() {
    final collisionLayer = map.tileMap.getLayer<ObjectGroup>("Colliders");
    if (collisionLayer != null) {
      for (final collider in collisionLayer.objects) {
        final block = CollisionBlock(
          position: Vector2(collider.x, collider.y),
          size: Vector2(collider.width, collider.height),
        );
        collisionBlocks.add(block);
        add(block);
      }

      player.collisionBlocks = collisionBlocks;
    }
  }
}
