import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'level_selection_cubit.dart';
import '../../models/planet.dart';

import '../../utils/app_logger.dart';

part 'planet_selection_state.dart';

class PlanetSelectionCubit extends Cubit<PlanetSelectionState> {
  final LevelSelectionCubit _levelSelectionCubit;

  PlanetSelectionCubit(this._levelSelectionCubit) : super(NoPlanetSelected());

  void onPlanetSelected(Planet planet) {
    AppLogger.log(
        'PlanetSelectionCubit tapped: $planet: level: ${_levelSelectionCubit.state.level}');
  }
}
