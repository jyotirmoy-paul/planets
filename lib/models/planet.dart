import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:planets/dashboard/dashboard.dart';

class Planet extends Equatable {
  final String name;

  const Planet({
    required this.name,
  });

  Widget get widget => PlanetWidget(planet: this);

  @override
  List<Object?> get props => [
        name,
      ];
}
