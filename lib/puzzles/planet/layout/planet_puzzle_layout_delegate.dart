import 'package:flutter/material.dart';
import 'package:planets/layout/layout.dart';
import 'package:planets/puzzle/bloc/puzzle_bloc.dart';
import 'package:planets/models/tile.dart';

class PlanetPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  @override
  Widget backgroundBuilder(PuzzleState _) {
    throw UnimplementedError();
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    // TODO: implement boardBuilder
    throw UnimplementedError();
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    // TODO: implement endSectionBuilder
    throw UnimplementedError();
  }

  @override
  Widget startSectionBuilder(PuzzleState state) {
    // TODO: implement startSectionBuilder
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
}
