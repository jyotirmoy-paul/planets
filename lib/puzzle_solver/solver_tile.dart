import '../models/position.dart';
import '../models/tile.dart';

class SolverTile {
  final int value;
  final bool isWhitespace;
  final Position correctPosition;
  Position currentPosition;

  SolverTile({
    required this.value,
    required this.currentPosition,
    required this.isWhitespace,
    required this.correctPosition,
  });

  factory SolverTile.none() {
    return SolverTile(
      value: -1,
      currentPosition: Position.zero(),
      isWhitespace: false,
      correctPosition: Position.zero(),
    );
  }

  factory SolverTile.fromTile(Tile tile) {
    return SolverTile(
      value: tile.value,
      currentPosition: tile.currentPosition,
      correctPosition: tile.correctPosition,
      isWhitespace: tile.isWhitespace,
    );
  }

  bool get isNone => value == -1;

  @override
  String toString() {
    return 'SolverTile($currentPosition)';
  }
}
