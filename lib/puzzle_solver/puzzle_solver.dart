import 'dart:async';

import 'package:planets/models/position.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/puzzle_solver/solver_tile.dart';
import 'package:planets/utils/app_logger.dart';
import 'dart:math' as math;

import '../models/tile.dart';

enum Direction { left, right, up, down }

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

  /// using euclidean distance instead of manhattan distance
  /// kind of euclidean distance, as we don't do sqrt()
  /// just need the magnitudes to compare
  int _getDistanceBetween(Position a, Position b) {
    return (math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2)).toInt();
  }

  // find the optimized neighbour (optimized -> nearest distance between pos and from)
  Position? _getNeighbourOf(
    Position pos,
    Position from, {
    Position? excludingPos,
  }) {
    final top = Position(x: pos.x, y: pos.y - 1);
    final bottom = Position(x: pos.x, y: pos.y + 1);
    final left = Position(x: pos.x - 1, y: pos.y);
    final right = Position(x: pos.x + 1, y: pos.y);

    final List<Position> neighbours = [];

    void add(Position pos) {
      if (excludingPos == null || excludingPos != pos) {
        neighbours.add(pos);
      }
    }

    if (_isValidPosition(top) && !_isCorrectTilePlacedAt(top)) {
      add(top);
    }

    if (_isValidPosition(bottom) && !_isCorrectTilePlacedAt(bottom)) {
      add(bottom);
    }

    if (_isValidPosition(left) && !_isCorrectTilePlacedAt(left)) {
      add(left);
    }

    if (_isValidPosition(right) && !_isCorrectTilePlacedAt(right)) {
      add(right);
    }

    if (neighbours.isEmpty) {
      return null;
    }

    int minDistance = n * n;
    late Position optimizedNeighbour;

    for (final n in neighbours) {
      final distance = _getDistanceBetween(n, from);
      if (distance < minDistance) {
        minDistance = distance;
        optimizedNeighbour = n;
      }
    }

    return optimizedNeighbour;
  }

  // swaps the currentPosition of two tiles
  void _swap(SolverTile a, SolverTile b) {
    final tempPos = a.currentPosition;
    a.currentPosition = b.currentPosition;
    b.currentPosition = tempPos;
  }

  List<SolverTile> _moveWhitespaceToPos(Position targetPos) {
    final List<SolverTile> steps = [];

    final tile = whitespaceTile;

    final wx = tile.currentPosition.x;
    final wy = tile.currentPosition.y;

    final tx = targetPos.x;
    final ty = targetPos.y;

    final x = tx - wx;
    final xabs = abs(x);

    final y = ty - wy;
    final yabs = abs(y);

    // take x steps right/left
    for (int _ = 0; _ < xabs; _++) {
      if (x > 0) {
        steps.add(_move(Direction.right));
      } else {
        steps.add(_move(Direction.left));
      }
    }

    // take y steps up/down
    for (int _ = 0; _ < yabs; _++) {
      if (y > 0) {
        steps.add(_move(Direction.down));
      } else {
        steps.add(_move(Direction.up));
      }
    }

    return steps;
  }

  // returns the tapped tile, to achieve a particular move
  // calling this method assumes that a particular move can be made
  // this method just makes the move, and does not validates a move
  SolverTile _move(Direction direction) {
    // make the move
    // update the tile's currentPos
    // update the _tiles array maintained in this class

    final SolverTile whitespace = whitespaceTile;

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

  List<SolverTile> _moveWhitespaceNear(Position targetPos) {
    final tile = whitespaceTile;
    final neighbour = _getNeighbourOf(targetPos, tile.currentPosition);
    if (neighbour == null) return [];
    return _moveWhitespaceToPos(neighbour);
  }

  /// it is guranteed that `around` tile is a neighbour of whitespace
  List<SolverTile> _moveWhitespace({
    required Position around,
    required Position to,
  }) {
    final List<SolverTile> steps = [];

    final ws = whitespaceTile;

    while (ws.currentPosition != to) {
      /// get an unsolved neighbour nearest to `to` position, excluding `around` Pos
      final pos = _getNeighbourOf(ws.currentPosition, to, excludingPos: around);
      if (pos == null) return steps;
      steps.addAll(_moveWhitespaceToPos(pos));
    }

    return steps;
  }

  SolverTile _moveNeighbourTile(SolverTile tile) {
    // if whitespace is a neighbour, we are guaranteed to have only one element
    return _moveWhitespaceToPos(tile.currentPosition).first;
  }

  /// moves a particular tile to 1 step neighbour of targetPos
  /// using whitespace, move tile to it's targetPos
  List<SolverTile> _moveTile(SolverTile tile) {
    final List<SolverTile> steps = [];

    while (tile.currentPosition != tile.correctPosition) {
      // get the tile closest to the correct position of tile
      final neighbour = _getNeighbourOf(
        tile.currentPosition,
        tile.correctPosition,
      );

      if (neighbour == null) {
        return steps;
      }

      // move whitespace to neighbour
      steps.addAll(
        _moveWhitespace(around: tile.currentPosition, to: neighbour),
      );

      // swap
      steps.add(_moveNeighbourTile(tile));
    }

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

    // move the whitespace near the target tile
    steps.addAll(_moveWhitespaceNear(tile.currentPosition));

    // now using the help of whitespace tile, move the tile near it's correct position
    steps.addAll(_moveTile(tile));

    // place the tile
    // make sure - whitespace, target and tile are all at 1 step distance
    steps.addAll(_placeTile(tile));

    return steps;
  }

  /// this method returns the list of steps to be followed to solve the puzzle
  List<SolverTile> _determineSteps() {
    final List<SolverTile> steps = [];

    final solvedOrderTiles = _determineSolveOrder().sublist(0, 3);

    for (final tile in solvedOrderTiles) {
      AppLogger.log('puzzle_solver: solving: $tile');

      if (tile.currentPosition != tile.correctPosition) {
        steps.addAll(_determineStepsFor(tile));
      }
    }

    return steps;
  }

  /// first determine all the steps to solve the puzzle form current state
  void start() {
    // take a snapshot of the current tiles arrangement
    _tiles.clear();
    _tiles.addAll(tiles.map((tile) => SolverTile.fromTile(tile)));

    // determine steps to solve the puzzle
    final steps = _determineSteps();
    AppLogger.log('puzzle_solver: start: steps.length: ${steps.length}');

    // actually take steps to solve the puzzle
    _streamSubscription = Stream<SolverTile>.periodic(_stepDuration, (i) {
      if (i < steps.length) return steps[i];
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
