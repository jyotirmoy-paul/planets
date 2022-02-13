import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:planets/theme/themes/puzzle_theme.dart';

import '../../models/tile.dart';
import '../../puzzle/bloc/puzzle_bloc.dart';

abstract class PuzzleLayoutDelegate extends Equatable {
  const PuzzleLayoutDelegate();

  Widget infoBuilder(PuzzleState state);

  Widget statsBuilder(PuzzleState state);

  Widget controlBuilder(PuzzleState state);

  Widget backgroundBuilder(PuzzleTheme theme);

  Widget boardBuilder(int size, List<Widget> tiles);

  Widget tileBuilder(Tile tile, PuzzleState state);

  Widget whitespaceTileBuilder();
}
