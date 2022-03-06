import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../puzzle/cubit/puzzle_helper_cubit.dart';
import '../../../utils/constants.dart';
import '../../../app/cubit/audio_player_cubit.dart';
import '../../../dashboard/cubit/level_selection_cubit.dart';
import '../../../helpers/modal_helpers.dart';
import '../../../puzzle/puzzle.dart';
import 'planet_puzzle_completion_dialog.dart';
import '../../../utils/app_logger.dart';
import '../../../dashboard/cubit/planet_selection_cubit.dart';

import '../../../layout/layout.dart';
import '../../../timer/timer.dart';
import '../planet.dart';

class PlanetPuzzleBoard extends StatefulWidget {
  final List<Widget> tiles;

  const PlanetPuzzleBoard({Key? key, required this.tiles}) : super(key: key);

  @override
  State<PlanetPuzzleBoard> createState() => _PlanetPuzzleBoardState();
}

class _PlanetPuzzleBoardState extends State<PlanetPuzzleBoard> {
  Timer? _completePuzzleTimer;

  void _onPuzzleCompletionDialog(BuildContext context) async {
    AppLogger.log('PlanetPuzzleBoard: _onPuzzleCompletionDialog');

    // play completion audio
    context.read<AudioPlayerCubit>().completion();

    Timer(kMS300, () {
      // after dialog finishes, reset the puzzle to initial state
      context.read<PlanetPuzzleBloc>().add(const PlanetPuzzleResetEvent());
    });

    // show dialog
    showAppDialog(
      context: context,

      /// for medium and large screen, same size
      sameSize: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<LevelSelectionCubit>()),
          BlocProvider.value(value: context.read<PlanetSelectionCubit>()),
          BlocProvider.value(value: context.read<PuzzleHelperCubit>()),
          BlocProvider.value(value: context.read<TimerBloc>()),
          BlocProvider.value(value: context.read<PuzzleBloc>()),
        ],
        child: PlanetPuzzleCompletionDialog(),
      ),
    );
  }

  @override
  void dispose() {
    _completePuzzleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (BuildContext context, PuzzleState state) {
        if (state.puzzleStatus == PuzzleStatus.complete) {
          _completePuzzleTimer = Timer(kMS500, () {
            _onPuzzleCompletionDialog(context);
          });
        }
      },
      child: ResponsiveLayoutBuilder(
        small: (_, Widget? child) => _PuzzleBoard(
          child: child,
          size: BoardSize.small,
        ),
        medium: (_, Widget? child) => _PuzzleBoard(
          child: child,
          size: BoardSize.medium,
        ),
        large: (_, Widget? child) => _PuzzleBoard(
          child: child,
          size: BoardSize.large,
        ),
        child: (_) => Stack(children: widget.tiles),
      ),
    );
  }
}

class _PuzzleBoard extends StatelessWidget {
  final double size;
  final Widget? child;

  const _PuzzleBoard({
    Key? key,
    this.child,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(dimension: size, child: child);
  }
}
