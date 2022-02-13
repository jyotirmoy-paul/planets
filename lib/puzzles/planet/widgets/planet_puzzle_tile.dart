import 'package:flutter/material.dart';
import 'package:planets/models/tile.dart';
import 'package:planets/puzzle/puzzle.dart';

class PlanetPuzzleTile extends StatelessWidget {
  final Tile tile;
  final PuzzleState state;

  const PlanetPuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      left: tile.offset * (tile.currentPosition.y - tile.correctPosition.y),
      top: tile.offset * (tile.currentPosition.x - tile.correctPosition.x),
      height: tile.childSize.height,
      width: tile.childSize.width,
      child: ClipPath(
        clipper: _PuzzlePieceClipper(tile),
        child: tile.child,
      ),
    );
  }
}

class _PuzzlePieceClipper extends CustomClipper<Path> {
  final Tile tile;

  const _PuzzlePieceClipper(this.tile);

  @override
  Path getClip(Size size) {
    return _getPiecePath(size, tile);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

const _paddingOffset = 5.0;
const _roundOffset = 15.0;
const _radius = Radius.circular(_roundOffset);

Path _getPiecePath(Size size, Tile tile) {
  double width = (size.width / tile.puzzleSize);
  double height = (size.height / tile.puzzleSize);

  double offsetX = tile.correctPosition.x * width;
  double offsetY = tile.correctPosition.y * height;

  width -= _paddingOffset;
  height -= _paddingOffset;

  final path = Path();

  path.moveTo(offsetX + _roundOffset, offsetY);
  path.lineTo(offsetX + width - _roundOffset, offsetY);

  path.arcToPoint(
    Offset(offsetX + width, offsetY + _roundOffset),
    radius: _radius,
  );

  path.lineTo(offsetX + width, offsetY + height - _roundOffset);

  path.arcToPoint(
    Offset(offsetX + width - _roundOffset, offsetY + height),
    radius: _radius,
  );

  path.lineTo(offsetX + _roundOffset, offsetY + height);

  path.arcToPoint(
    Offset(offsetX, offsetY + height - _roundOffset),
    radius: _radius,
  );

  path.lineTo(offsetX, offsetY + _roundOffset);

  path.arcToPoint(
    Offset(offsetX + _roundOffset, offsetY),
    radius: _radius,
  );

  return path;
}
