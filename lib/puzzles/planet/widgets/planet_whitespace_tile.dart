import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../puzzle/puzzle.dart';
import '../../../utils/app_logger.dart';

import '../../../models/tile.dart';
import '../planet.dart';

class PlanetWhitespaceTile extends StatelessWidget {
  final Tile tile;
  final PuzzleState state;

  const PlanetWhitespaceTile({
    Key? key,
    required this.tile,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((PlanetPuzzleBloc bloc) => bloc.state.status);
    final hasStarted = status == PlanetPuzzleStatus.started;

    AppLogger.log('PlanetWhitespaceTile: hasStarted $hasStarted');

    return hasStarted
        ? const SizedBox.shrink()
        : PlanetPuzzleTile(
            key: ValueKey(tile.value),
            tile: tile,
            state: state,
          );
  }
}
