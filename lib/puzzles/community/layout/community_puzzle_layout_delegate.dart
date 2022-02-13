import 'package:flutter/material.dart';
import 'package:planets/layout/layout.dart';
import 'package:planets/puzzle/bloc/puzzle_bloc.dart';
import 'package:planets/models/tile.dart';
import 'package:planets/theme/themes/puzzle_theme.dart';

class CommunityPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  @override
  Widget backgroundBuilder(PuzzleTheme _) {
    throw UnimplementedError();
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    // TODO: implement boardBuilder
    throw UnimplementedError();
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    // TODO: implement tileBuilder
    throw UnimplementedError();
  }

  @override
  Widget whitespaceTileBuilder() {
    // TODO: implement whitespaceTileBuilder
    throw UnimplementedError();
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  Widget controlBuilder(PuzzleState state) {
    // TODO: implement controlBuilder
    throw UnimplementedError();
  }

  @override
  Widget infoBuilder(PuzzleState state) {
    // TODO: implement infoBuilder
    throw UnimplementedError();
  }

  @override
  Widget statsBuilder(PuzzleState state) {
    // TODO: implement statsBuilder
    throw UnimplementedError();
  }
}
