import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/puzzle.dart';
import '../../models/tile.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  final int _size;
  final Random? random;

  PuzzleBloc(this._size, {this.random}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleAutoSolve>(_onPuzzleAutoSolve);
    on<PuzzleReset>(_onPuzzleReset);
  }

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {}

  void _onTileTapped(
    TileTapped event,
    Emitter<PuzzleState> emit,
  ) {}

  void _onPuzzleAutoSolve(
    PuzzleAutoSolve event,
    Emitter<PuzzleState> emit,
  ) {}

  void _onPuzzleReset(
    PuzzleReset event,
    Emitter<PuzzleState> emit,
  ) {}
}
