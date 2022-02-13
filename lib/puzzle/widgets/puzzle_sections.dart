import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:planets/layout/utils/responsive_layout_builder.dart';
import 'package:planets/puzzle/widgets/puzzle_board.dart';

import '../../theme/bloc/theme_bloc.dart';
import '../puzzle.dart';

class PuzzleSections extends StatelessWidget {
  const PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => Center(
        child: Column(
          children: [
            const Gap(16.0),
            theme.puzzleLayoutDelegate.infoBuilder(state),
            const Gap(32.0),
            theme.puzzleLayoutDelegate.statsBuilder(state),
            child!,
            theme.puzzleLayoutDelegate.controlBuilder(state),
            const Gap(48.0),
          ],
        ),
      ),
      medium: (_, Widget? child) => Center(
        child: Column(
          children: [
            const Gap(32.0),
            theme.puzzleLayoutDelegate.infoBuilder(state),
            const Gap(32.0),
            theme.puzzleLayoutDelegate.statsBuilder(state),
            child!,
            theme.puzzleLayoutDelegate.controlBuilder(state),
            const Gap(48.0),
          ],
        ),
      ),
      large: (_, Widget? child) => Row(
        children: [
          // title, stats, control buttons
          Expanded(
            child: Column(
              children: [
                theme.puzzleLayoutDelegate.infoBuilder(state),
                const Gap(48.0),
                theme.puzzleLayoutDelegate.statsBuilder(state),
                const Gap(48.0),
                theme.puzzleLayoutDelegate.controlBuilder(state),
              ],
            ),
          ),

          // puzzle board
          Expanded(child: child!),
        ],
      ),
      child: (_) => const PuzzleBoard(key: Key('puzzle_board')),
    );
  }
}
