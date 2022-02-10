import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/dashboard/cubit/planet_orbital_animation_cubit.dart';
import 'package:planets/models/planet.dart';
import 'dart:math' as math;

import 'package:planets/utils/app_logger.dart';

class PlanetWidget extends StatelessWidget {
  final Planet planet;

  const PlanetWidget({Key? key, required this.planet}) : super(key: key);

  double _getX(double theta) {
    return planet.origin.x +
        planet.r1 * math.cos(theta) -
        planet.planetSize / 2;

    // return math.max(x, -planet.planetSize);
  }

  double _getY(double theta) {
    return planet.origin.y +
        planet.r2 * math.sin(theta) -
        planet.planetSize / 2;
    // return math.min(math.max(-planet.planetSize, y), planet.parentSize.height);
  }

  Widget _buildCorePlanet() {
    return InkWell(
      onTap: () {
        AppLogger.log('_planet tapped: ${planet.name}');
      },
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

  Widget _buildPositionedPlanet({required Widget child, double theta = 0.0}) {
    return Positioned(
      top: _getY(theta),
      left: _getX(theta),
      width: planet.planetSize,
      height: planet.planetSize,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final animationState =
        context.select((PlanetOrbitalAnimationCubit cubit) => cubit.state);

    if (animationState is PlanetOrbitalAnimationLoading) {
      return _buildPositionedPlanet(child: _buildCorePlanet());
    }

    final state = animationState as PlanetOrbitalAnimationReady;

    final animation = state.getAnimation(planet.key);

    return AnimatedBuilder(
      animation: animation,
      child: _buildCorePlanet(),
      builder: (_, Widget? child) => _buildPositionedPlanet(
        child: child!,
        theta: animation.value,
      ),
    );
  }
}
