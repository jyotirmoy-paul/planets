import 'package:flutter/material.dart';

import 'planet_puzzle_theme.dart';

class SaturnPuzzleTheme extends PlanetPuzzleTheme {
  const SaturnPuzzleTheme();

  @override
  String get backgroundAsset => '';

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get surface => Colors.grey;

  @override
  Color get onSurface => Colors.amber;

  @override
  String get assetForTile => 'assets/animations/planet_x.riv';
}
