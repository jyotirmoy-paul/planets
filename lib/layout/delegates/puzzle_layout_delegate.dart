import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:planets/puzzle/puzzle.dart';

import '../../models/tile.dart';
import '../../theme/themes/puzzle_theme.dart';

abstract class PuzzleLayoutDelegate extends Equatable {
  const PuzzleLayoutDelegate();

  Widget infoBuilder();

  Widget statsBuilder();

  Widget controlBuilder();

  Widget backgroundBuilder(PuzzleTheme theme, PuzzleState puzzleState);

  Widget boardBuilder(int size, List<Widget> tiles);

  Widget tileBuilder(Tile tile);

  Widget whitespaceTileBuilder(Tile tile);
}
