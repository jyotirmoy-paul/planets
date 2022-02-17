import 'package:planets/models/position.dart';
import 'package:planets/models/tile.dart';

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

  factory SolverTile.fromTile(Tile tile) {
    return SolverTile(
      value: tile.value,
      currentPosition: tile.currentPosition,
      correctPosition: tile.correctPosition,
      isWhitespace: tile.isWhitespace,
    );
  }
}
