import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/planet.dart';
import '../../puzzles/planet/planet.dart';
import '../themes/puzzle_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(NoThemeState()) {
    on<ThemeChangedEvent>(_onThemeChanged);
    on<ThemeFromPlanet>(_onThemeFromPlanet);
  }

  void _onThemeFromPlanet(ThemeFromPlanet event, Emitter<ThemeState> emit) {
    switch (event.planet.type) {
      case PlanetType.mercury:
        return add(ThemeChangedEvent(MercuryPuzzleTheme()));
      case PlanetType.venus:
        return add(ThemeChangedEvent(VenusPuzzleTheme()));
      case PlanetType.earth:
        return add(ThemeChangedEvent(EarthPuzzleTheme()));
      case PlanetType.mars:
        return add(ThemeChangedEvent(MarsPuzzleTheme()));
      case PlanetType.jupiter:
        return add(ThemeChangedEvent(JupiterPuzzleTheme()));
      case PlanetType.saturn:
        return add(ThemeChangedEvent(SaturnPuzzleTheme()));
      case PlanetType.uranus:
        return add(ThemeChangedEvent(UranusPuzzleTheme()));
      case PlanetType.neptune:
        return add(ThemeChangedEvent(NeptunePuzzleTheme()));
      case PlanetType.pluto:
        return add(ThemeChangedEvent(PlutoPuzzleTheme()));
    }
  }

  void _onThemeChanged(ThemeChangedEvent event, Emitter<ThemeState> emit) {
    if (state is ThemeSelectedState) {
      emit((state as ThemeSelectedState).copyWith(
        theme: event.puzzleTheme,
      ));
    }

    emit(ThemeSelectedState(theme: event.puzzleTheme));
  }
}
