import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../app/cubit/audio_player_cubit.dart';
import '../../global/shake_animator.dart';
import '../../models/position.dart';
import '../../models/puzzle.dart';
import '../../models/tile.dart';
import '../../utils/app_logger.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  final AudioPlayerCubit _audioPlayerCubit;
  final int _size;
  int get size => _size;

  final Random? random;

  final Map<int, ShakeAnimatorController> _shakeControllers = {};

  bool _isAutoSolving = false;

  void onAutoSolvingStarted() {
    _isAutoSolving = true;
  }

  void onAutoSolvingStopped() {
    _isAutoSolving = false;
  }

  PuzzleBloc(this._size, this._audioPlayerCubit, {this.random})
      : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  ShakeAnimatorController getShakeControllerFor(int tileKey) {
    if (_shakeControllers.containsKey(tileKey)) {
      return _shakeControllers[tileKey]!;
    }

    final controller = ShakeAnimatorController();
    _shakeControllers[tileKey] = controller;
    return controller;
  }

  void _notifyShakeAnimation(Tile tile) {
    final whitespacePos = state.puzzle.getWhitespaceTile().currentPosition;
    final tilePos = tile.currentPosition;

    final diff = tilePos - whitespacePos;
    final sign = diff.x * diff.y;

    ShakeDirection direction = ShakeDirection.diagonal;

    if (sign < 0) {
      direction = ShakeDirection.oppositeDiagonal;
    }

    AppLogger.log('_notifyShakeAnimation: shakeDirection: $direction');

    _shakeControllers[tile.value]!.shake(direction);
  }

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _generatePuzzle(_size, shuffle: event.shufflePuzzle);
    emit(
      PuzzleState(
        puzzle: puzzle,
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onTileTapped(
    TileTapped event,
    Emitter<PuzzleState> emit,
  ) {
    final tappedTile = event.tile;
    final isPuzzleIncomplete = state.puzzleStatus == PuzzleStatus.incomplete;
    final isTileMovable = state.puzzle.isTileMovable(tappedTile);

    // play audio if tile is movable
    // do not play the general tile tap audio if auto solving
    if (isTileMovable && !_isAutoSolving) {
      _audioPlayerCubit.tileTappedAudio(tappedTile.value);
    }

    if (isPuzzleIncomplete && isTileMovable) {
      final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
      final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
      if (puzzle.isComplete()) {
        AppLogger.log('PuzzleBloc: puzzle.isComplete()');
        emit(
          state.copyWith(
            puzzle: puzzle.sort(),
            puzzleStatus: PuzzleStatus.complete,
            tileMovementStatus: TileMovementStatus.moved,
            numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
            numberOfMoves: state.numberOfMoves + 1,
            lastTappedTile: tappedTile,
          ),
        );
      } else {
        emit(
          state.copyWith(
            puzzle: puzzle.sort(),
            tileMovementStatus: TileMovementStatus.moved,
            numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
            numberOfMoves: state.numberOfMoves + 1,
            lastTappedTile: tappedTile,
          ),
        );
      }
    } else {
      _notifyShakeAnimation(tappedTile);

      // play error sound
      _audioPlayerCubit.tileTappedAudio(tappedTile.value, isError: true);

      emit(
        state.copyWith(
          tileMovementStatus: TileMovementStatus.cannotBeMoved,
        ),
      );
    }
  }

  void _onPuzzleReset(
    PuzzleReset event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _generatePuzzle(_size);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
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
    final whitespacePosition = Position(x: size - 1, y: size - 1);
    final n = size * size;
    return [
      for (int i = 0; i < n; i++)
        if (i == n - 1)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i],
            isWhitespace: true,
            puzzleSize: size,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i],
            currentPosition: currentPositions[i],
            puzzleSize: size,
          )
    ];
  }
}
