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
