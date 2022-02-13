import 'package:flutter/material.dart';

import 'planet_puzzle_theme.dart';

class NeptunePuzzleTheme extends PlanetPuzzleTheme {
  const NeptunePuzzleTheme();

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
}
