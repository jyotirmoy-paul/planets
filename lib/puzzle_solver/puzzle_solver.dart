import 'dart:async';
import 'dart:math' as math;

import '../models/position.dart';
import '../models/tile.dart';
import '../puzzle/cubit/puzzle_helper_cubit.dart';
import '../puzzle/puzzle.dart';
import '../utils/app_logger.dart';
import '../utils/constants.dart';
import 'solver_tile.dart';

enum Direction { left, right, up, down }

enum SpecialCaseGroup { topRight, bottomLeft, none }

const _stepDuration = kMS150;

extension ListHelper on List<SolverTile> {
  SolverTile whitespace() => firstWhere((e) => e.isWhitespace);
  SolverTile findByValue(int v) => firstWhere((e) => e.value == v);
  SolverTile findWhereCurrPosIs(Position p) =>
      firstWhere((e) => e.currentPosition == p);
}

class PuzzleSolver {
  final PuzzleBloc puzzleBloc;
  final PuzzleHelperCubit puzzleHelperCubit;

  PuzzleSolver({
    required this.puzzleBloc,
    required this.puzzleHelperCubit,
  });

  List<Tile> get tiles => puzzleBloc.state.puzzle.tiles;

  final List<SolverTile> _tiles = [];
  int get n => puzzleBloc.size;

  /// returns the whitespace tile
  SolverTile get whitespaceTile => _tiles.whitespace();

  /// returns absolute value of `x`
  int abs(int x) => x > 0 ? x : -x;

  /// determines the order in which the tiles will be sovled
  /// first the top row, then left column
  /// 1, 2, 3, 4, 7 ... ->  solving top row and left column,
  /// the problem reduces to a 2x2 grid, then apply the same algorithm,
  /// works perfectly for higher order nxn grids as well
  /// this row-col method should be easy for humans to follow as well, thus instead of writing any
  /// sophisticated algorithms such as A*, wanted to write this simple to follow one
  ///   ┌─────0───────1───────2────► x
  ///   │  ┌─────┐ ┌─────┐ ┌─────┐
  ///   0  │  1  │ │  2  │ │  3  │
  ///   │  └─────┘ └─────┘ └─────┘
  ///   │  ┌─────┐
  ///   1  │  4  │
  ///   │  └─────┘
  ///   │  ┌─────┐
  ///   2  │  7  │
  ///   │  └─────┘
  ///   ▼
  ///   y
  List<SolverTile> _determineSolveOrder() {
    final tiles = <SolverTile>[];

    for (int s = 0; s < n; s++) {
      int i = s;
      int j = s;

      while (j < n) {
        // (i, j) contains a tile
        final index = i * n + j;
        tiles.add(_tiles.findByValue(index));
        j += 1;
      }

      i = s + 1;
      j = s;

      while (i < n) {
        // (i, j) contains a tile
        final index = i * n + j;
        tiles.add(_tiles.findByValue(index));
        i += 1;
      }
    }

    return tiles;
  }

  /// determines if a particular position `pos` is inside the nxn puzzle grid
  bool _isValidPosition(Position pos) {
    return (0 <= pos.x && pos.x < n) && (0 <= pos.y && pos.y < n);
  }

  /// this array is maintained to keep solved tiles in check
  /// if `_tilesPlacedAlready` contains 1, 2, 3, meaning tiles 1, 2 and 3 are correctly placed
  final List<int> _tilesPlacedAlready = [];

  bool _isCorrectTilePlacedAt(Position pos) {
    final tile = _tiles.findWhereCurrPosIs(pos);

    if (_tilesPlacedAlready.contains(tile.value)) {
      return true;
    }

    return false;
  }

