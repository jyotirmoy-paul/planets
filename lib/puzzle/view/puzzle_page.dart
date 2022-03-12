import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/puzzle.dart';
import '../../puzzles/planet/cubit/planet_fact_cubit.dart';
import '../../utils/utils.dart';

import '../../app/cubit/audio_player_cubit.dart';
import '../../dashboard/cubit/level_selection_cubit.dart';
import '../../dashboard/cubit/planet_selection_cubit.dart';
import '../../global/background/background.dart';
import '../../models/ticker.dart';
import '../../puzzles/planet/bloc/planet_puzzle_bloc.dart';
import '../../theme/bloc/theme_bloc.dart';
import '../../timer/bloc/timer_bloc.dart';
import '../cubit/puzzle_helper_cubit.dart';
import '../cubit/puzzle_init_cubit.dart';
import '../puzzle.dart';
import '../widgets/puzzle_header.dart';
import '../widgets/puzzle_sections.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PlanetPuzzleBloc(
            secondsToBegin: context.read<LevelSelectionCubit>().puzzleSize,
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (context) => PuzzleInitCubit(
            context.read<LevelSelectionCubit>().puzzleSize,
            context.read<PlanetPuzzleBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) => PuzzleBloc(
            context.read<LevelSelectionCubit>().puzzleSize,
            context.read<AudioPlayerCubit>(),
          )..add(const PuzzleInitialized(shufflePuzzle: false)),
        ),
        BlocProvider(
          create: (context) => PuzzleHelperCubit(
            context.read<PuzzleBloc>(),
            context.read<AudioPlayerCubit>(),
            optimized: Utils.isOptimizedPuzzle() ||
                context.read<LevelSelectionCubit>().puzzleLevel ==
                    PuzzleLevel.hard,
          ),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(
            planet: context.read<PlanetSelectionCubit>().planet,
          ),
        ),
        BlocProvider(
          create: (_) => TimerBloc(
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (_) => PlanetFactCubit(
            planetType: context.read<PlanetSelectionCubit>().planet.type,
            context: context,
          ),
        ),
      ],
      child: const _PuzzleView(),
    );
  }
}

class _PuzzleView extends StatelessWidget {
  const _PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    // final state = context.select((PuzzleBloc bloc) => bloc.state);

    return Background(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // background
              theme.puzzleLayoutDelegate.backgroundBuilder(theme),

              // main body
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      PuzzleHeader(),
                      PuzzleSections(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
