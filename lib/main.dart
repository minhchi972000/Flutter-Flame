import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/adventure/adventure_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Flame.device.fullScreen();
  // Flame.device.setLandscape();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Focus(onKeyEvent: (node, event) => KeyEventResult.handled, child: MyGameWidget())),
    ),
  );
}

class MyGameWidget extends StatefulWidget {
  const MyGameWidget({super.key});

  @override
  State<MyGameWidget> createState() => _MyGameWidgetState();
}

class _MyGameWidgetState extends State<MyGameWidget> {
  @override
  void initState() {
    super.initState();
    // _actionGame();
  }

  @override
  void reassemble() {
    super.reassemble();

    // if (actionGame == 0) {
    //   MyGame().reload();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: AdventureGame());
  }
}
