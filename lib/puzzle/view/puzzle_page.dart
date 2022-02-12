import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/dashboard/cubit/level_selection_cubit.dart';
import 'package:planets/dashboard/cubit/planet_selection_cubit.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/theme/bloc/theme_bloc.dart';
import 'package:planets/utils/app_logger.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PuzzleBloc(
            context.read<LevelSelectionCubit>().puzzleSize,
          ),
        ),
        BlocProvider(
          create: (_) => ThemeBloc()
            ..add(ThemeFromPlanet(context.read<PlanetSelectionCubit>().planet)),
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
    final themeState = context.select((ThemeBloc bloc) => bloc.state);

    if (themeState is NoThemeState) {
      AppLogger.log('No theme state');
      return const SizedBox.shrink();
    }

    final theme = themeState as ThemeSelectedState;

    return Scaffold(
      body: Text(theme.theme.name),
    );
  }
}
