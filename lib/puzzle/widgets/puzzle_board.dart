import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../global/keyboard_handlers/puzzle_keyboard_handler.dart';
import '../../models/tile.dart';
import '../../theme/bloc/theme_bloc.dart';
import '../../timer/timer.dart';
import '../../utils/app_logger.dart';
import '../puzzle.dart';

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const Center(child: CircularProgressIndicator());

    return PuzzleKeyboardHandler(
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (state.puzzleStatus == PuzzleStatus.complete) {
            AppLogger.log('PuzzleBoard: PuzzleStatus.complete');
            context.read<TimerBloc>().add(const TimerStopped());
          }
        },
        child: theme.puzzleLayoutDelegate.boardBuilder(
          size,
          puzzle.tiles
              .map((tile) => _PuzzleTile(
                    key: Key('puzzle_tile_${tile.value}'),
                    tile: tile,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({Key? key, required this.tile}) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return tile.isWhitespace
        ? theme.puzzleLayoutDelegate.whitespaceTileBuilder(tile)
        : theme.puzzleLayoutDelegate.tileBuilder(tile);
  }
}
