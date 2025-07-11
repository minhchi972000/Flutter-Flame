import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/george/george_game.dart';

class ButtonController extends StatelessWidget {
  const ButtonController({super.key, required this.game});

  final GeorgeGame game;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            FlameAudio.bgm.play('music.mp3');
          },
          icon: const Icon(Icons.volume_up_rounded, color: Colors.amber),
        ),
        IconButton(
          onPressed: () {
            FlameAudio.bgm.stop();
          },
          icon: const Icon(Icons.volume_off_rounded, color: Colors.amber),
        ),
        Text(
          game.soundStrackName(),
          style: const TextStyle(color: Colors.amber),
        ),
      ],
    );
  }
}
