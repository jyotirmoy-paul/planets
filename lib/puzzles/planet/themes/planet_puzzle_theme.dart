import 'package:planets/layout/layout.dart';
import 'package:planets/puzzles/planet/planet.dart';
import 'package:planets/theme/themes/puzzle_theme.dart';

abstract class PlanetPuzzleTheme extends PuzzleTheme {
  const PlanetPuzzleTheme();

  @override
  String get name => 'Planet';

  @override
  PuzzleLayoutDelegate get puzzleLayoutDelegate => PlanetPuzzleLayoutDelegate();
}
