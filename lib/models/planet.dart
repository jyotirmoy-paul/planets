import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../dashboard/dashboard.dart';
import 'coordinate.dart';

enum PlanetType {
  mercury,
  venus,
  earth,
  mars,
  jupiter,
  saturn,
  uranus,
  neptune,
  pluto,
}

extension PlanetTypeParsing on PlanetType {
  String get value => name.split('.').last.toUpperCase();
}

class Planet extends Equatable {
  final PlanetType type;
  final int key;
  final Coordinate origin;
  final double r1;
  final double r2;
  final double planetSize;
  final Size parentSize;

  const Planet({
    required this.key,
    required this.type,
    required this.origin,
    required this.r1,
    required this.r2,
    required this.planetSize,
    required this.parentSize,
  });

  Widget get widget => PlanetWidget(key: ValueKey(type), planet: this);

  String get name => type.name;

  @override
  List<Object?> get props => [type, key, origin, r1, r2, planetSize];

  @override
  String toString() {
    return type.toString().toUpperCase();
  }
}
