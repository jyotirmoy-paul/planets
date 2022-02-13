import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planets/puzzles/community/themes/community_puzzle_theme.dart';

import '../../models/planet.dart';
import '../../puzzles/planet/planet.dart';
import '../themes/puzzle_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

const Map<PlanetType, PuzzleTheme> _planetThemeMap = {
  PlanetType.mercury: MercuryPuzzleTheme(),
  PlanetType.venus: VenusPuzzleTheme(),
  PlanetType.earth: EarthPuzzleTheme(),
  PlanetType.mars: MarsPuzzleTheme(),
  PlanetType.jupiter: JupiterPuzzleTheme(),
  PlanetType.saturn: SaturnPuzzleTheme(),
  PlanetType.uranus: UranusPuzzleTheme(),
  PlanetType.neptune: NeptunePuzzleTheme(),
  PlanetType.pluto: PlutoPuzzleTheme(),
};

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static PuzzleTheme _getTheme(Planet? planet) {
    return planet == null
        ? const CommunityPuzzleTheme()
        : _planetThemeMap[planet.type]!;
  }

  ThemeBloc({Planet? planet}) : super(ThemeState(theme: _getTheme(planet))) {
    on<ThemeChangedEvent>(_onThemeChanged);
  }

  void _onThemeChanged(ThemeChangedEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(theme: _getTheme(event.planet)));
  }
}
