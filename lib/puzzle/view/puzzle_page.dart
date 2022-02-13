import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/dashboard/cubit/level_selection_cubit.dart';
import 'package:planets/dashboard/cubit/planet_selection_cubit.dart';
import 'package:planets/models/ticker.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/puzzle/widgets/puzzle_header.dart';
import 'package:planets/puzzle/widgets/puzzle_sections.dart';
import 'package:planets/theme/bloc/theme_bloc.dart';
import 'package:planets/timer/bloc/timer_bloc.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PuzzleBloc(
            context.read<LevelSelectionCubit>().puzzleSize,
          )..add(const PuzzleInitialized(shufflePuzzle: false)),
        ),
        BlocProvider(
          create: (_) => ThemeBloc(
            planet: context.read<PlanetSelectionCubit>().planet,
          ),
        ),
        BlocProvider(
          create: (_) => TimerBloc(
            ticker: const Ticker(),
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

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // background
              theme.puzzleLayoutDelegate.backgroundBuilder(theme),

              // main body
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
