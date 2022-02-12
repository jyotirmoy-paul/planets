import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/puzzle/view/puzzle_page.dart';
import 'level_selection_cubit.dart';
import '../../models/planet.dart';

import '../../utils/app_logger.dart';

part 'planet_selection_state.dart';

class PlanetSelectionCubit extends Cubit<PlanetSelectionState> {
  final LevelSelectionCubit _levelSelectionCubit;
  final BuildContext _context;

  PlanetSelectionCubit(this._levelSelectionCubit, this._context)
      : super(NoPlanetSelected());

  Planet? _planet;

  Planet get planet => _planet!;

  void onPlanetSelected(Planet planet) {
    _planet = planet;

    AppLogger.log(
      'PlanetSelectionCubit tapped: $planet: level: ${_levelSelectionCubit.state.level}',
    );

    Navigator.push(
      _context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _levelSelectionCubit),
            BlocProvider.value(value: this),
          ],
          child: const PuzzlePage(),
        ),
      ),
    );
  }
}
