import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/george/george_game.dart';
import 'package:flutter_flame_game/src/my_game.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Focus(
        onKeyEvent: (node, event) => KeyEventResult.handled,
        child: MyGameWidget(),
      ),
    ),
  );
}

class MyGameWidget extends StatefulWidget {
  const MyGameWidget({super.key});

  @override
  State<MyGameWidget> createState() => _MyGameWidgetState();
}

class _MyGameWidgetState extends State<MyGameWidget> {
  late Game _game;

  int actionGame = 1;

  void _actionGame() {
    switch (actionGame) {
      case 0:
        _game = MyGame();

      case 1:
        _game = GeorgeGame();
    }
  }

  @override
  void initState() {
    super.initState();
    _actionGame();
  }

  @override
  void reassemble() {
    super.reassemble();
    //MyGame().reLoad();
    // _game.reLoad();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}
