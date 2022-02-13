import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/models/tile.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/puzzles/planet/layout/planet_puzzle_layout_delegate.dart';
import 'package:planets/theme/bloc/theme_bloc.dart';
import 'package:planets/utils/app_logger.dart';
import 'package:rive/rive.dart';

import '../../../layout/layout.dart';

class PlanetPuzzleTile extends StatefulWidget {
  final Tile tile;
  final PuzzleState state;

  const PlanetPuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
  }) : super(key: key);

  @override
  State<PlanetPuzzleTile> createState() => _PlanetPuzzleTileState();
}

class _PlanetPuzzleTileState extends State<PlanetPuzzleTile> {
  late final Widget child;

  double scale = 1.0;

  void _onHovering(bool isHovering) {
    setState(() {
      scale = isHovering ? 0.9 : 1.0;
    });
  }

  double get size {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= AppBreakpoints.small) {
      return BoardSize.small;
    }

    if (screenWidth <= AppBreakpoints.medium) {
      return BoardSize.medium;
    }

    return BoardSize.large;
  }

  _buildChild() {
    final theme = context.read<ThemeBloc>().state.theme;

    child = RiveAnimation.asset(
      theme.assetForTile,
      // controllers: [_controller],
      onInit: (_) {
        AppLogger.log('${widget.tile.value} is rebuild and reinited');
      },
      fit: BoxFit.cover,
      placeHolder: Container(color: theme.primary),
    );
  }

  @override
  void initState() {
    super.initState();
    _buildChild();
  }

  @override
  Widget build(BuildContext context) {
    final puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;

    final offset = size / widget.tile.puzzleSize;
    final x = widget.tile.currentPosition.x;
    final y = widget.tile.currentPosition.y;

    final correctX = widget.tile.correctPosition.x;
    final correctY = widget.tile.correctPosition.y;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      top: offset * (y - correctY),
      left: offset * (x - correctX),
      child: AnimatedScale(
        scale: scale,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
        alignment: FractionalOffset(
          ((correctX + 1 / 2) * offset) / size,
          ((correctY + 1 / 2) * offset) / size,
        ),
        child: ClipPath(
          clipper: _PuzzlePieceClipper(widget.tile),
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (puzzleIncomplete) {
                context.read<PuzzleBloc>().add(TileTapped(widget.tile));
              }
            },
            onHover: _onHovering,
            child: SizedBox.square(
              dimension: size,
              child: child,
            ),
          ),
        ),
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
