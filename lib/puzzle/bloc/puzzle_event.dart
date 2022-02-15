part of 'puzzle_bloc.dart';

enum PuzzleAutoSolveState {
  start,
  stop,
}

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized({required this.shufflePuzzle});

  final bool shufflePuzzle;

  @override
  List<Object> get props => [shufflePuzzle];
}

class TileTapped extends PuzzleEvent {
  const TileTapped(this.tile);

  final Tile tile;

  @override
  List<Object> get props => [tile];
}

class PuzzleAutoSolve extends PuzzleEvent {
  final PuzzleAutoSolveState _state;

  const PuzzleAutoSolve(this._state);

  @override
  List<Object> get props => [_state];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}
