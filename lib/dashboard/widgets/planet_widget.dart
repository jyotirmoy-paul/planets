import 'package:flutter/material.dart';
import 'package:planets/models/planet.dart';

class PlanetWidget extends StatelessWidget {
  final Planet planet;

  const PlanetWidget({
    Key? key,
    required this.planet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset(1.0, 0.5),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          planet.name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
