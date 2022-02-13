import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planets/theme/themes/puzzle_theme.dart';

import '../../models/position.dart';
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
  ) {
    final puzzle = _generatePuzzle(_size, shuffle: event.shufflePuzzle);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

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

  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      currentPositions.shuffle(random);
    }

    var tiles = _getTileListFromPositions(
      size: size,
      currentPositions: currentPositions,
      correctPositions: correctPositions,
    );
    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle(random);
        tiles = _getTileListFromPositions(
          size: size,
          currentPositions: currentPositions,
          correctPositions: correctPositions,
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  List<Tile> _getTileListFromPositions({
    required int size,
    required List<Position> currentPositions,
    required List<Position> correctPositions,
  }) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
            puzzleSize: size,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
            puzzleSize: size,
          )
    ];
  }
}
