import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../dashboard/dashboard.dart';
import 'coordinate.dart';
import 'planet.dart';

class Orbit extends Equatable {
  final Planet planet;
  final Coordinate origin;
  final double r1;
  final double r2;
  final double orbitWidth;

  const Orbit({
    required this.planet,
    required this.origin,
    required this.r1,
    required this.r2,
    required this.orbitWidth,
  });

  Widget get widget => OrbitWidget(orbit: this);

  @override
  List<Object?> get props => [planet, origin, r1, r2, widget];
}
