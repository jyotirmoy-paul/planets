import 'package:flutter/material.dart';

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
  @override
  Widget backgroundBuilder(PuzzleTheme theme) {
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