  /// using euclidean distance instead of manhattan distance
  /// kind of euclidean distance, as we don't do sqrt()
  /// as we just need the magnitudes to compare
  int _getDistanceBetween(Position a, Position b) {
    return (math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2)).toInt();
  }

  // find the optimized neighbour (optimized -> nearest distance between pos and from)
  Position? _getNeighbourOf(Position pos, Position from) {
    final top = Position(x: pos.x, y: pos.y - 1);
    final bottom = Position(x: pos.x, y: pos.y + 1);
    final left = Position(x: pos.x - 1, y: pos.y);
    final right = Position(x: pos.x + 1, y: pos.y);

    final List<Position> neighbours = [];

    if (_isValidPosition(top) && !_isCorrectTilePlacedAt(top)) {
      neighbours.add(top);
    }

    if (_isValidPosition(bottom) && !_isCorrectTilePlacedAt(bottom)) {
      neighbours.add(bottom);
    }

    if (_isValidPosition(left) && !_isCorrectTilePlacedAt(left)) {
      neighbours.add(left);
    }

    if (_isValidPosition(right) && !_isCorrectTilePlacedAt(right)) {
      neighbours.add(right);
    }

    if (neighbours.isEmpty) {
      return null;
    }

    // finding the neighbour that takes min effort to get there
    int minDistance = n * n + 1;
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

  /// swaps the `currentPosition` of two tiles
  void _swap(SolverTile a, SolverTile b) {
    final tempPos = a.currentPosition;
    a.currentPosition = b.currentPosition;
    b.currentPosition = tempPos;
  }

  /// this function moves the whitespace one step to one of it's neighbour (`targetPos`)
  /// while calling this function should make sure `targetPos` is a neighbour of `whiteSpace`
  SolverTile _moveWhitespaceToNeighbourPos(Position targetPos) {
    final tile = whitespaceTile;

    final wx = tile.currentPosition.x;
    final wy = tile.currentPosition.y;

    final tx = targetPos.x;
    final ty = targetPos.y;

    final x = tx - wx;

    final y = ty - wy;

    if (x > 0) {
      return _move(Direction.right);
    } else if (x < 0) {
      return _move(Direction.left);
    } else if (y > 0) {
      return _move(Direction.down);
    }

    return _move(Direction.up);
  }

  /// get the new `Position` from `start`, if moved in `dir` direction
  Position _posInDirection(Position start, Direction dir) {
    switch (dir) {
      case Direction.left:
        return start.left;

      case Direction.right:
        return start.right;

      case Direction.up:
        return start.top;

      case Direction.down:
        return start.bottom;
    }
  }

  /// this method moves whitespace `a` steps in `aDir` direction
  /// followed by `b` steps in `bDir` direction
  List<Position> _moveInAB(int a, Direction aDir, int b, bDir) {
    final ws = whitespaceTile;
    Position currentPos = ws.currentPosition;

    final List<Position> path = [];

    // make movements in a first
    for (int _ = 0; _ < a; _++) {
      currentPos = _posInDirection(currentPos, aDir);
      path.add(currentPos);
    }

    // then, make movements in b
    for (int _ = 0; _ < b; _++) {
      currentPos = _posInDirection(currentPos, bDir);
      path.add(currentPos);
    }

    return path;
  }

  /// this method moves whitespace to a `targetPos` position
  /// following an favourable path
  /// favourable path referes to a path that is shortest and valid, and do not
  /// disturb already placed tiles
  List<SolverTile> _moveWhitespaceToPos(Position targetPos) {
    final tile = whitespaceTile;

    final wx = tile.currentPosition.x;
    final wy = tile.currentPosition.y;

    final tx = targetPos.x;
    final ty = targetPos.y;

    final x = tx - wx;
    final xabs = abs(x);

    final y = ty - wy;
    final yabs = abs(y);

    final List<Position> pathA = [];
    final List<Position> pathB = [];
    final xDir = x > 0 ? Direction.right : Direction.left;
    final yDir = y > 0 ? Direction.down : Direction.up;

    // in path a, first x steps are taken then y
    pathA.addAll(_moveInAB(xabs, xDir, yabs, yDir));

    // in path b, first y steps are taken then x
    pathB.addAll(_moveInAB(yabs, yDir, xabs, xDir));

    final favourablePath = _getFavourablePath(pathA, pathB);

    final List<SolverTile> steps = [];

    // no valid path is found
    if (favourablePath.isEmpty) return steps;

    for (final pos in favourablePath) {
      steps.add(_moveWhitespaceToNeighbourPos(pos));
    }

    return steps;
  }

  /// moves whitespace in `dir` direction
  /// returns the tapped tile, to achieve that particular move
  /// calling this method assumes that a particular move can be made
  /// this method just makes the move, and does not validates a move
  SolverTile _move(Direction dir) {
    // make the move
    // update the tile's currentPos
    // update the _tiles array maintained in this class

    final SolverTile whitespace = whitespaceTile;

    final pos = whitespace.currentPosition;
    late Position targetPos;

    switch (dir) {
      case Direction.left:
        targetPos = pos.left;
        break;

      case Direction.right:
        targetPos = pos.right;
        break;

      case Direction.up:
        targetPos = pos.top;
        break;

      case Direction.down:
        targetPos = pos.bottom;
        break;
    }

    // get the target tile
    final targetTile = _tiles.findWhereCurrPosIs(targetPos);

    _swap(whitespace, targetTile);

    return targetTile;
  }

  /// this method moves the whitespace, near a `targetPos` position
  /// near refers to any one of the 4 neighbours of `targetPos`
  List<SolverTile> _moveWhitespaceNear(Position targetPos) {
    final ws = whitespaceTile;
    final neighbour = _getNeighbourOf(targetPos, ws.currentPosition);
    if (neighbour == null) return const [];
    return _moveWhitespaceToPos(neighbour);
  }

  /// verifies if a series of Position movement (`path`) is valid
  /// validity is checked by making sure path do not contain any invalid position
  /// and do not disturb any settled tiles
  bool _isPathValid(List<Position> path) {
    for (final pos in path) {
      if (!_isValidPosition(pos) || _isCorrectTilePlacedAt(pos)) {
        return false;
      }
    }

    return true;
  }

  /// returns an optimized path, choosen between `a` and `b`
  List<Position> _getFavourablePath(List<Position> a, List<Position> b) {
    if (a.length <= b.length && _isPathValid(a)) {
      return a;
    }

    return _isPathValid(b)
        ? b
        : _isPathValid(a)
            ? a
            : const [];
  }

  /// this method takes steps from `from` to `to`, going around `around` position
  /// making sure whitespace moves from `from` to `to`, always staying neighbour of `around`
  List<SolverTile> _takeFavourableSteps({
    required Position from,
    required Position around,
    required Position to,
  }) {
    final List<Position> neighbours = [];
    // starting from centerLeft - moving clockwise for all 8 neighbours
    neighbours.add(around.left);
    neighbours.add(around.left.top);
    neighbours.add(around.top);
    neighbours.add(around.top.right);
    neighbours.add(around.right);
    neighbours.add(around.right.bottom);
    neighbours.add(around.bottom);
    neighbours.add(around.bottom.left);

    // it is sure that from and to are among these neighbours
    final fi = neighbours.indexWhere((pos) => pos == from);
    final ti = neighbours.indexWhere((pos) => pos == to);

    assert(fi != -1);
    assert(ti != -1);

    // there can be two paths available
    final List<Position> pathforward = [];
    final List<Position> pathbackward = [];

    // move forward
    int i = fi;
    while (i != ti) {
      i = (i + 1) % neighbours.length;
      pathforward.add(neighbours[i]);
    }

    // move backward
    i = fi;
    while (i != ti) {
      i = (i - 1) % neighbours.length;
      pathbackward.add(neighbours[i]);
    }

    // verify which path is favourable
    final favourablePath = _getFavourablePath(pathforward, pathbackward);

    final List<SolverTile> steps = [];

    for (final position in favourablePath) {
      steps.add(_moveWhitespaceToNeighbourPos(position));
    }

    return steps;
  }

  /// this function moves whitespace making sure favourable steps are taken
  /// it is guranteed that `around` tile is a neighbour of whitespace
  List<SolverTile> _moveWhitespace({
    required Position around,
    required Position to,
  }) {
    final List<SolverTile> steps = [];

    final ws = whitespaceTile;

    if (ws.currentPosition == to) return steps;

    // the directions to take
    final favourableSteps = _takeFavourableSteps(
      from: ws.currentPosition,
      around: around,
      to: to,
    );

    steps.addAll(favourableSteps);

    return steps;
  }

  /// swaps `tile` with whitespace
  SolverTile _moveNeighbourTile(SolverTile tile) {
    return _moveWhitespaceToNeighbourPos(tile.currentPosition);
  }

  /// there are certain special case tiles
  /// this method returns which particular special type group a tiles belong to
  /// `v` is `tile.value` used to determine group for a tile
  SpecialCaseGroup _getGroup(int v) {
    v += 1;

    // end of each row, except last two rows
    if (v % n == 0 && n * (n - 1) != v) {
      return SpecialCaseGroup.topRight;
    }

    // last row, except last 2 elements
    if (n * (n - 1) < v && v < n * n - 1) {
      return SpecialCaseGroup.bottomLeft;
    }

    return SpecialCaseGroup.none;
  }

  /// checks if a tile is special case or not
  bool _isSpecialCase(int v) {
    return _getGroup(v) != SpecialCaseGroup.none;
  }

  /// target position are needed only for special case tiles
  Position _getTargetPos(SolverTile tile) {
    SpecialCaseGroup group = _getGroup(tile.value);

    assert(group != SpecialCaseGroup.none);

    if (group == SpecialCaseGroup.topRight) {
      return tile.correctPosition.bottom.left;
    }

    return tile.correctPosition.top.right;
  }

  /// determines steps for a special case `tile`
  List<SolverTile> _handleSpecialCaseFor(SolverTile tile) {
    final group = _getGroup(tile.value);

    assert(group != SpecialCaseGroup.none);

    final List<SolverTile> steps = [];

    if (tile.correctPosition == tile.currentPosition) return steps;

    final ws = whitespaceTile;

    if (group == SpecialCaseGroup.topRight) {
      // position the whitespace correctly
      if (ws.currentPosition != tile.currentPosition.right) {
        // move whitespace to left of tile
        steps.addAll(_moveWhitespaceToPos(tile.currentPosition.left));
      } else {
        // bottom, left, left, top
        // moves whitespace from right neighbour to left neighbour of target tile
        steps.add(_move(Direction.down));
        steps.add(_move(Direction.left));
        steps.add(_move(Direction.left));
        steps.add(_move(Direction.up));
      }

      // run positioning algorithm for top right case
      steps.add(_move(Direction.up));
      steps.add(_move(Direction.right));

      // placement of the correct tile
      steps.add(_move(Direction.down));

      // finally position displaced tiles correctly
      steps.add(_move(Direction.right));
      steps.add(_move(Direction.up));
      steps.add(_move(Direction.left));
      steps.add(_move(Direction.left));
      steps.add(_move(Direction.down));
    } else {
      // bottom left case

      // position the whitespace correctly
      steps.addAll(_moveWhitespaceToPos(tile.currentPosition.right));

      // run positioning algorithm for bottom left case
      steps.add(_move(Direction.up));
      steps.add(_move(Direction.left));
      steps.add(_move(Direction.left));
      steps.add(_move(Direction.down));

      // placement of the correct tile
      steps.add(_move(Direction.right));

      // finally position displaced tiles correctly
      steps.add(_move(Direction.down));
      steps.add(_move(Direction.left));
      steps.add(_move(Direction.up));
      steps.add(_move(Direction.up));
      steps.add(_move(Direction.right));
      steps.add(_move(Direction.right));
      steps.add(_move(Direction.down));
    }

    return steps;
  }

  /// moves a tile to either correct position / special case target position
  List<SolverTile> _moveTile(SolverTile tile) {
    final List<SolverTile> steps = [];

    final isSpecialCase = _isSpecialCase(tile.value);

    final targetPos =
        isSpecialCase ? _getTargetPos(tile) : tile.correctPosition;

    while (tile.currentPosition != targetPos) {
      // get the tile closest to the correct position of tile
      final neighbour = _getNeighbourOf(tile.currentPosition, targetPos);

      if (neighbour == null) {
        return steps;
      }

      // move whitespace to neighbour
      steps.addAll(_moveWhitespace(
        around: tile.currentPosition,
        to: neighbour,
      ));

      // swap
      steps.add(_moveNeighbourTile(tile));

      /// this step is needed for special tiles, where `targetPos != tile.correctPosition`
      if (tile.correctPosition == tile.currentPosition) return steps;
    }

    if (isSpecialCase) {
      steps.addAll(_handleSpecialCaseFor(tile));
    }

    return steps;
  }

  /// this method works on `tile` to put it in it's correctPosition
  /// and generates a series of tiles that can be tapped to achieve the solution
  List<SolverTile> _determineStepsFor(SolverTile tile) {
    final List<SolverTile> steps = [];

    // move the whitespace near the target tile
    steps.addAll(_moveWhitespaceNear(tile.currentPosition));

    // now using the help of whitespace tile, move the tile to it's correct position
    steps.addAll(_moveTile(tile));

    // return the generates steps
    return steps;
  }

  /// this method returns the list of steps to be followed to solve the puzzle
  List<SolverTile> _determineSteps() {
    final List<SolverTile> steps = [];

    /// determine the solve order, this current algorithm needs to solve the tile in a specific order
    final solvedOrderTiles = _determineSolveOrder();
    // the whitespace need not to be solved, thus remove it
    solvedOrderTiles.removeLast();

    /// after getting the order, solve one by one tile
    for (final tile in solvedOrderTiles) {
      if (tile.currentPosition != tile.correctPosition) {
        /// generate the steps for correctly placing `tile`
        /// from it's current position to it's correct position
        steps.addAll(_determineStepsFor(tile));
      }

      _tilesPlacedAlready.add(tile.value);
    }

    return steps;
  }

  void _onAutoSolvingStopped() {
    AppLogger.log('PuzzleSolver: _onAutoSolvingDone');
    puzzleHelperCubit.onAutoSolvingEnded();
  }

  void _takeStep(SolverTile tile) {
    /// add TileTapped event, which will cause UI rebuild to show solving puzzling
    puzzleBloc.add(
      TileTapped(tiles.firstWhere((t) => tile.value == t.value)),
    );
  }

  bool _isInterupted = false;
  late SolverTile _lastStep;
  int _stepsTakenBySolver = 0;

  Future<int> _solve(List<SolverTile> steps) async {
    for (final step in steps) {
      AppLogger.log('puzzle_solver :: _solve : taking steps');
      // if interupted, return
      if (_isInterupted) {
        // stopped due to interuption
        _onAutoSolvingStopped();
        return _stepsTakenBySolver;
      }

      // otherwise, take step
      _takeStep(step);

      // increment everytime a step is taken
      _stepsTakenBySolver += 1;

      // wait
      await Future.delayed(_stepDuration);
    }

    _takeStep(_lastStep);

    Timer(kMS50, () {
      // stopped due to puzzle completion
      _onAutoSolvingStopped();
    });

    return _stepsTakenBySolver;
  }

  /// Following public methods of puzzle_solver are exposed

  /// starts the auto solver, and returns the number of steps taken by the auto solver
  /// This method completes either when the puzzle is solved, or when stop is invoked
  Future<int> start() {
    AppLogger.log('PuzzleSolver: start()');
    // take a snapshot of the current tiles arrangement
    _tiles.clear();
    _tiles.addAll(tiles.map((tile) => SolverTile.fromTile(tile)));

    // cleanup
    _tilesPlacedAlready.clear();
    _stepsTakenBySolver = 0;
    _isInterupted = false;

    // determine all the steps to solve the puzzle
    final steps = _determineSteps();
    _lastStep = steps.removeLast();
    AppLogger.log('PuzzleSolver: start: steps.length: ${steps.length}');

    /// take real steps to solve the puzzle
    return _solve(steps);
  }

  void stop() {
    _isInterupted = true;
  }

  void dispose() {
    _isInterupted = true;
  }
}
