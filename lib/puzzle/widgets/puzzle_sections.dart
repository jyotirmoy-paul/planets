import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import 'puzzle_board.dart';

import '../../theme/bloc/theme_bloc.dart';

class PuzzleSections extends StatelessWidget {
  const PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => Center(
        child: Column(
          children: [
            const Gap(16.0),
            theme.puzzleLayoutDelegate.infoBuilder(),
            const Gap(32.0),
            theme.puzzleLayoutDelegate.statsBuilder(),
            child!,
            theme.puzzleLayoutDelegate.controlBuilder(),
            const Gap(48.0),
          ],
        ),
      ),
      medium: (_, Widget? child) => Center(
        child: Column(
          children: [
            const Gap(32.0),
            theme.puzzleLayoutDelegate.infoBuilder(),
            const Gap(32.0),
            theme.puzzleLayoutDelegate.statsBuilder(),
            child!,
            theme.puzzleLayoutDelegate.controlBuilder(),
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
                theme.puzzleLayoutDelegate.infoBuilder(),
                const Gap(48.0),
                theme.puzzleLayoutDelegate.statsBuilder(),
                const Gap(48.0),
                theme.puzzleLayoutDelegate.controlBuilder(),
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
