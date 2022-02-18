import 'package:flutter/material.dart';
import '../widgets/planet_whitespace_tile.dart';
import '../../../global/puzzle_control.dart';
import '../../../layout/layout.dart';
import '../../../models/tile.dart';
import '../widgets/planet_puzzle_board.dart';
import '../widgets/planet_puzzle_info.dart';
import '../widgets/planet_puzzle_stats.dart';
import '../widgets/planet_puzzle_tile.dart';
import '../../../theme/themes/puzzle_theme.dart';

abstract class BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

class PlanetPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  @override
  Widget backgroundBuilder(PuzzleTheme theme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(height: 50, color: Colors.green),
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
