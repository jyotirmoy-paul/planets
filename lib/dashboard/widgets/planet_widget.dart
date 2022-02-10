import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:planets/models/planet.dart';
import 'dart:math' as math;

class PlanetWidget extends StatelessWidget {
  final Planet planet;

  PlanetWidget({
    Key? key,
    required this.planet,
  }) : super(key: key);

  final theta = ValueNotifier<double>(-math.pi / 2);

  double _getX() {
    return planet.origin.x +
        planet.r1 * math.cos(theta.value) -
        planet.planetSize / 2;
  }

  double _getY() {
    final y = planet.origin.y +
        planet.r2 * math.sin(theta.value) -
        planet.planetSize / 2;

    return math.min(math.max(-planet.planetSize, y), planet.parentSize.height);
  }

  @override
  Widget build(BuildContext context) {
    // return Positioned(
    //   top: _getY(),
    //   left: _getX(),
    //   child: Text(
    //     planet.name,
    //     style: TextStyle(color: Colors.white),
    //   ),
    // );

    return Positioned(
      top: _getY(),
      left: _getX(),
      width: planet.planetSize,
      height: planet.planetSize,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          planet.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
