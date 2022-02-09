import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/tile.dart';
import '../../puzzle/bloc/puzzle_bloc.dart';

abstract class PuzzleLayoutDelegate extends Equatable {
  const PuzzleLayoutDelegate();

  Widget startSectionBuilder(PuzzleState state);

  Widget endSectionBuilder(PuzzleState state);

  Widget backgroundBuilder(PuzzleState state);

  Widget boardBuilder(int size, List<Widget> tiles);

  Widget tileBuilder(Tile tile, PuzzleState state);

  Widget whitespaceTileBuilder();
}
