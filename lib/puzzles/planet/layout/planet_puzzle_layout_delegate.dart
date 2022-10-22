import 'package:flutter/material.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/utils/app_logger.dart';
import 'package:planets/utils/constants.dart';

import '../../../global/controls/puzzle_control.dart';
import '../../../layout/layout.dart';
import '../../../models/tile.dart';
import '../../../theme/themes/puzzle_theme.dart';
import '../widgets/planet_puzzle_board.dart';
import '../widgets/planet_puzzle_info.dart';
import '../widgets/planet_puzzle_stats.dart';
import '../widgets/planet_puzzle_tile.dart';
import '../widgets/planet_whitespace_tile.dart';

abstract class BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 512;
}

class PlanetPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  double _getPercentageOfPuzzleSolved(PuzzleState puzzleState) {
    final tiles = puzzleState.puzzle.tiles;

    /// let empty puzzle be always 100% solved
    if (tiles.isEmpty) return 1.0;

    int correctlyPlaced = 0;

    for (final tile in tiles) {
      if (tile.currentPosition == tile.correctPosition) {
        correctlyPlaced++;
      }
    }

    return correctlyPlaced / (tiles.length);
  }

  @override
  Widget backgroundBuilder(PuzzleTheme theme, PuzzleState puzzleState) {
    final percentageSolved = _getPercentageOfPuzzleSolved(puzzleState);
    AppLogger.log('PlanetPuzzleLayoutDelegate :: $percentageSolved');

    final landscapeWidget = _LandscapeWidget(theme: theme);

    return Stack(
      children: [
        ColorFiltered(
          colorFilter: kGreyscaleColorFilter,
          child: landscapeWidget,
        ),

        /// If `percentageSolved` is 30% then
        /// we hide the first 30% of the following widget
        ClipRect(
          child: AnimatedAlign(
            duration: percentageSolved > 0.85 ? kMS800 : kS4,
            alignment: Alignment.centerLeft,
            widthFactor: percentageSolved,
            child: landscapeWidget,
          ),
        ),
      ],
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 48,
          medium: 32,
          large: 96,
        ),
        PlanetPuzzleBoard(tiles: tiles),
        const ResponsiveGap(
          small: 48,
          medium: 32,
          large: 96,
        ),
      ],
    );
  }

  @override
  Widget controlBuilder() {
    return const PuzzleControl();
  }

  @override
  Widget infoBuilder() {
    return const PlanetPuzzleInfo();
  }

  @override
  Widget statsBuilder() {
    return const PlanetPuzzleStats();
  }

  @override
  Widget tileBuilder(Tile tile) {
    return PlanetPuzzleTile(key: ValueKey(tile.value), tile: tile);
  }

  @override
  Widget whitespaceTileBuilder(Tile tile) {
    return PlanetWhitespaceTile(tile: tile);
  }

  @override
  List<Object?> get props => [];
}

class _LandscapeWidget extends StatelessWidget {
  final PuzzleTheme theme;
  const _LandscapeWidget({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      key: const Key('planet_landscape'),
      small: (_, Widget? child) => Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          theme.backgroundAsset,
          height: 120.0,
          fit: BoxFit.cover,
        ),
      ),
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (_) => Align(
        alignment: Alignment.bottomCenter,
        child: Builder(builder: (context) {
          return Image.asset(
            theme.backgroundAsset,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          );
        }),
      ),
    );
  }
}
