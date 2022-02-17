import 'dart:async';

import 'package:planets/models/position.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/puzzle_solver/solver_tile.dart';
import 'package:planets/utils/app_logger.dart';

import '../models/tile.dart';

enum Direction {
  left,
  right,
  up,
  down,
}

const _stepDuration = Duration(milliseconds: 300);

class PuzzleSolver {
  final PuzzleBloc puzzleBloc;

  PuzzleSolver({
    required this.puzzleBloc,
  });

  List<Tile> get tiles => puzzleBloc.state.puzzle.tiles;

  StreamSubscription<SolverTile>? _streamSubscription;

  final List<SolverTile> _tiles = [];

  int get n => puzzleBloc.size;

  SolverTile get whitespaceTile =>
      _tiles.firstWhere((tile) => tile.isWhitespace);

  int abs(int x) {
    return x > 0 ? x : -x;
  }

  /// this method returns the list of tile in order they will be solved
  List<SolverTile> _determineSolveOrder() {
    final tiles = <SolverTile>[];

    for (int s = 0; s < n; s++) {
      int i = s;
      int j = s;

      while (j < n) {
        // (i, j) contains a tile
        final index = i * n + j;
        tiles.add(_tiles.firstWhere((tile) => tile.value == index));
        j += 1;
      }

      i = s + 1;
      j = s;

      while (i < n) {
        // (i, j) contains a tile
        final index = i * n + j;
        tiles.add(_tiles.firstWhere((tile) => tile.value == index));
        i += 1;
      }
    }

    return tiles;
  }

  bool _isValidPosition(Position pos) {
    return (0 <= pos.x && pos.x < n) && (0 <= pos.y && pos.y < n);
  }

  bool _isCorrectTilePlacedAt(Position pos) {
    final tile = _tiles.firstWhere((tile) => tile.currentPosition == pos);
    return tile.correctPosition == pos;
  }

  Position? _getNeighbourOf(Position pos) {
    final top = Position(x: pos.x, y: pos.y - 1);
    final bottom = Position(x: pos.x, y: pos.y + 1);
    final left = Position(x: pos.x - 1, y: pos.y);
    final right = Position(x: pos.x + 1, y: pos.y);

    if (_isValidPosition(top) && !_isCorrectTilePlacedAt(top)) {
      return top;
    }

    if (_isValidPosition(bottom) && !_isCorrectTilePlacedAt(bottom)) {
      return bottom;
    }

    if (_isValidPosition(left) && !_isCorrectTilePlacedAt(left)) {
      return left;
    }

    if (_isValidPosition(right) && !_isCorrectTilePlacedAt(right)) {
      return right;
    }

    return null;
  }

  // swaps the currentPosition of two tiles
  void _swap(SolverTile a, SolverTile b) {
    final tempPos = a.currentPosition;
    a.currentPosition = b.currentPosition;
    b.currentPosition = tempPos;
  }

  // returns the tapped tile, to achieve a particular move
  // calling this method assumes that a particular move can be made
  // this method just makes the move, and does not validates a move
  SolverTile _move(SolverTile whitespace, Direction direction) {
    // make the move
    // update the tile's currentPos
    // update the _tiles array maintained in this class

    final pos = whitespace.currentPosition;
    late Position targetPos;

    switch (direction) {
      case Direction.left:
        targetPos = Position(x: pos.x - 1, y: pos.y);
        break;

      case Direction.right:
        targetPos = Position(x: pos.x + 1, y: pos.y);
        break;

      case Direction.up:
        targetPos = Position(x: pos.x, y: pos.y - 1);
        break;

      case Direction.down:
        targetPos = Position(x: pos.x, y: pos.y + 1);
        break;
    }

    // get the target tile
    final targetTile =
        _tiles.firstWhere((tile) => tile.currentPosition == targetPos);

    _swap(whitespace, targetTile);

    return targetTile;
  }

  /// moves a particular tile to 1 step neighbour of targetPos
  List<SolverTile> _moveTileNear(SolverTile tile, Position targetPos) {
    final List<SolverTile> steps = [];

    // there can be two movement types
    // whitespace and normal tiles move in different ways

    final neighbour = _getNeighbourOf(targetPos);

    // if null, means there is no valid neighbour available, puzzle is already solved
    if (neighbour == null) return [];

    if (tile.isWhitespace) {
      final wx = tile.currentPosition.x;
      final wy = tile.currentPosition.y;

      final tx = neighbour.x;
      final ty = neighbour.y;

      final x = tx - wx;
      final xabs = abs(x);

      final y = ty - wy;
      final yabs = abs(y);

      // take x steps right/left
      for (int _ = 0; _ < xabs; _++) {
        if (x > 0) {
          steps.add(_move(tile, Direction.right));
        } else {
          steps.add(_move(tile, Direction.left));
        }
      }

      // take y steps up/down
      for (int _ = 0; _ < yabs; _++) {
        if (y > 0) {
          steps.add(_move(tile, Direction.down));
        } else {
          steps.add(_move(tile, Direction.up));
        }
      }
    } else {}

    return steps;
  }

  /// if calling this method, we are sure that tile is 1 step neighbour of
  /// it's correctPosition
  List<SolverTile> _placeTile(SolverTile tile) {
    // todo: there can be two placement types
    // todo: normal case and special cases
    // todo: normal case - when whitespace tile can be placed in target tile's correct position and replaced
    // todo: special case - when to place the tile, we need to move already placed blocks

    return [];
  }

  /// this method works on `tile` to put it in it's correctPosition
  List<SolverTile> _determineStepsFor(SolverTile tile) {
    final List<SolverTile> steps = [];

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
  List<SolverTile> _determineSteps() {
    final List<SolverTile> steps = [];

    final solvedOrderTiles = _determineSolveOrder();

    for (final tile in solvedOrderTiles) {
      AppLogger.log('puzzle_solver: solving: $tile');

      if (tile.currentPosition != tile.correctPosition) {
        steps.addAll(_determineStepsFor(tile));
        break;
      }
    }

    return steps;
  }

  /// first determine all the steps to solve the puzzle form current state
  void start() {
    // take a snapshot of the current tiles array
    _tiles.clear();
    _tiles.addAll(tiles.map((tile) => SolverTile.fromTile(tile)));

    // determine steps to solve the puzzle
    final steps = _determineSteps();
    AppLogger.log('puzzle_solver: start: steps.length: ${steps.length}');

    // actually take steps to solve the puzzle
    _streamSubscription = Stream<SolverTile>.periodic(_stepDuration, (i) {
      if (i < steps.length - 1) return steps[i];
      stop();
      return steps.last;
    }).listen(
      (SolverTile tile) {
        puzzleBloc.add(
          TileTapped(tiles.firstWhere((t) => tile.value == t.value)),
        );
      },
    );
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
