import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/global/stylized_container.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/timer/timer.dart';

import '../../../utils/utils.dart';

class PlanetPuzzleCompletionDialog extends StatelessWidget {
  const PlanetPuzzleCompletionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondsElapsed = context.read<TimerBloc>().state.secondsElapsed;
    final moves = context.read<PuzzleBloc>().state.numberOfMoves;

    return StylizedContainer(
      color: Colors.lightBlueAccent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Score'),
          Text(
            '${Utils.getFormattedElapsedSeconds(secondsElapsed)} TIME TAKEN',
          ),
          Text('Moves: $moves'),
        ],
      ),
    );
  }
}
