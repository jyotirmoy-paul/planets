import '../../../layout/layout.dart';
import '../planet.dart';
import '../../../theme/themes/puzzle_theme.dart';

abstract class PlanetPuzzleTheme extends PuzzleTheme {
  const PlanetPuzzleTheme();

  @override
  String get name => 'Planet';

  @override
  PuzzleLayoutDelegate get puzzleLayoutDelegate => PlanetPuzzleLayoutDelegate();
}
