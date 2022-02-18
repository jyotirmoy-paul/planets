import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/dashboard/cubit/level_selection_cubit.dart';
import 'package:planets/helpers/modal_helpers.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/puzzles/planet/widgets/planet_puzzle_completion_dialog.dart';
import 'package:planets/utils/app_logger.dart';
import '../../../dashboard/cubit/planet_selection_cubit.dart';
import '../../../puzzle/cubit/puzzle_init_cubit.dart';

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

    // show dialog
    await showAppDialog(
      context: context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<LevelSelectionCubit>()),
          BlocProvider.value(value: context.read<PlanetSelectionCubit>()),
          BlocProvider.value(value: context.read<TimerBloc>()),
          BlocProvider.value(value: context.read<PuzzleBloc>()),
        ],
        child: const PlanetPuzzleCompletionDialog(),
      ),
    );

    // after dialog finishes, reset the puzzle to initial state
    context.read<PlanetPuzzleBloc>().add(const PlanetPuzzleResetEvent());
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
          _completePuzzleTimer = Timer(const Duration(milliseconds: 370), () {
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
    final cubitState = context.select((PuzzleInitCubit cubit) => cubit.state);
    final isReady = cubitState is PuzzleInitReady;

    return AnimatedOpacity(
      duration: Duration(milliseconds: isReady ? 250 : 0),
      opacity: isReady ? 1.0 : 0.1,
      curve: Curves.easeOutQuint,
      child: SizedBox.square(dimension: size, child: child),
    );
  }
}
