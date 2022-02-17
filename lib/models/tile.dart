import 'package:equatable/equatable.dart';

import 'position.dart';

class Tile extends Equatable {
  final int value;
  final Position correctPosition;
  final Position currentPosition;
  final bool isWhitespace;
  final int puzzleSize;

  const Tile({
    required this.value,
    required this.correctPosition,
    required this.currentPosition,
    required this.puzzleSize,
    this.isWhitespace = false,
  });

  Tile copyWith({required Position currentPosition}) {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      puzzleSize: puzzleSize,
      isWhitespace: isWhitespace,
    );
  }

  @override
  List<Object> get props => [
        value,
        correctPosition,
        currentPosition,
        puzzleSize,
        isWhitespace,
      ];

  @override
  String toString() {
    return 'Tile($currentPosition)';
  }
}
