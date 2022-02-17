import 'dart:async';

import 'package:planets/models/position.dart';
import 'package:planets/models/tile.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/utils/app_logger.dart';

const _stepDuration = Duration(milliseconds: 800);

class PuzzleSolver {
  final PuzzleBloc puzzleBloc;

  PuzzleSolver({
    required this.puzzleBloc,
  });

  StreamSubscription<Tile>? _streamSubscription;

  final List<Tile> _tiles = [];

  int get n => puzzleBloc.size;

  Tile get whitespaceTile => _tiles.singleWhere((tile) => tile.isWhitespace);

  /// this method returns the list of tile in order they will be solved
  List<Tile> _determineSolveOrder() {
    final tiles = <Tile>[];

    for (int s = 0; s < n; s++) {
      int i = s;
      int j = s;

      while (j < n) {
        // (i, j) contains a tile
        final index = i * n + j;
        tiles.add(_tiles.singleWhere((tile) => tile.value == index));
        j += 1;
      }

      i = s + 1;
      j = s;

      while (i < n) {
        // (i, j) contains a tile
        final index = i * n + j;
        tiles.add(_tiles.singleWhere((tile) => tile.value == index));
        i += 1;
      }
    }

    return tiles;
  }

  /// moves a particular tile to 1 step neighbour of targetPos
  List<Tile> _moveTileNear(Tile tile, Position targetPos) {
    // todo: there can be two movement types
    // todo: whitespace and normal tiles moves in different ways

    return [];
  }

  /// if calling this method, we are sure that tile is 1 step neighbour of
  /// it's correctPosition
  List<Tile> _placeTile(Tile tile) {
    // todo: there can be two placement types
    // todo: normal case and special cases
    // todo: normal case - when whitespace tile can be placed in target tile's correct position and replaced
    // todo: special case - when to place the tile, we need to move already placed blocks

    return [];
  }

  /// this method works on `tile` to put it in it's correctPosition
  List<Tile> _determineStepFor(Tile tile) {
    final List<Tile> steps = [];

    // find whitespace
    final wsTile = whitespaceTile;

    // move the whitespace near the target tile
    steps.addAll(_moveTileNear(wsTile, tile.currentPosition));

    // now using the help of whitespace tile, move the tile near it's correct position
    steps.addAll(_moveTileNear(tile, tile.correctPosition));

    // place the tile
    // make sure - whitespace, target and tile are all at 1 step distance
    steps.addAll(_placeTile(tile));

    return steps;
  }

  /// this method returns the list of steps to be followed to solve the puzzle
  List<Tile> _determineSteps() {
    final List<Tile> steps = [];

    while (true) {
      final solvedOrderTiles = _determineSolveOrder();
      AppLogger.log('puzzle_solver: solverOrder: $solvedOrderTiles');

      bool isSolved = true;

      for (final tile in solvedOrderTiles) {
        // only care about the unsolved pieces
        if (tile.currentPosition != tile.correctPosition) {
          isSolved = false;
          steps.addAll(_determineStepFor(tile));
        }
      }

      // if all the tiles are in correct position
      if (isSolved) break;
    }

    return steps;
  }

  /// first determine all the steps to solve the puzzle form current state
  void start() {
    // take a snapshot of the current tiles array
    _tiles.clear();
    _tiles.addAll(puzzleBloc.state.puzzle.tiles);

    // determine steps to solve the puzzle
    final steps = _determineSteps();
    AppLogger.log('puzzle_solver: start: steps.length: ${steps.length}');

    // actually take steps to solve the puzzle
    _streamSubscription = Stream<Tile>.periodic(_stepDuration, (i) {
      if (i < steps.length - 1) return steps[i];
      stop();
      return steps.last;
    }).listen((Tile tile) => puzzleBloc.add(TileTapped(tile)));
  }

  void stop() {
    /// we will have a stream of steps to solve this puzzle
    /// and on stop called, we will cancel the stream, thus stopping the auto solver
    _streamSubscription?.cancel();
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}
