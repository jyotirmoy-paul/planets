import '../../../layout/layout.dart';
import '../../../theme/themes/puzzle_theme.dart';
import '../planet.dart';

abstract class PlanetPuzzleTheme extends PuzzleTheme {
  const PlanetPuzzleTheme();

  @override
  String get name => 'Planet';

  @override
  PuzzleLayoutDelegate get puzzleLayoutDelegate => PlanetPuzzleLayoutDelegate();
}
