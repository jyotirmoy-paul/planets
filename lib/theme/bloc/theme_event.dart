part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChangedEvent extends ThemeEvent {
  final PuzzleTheme puzzleTheme;

  const ThemeChangedEvent(this.puzzleTheme);

  @override
  List<Object> get props => [puzzleTheme];
}

class ThemeFromPlanet extends ThemeEvent {
  final Planet planet;

  const ThemeFromPlanet(this.planet);

  @override
  List<Object> get props => [planet];
}
