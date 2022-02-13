import 'package:flutter/material.dart';
import 'package:planets/utils/constants.dart';

class PlanetPuzzleBoard extends StatelessWidget {
  final int size;
  final List<Widget> tiles;

  const PlanetPuzzleBoard({Key? key, required this.size, required this.tiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: Constants.puzzleAbsoluteSize,
        child: Stack(
          children: tiles,
        ),
      ),
    );
  }
}
