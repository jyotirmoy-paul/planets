import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      small: (_, __) => Column(
        children: [
          theme.puzzleLayoutDelegate.infoBuilder(state),
          theme.puzzleLayoutDelegate.statsBuilder(state),
          const PuzzleBoard(),
          theme.puzzleLayoutDelegate.controlBuilder(state),
        ],
      ),
      medium: (_, __) => Row(
        children: [
          // title, stats, control buttons
          Expanded(
            child: Column(
              children: [
                theme.puzzleLayoutDelegate.infoBuilder(state),
                theme.puzzleLayoutDelegate.statsBuilder(state),
                theme.puzzleLayoutDelegate.controlBuilder(state),
              ],
            ),
          ),

          // puzzle board
          const Expanded(
            child: PuzzleBoard(),
          ),
        ],
      ),
      large: (_, __) => Row(
        children: [
          // title, stats, control buttons
          Expanded(
            child: Column(
              children: [
                theme.puzzleLayoutDelegate.infoBuilder(state),
                theme.puzzleLayoutDelegate.statsBuilder(state),
                theme.puzzleLayoutDelegate.controlBuilder(state),
              ],
            ),
          ),

          // puzzle board
          const Expanded(
            child: PuzzleBoard(),
          ),
        ],
      ),
    );
  }
}
