import 'package:flutter/material.dart';

class PlanetPuzzleStats extends StatelessWidget {
  const PlanetPuzzleStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '00:00:00 | 27 Moves',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        letterSpacing: 1.5,
      ),
    );
  }
}
