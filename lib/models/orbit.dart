import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:planets/dashboard/dashboard.dart';
import 'package:planets/models/coordinate.dart';
import 'package:planets/models/planet.dart';

class Orbit extends Equatable {
  final Planet planet;
  final Coordinate origin;
  final double r1;
  final double r2;
  final double width;

  const Orbit({
    required this.planet,
    required this.origin,
    required this.r1,
    required this.r2,
    required this.width,
  });

  Widget get widget => OrbitWidget(orbit: this);

  @override
  List<Object?> get props => [planet, origin, r1, r2, widget];
}
