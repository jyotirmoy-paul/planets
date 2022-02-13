import 'package:flutter/material.dart';
import 'package:planets/global/puzzle_control.dart';
import 'package:planets/layout/layout.dart';
import 'package:planets/puzzle/bloc/puzzle_bloc.dart';
import 'package:planets/models/tile.dart';
import 'package:planets/puzzles/planet/widgets/planet_puzzle_board.dart';
import 'package:planets/puzzles/planet/widgets/planet_puzzle_info.dart';
import 'package:planets/puzzles/planet/widgets/planet_puzzle_stats.dart';
import 'package:planets/puzzles/planet/widgets/planet_puzzle_tile.dart';
import 'package:planets/theme/themes/puzzle_theme.dart';

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
          small: 32,
          medium: 48,
          large: 96,
        ),
        ResponsiveLayoutBuilder(
          small: (_, Widget? child) => SizedBox.square(
            dimension: BoardSize.small,
            child: child,
          ),
          medium: (_, Widget? child) => SizedBox.square(
            dimension: BoardSize.medium,
            child: child,
          ),
          large: (_, Widget? child) => SizedBox.square(
            dimension: BoardSize.large,
            child: child,
          ),
          child: (_) => PlanetPuzzleBoard(size: size, tiles: tiles),
        ),
        const ResponsiveGap(large: 96),
      ],
    );
  }

  @override
  Widget controlBuilder(PuzzleState state) {
    return const PuzzleControl();
  }

  @override
  Widget infoBuilder(PuzzleState state) {
    return const PlanetPuzzleInfo();
  }

  @override
  Widget statsBuilder(PuzzleState state) {
    return const PlanetPuzzleStats();
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return PlanetPuzzleTile(
      tile: tile,
      state: state,
      key: Key(tile.value.toString()),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox.shrink();
  }

  @override
  List<Object?> get props => [];
}
