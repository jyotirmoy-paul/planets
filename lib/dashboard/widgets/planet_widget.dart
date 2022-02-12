import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/planet.dart';
import 'dart:math' as math;

import '../../utils/app_logger.dart';
import '../dashboard.dart';

class PlanetWidget extends StatelessWidget {
  final Planet planet;

  const PlanetWidget({Key? key, required this.planet}) : super(key: key);

  double _getX(double theta) {
    return planet.origin.x +
        planet.r1 * math.cos(theta) -
        planet.planetSize / 2;
  }

  double _getY(double theta) {
    return planet.origin.y +
        planet.r2 * math.sin(theta) -
        planet.planetSize / 2;
  }

  Widget _buildCorePlanet(BuildContext context) {
    final orbitalAnimationCubit = context.read<PlanetOrbitalAnimationCubit>();

    return InkWell(
      onHover: (isHovering) {
        if (isHovering) {
          orbitalAnimationCubit.pauseAnimation(planet);
        } else {
          orbitalAnimationCubit.playAnimation(planet);
        }
      },
      onTap: () {
        AppLogger.log('_planet tapped: ${planet.name}');
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          planet.name,
          style: const TextStyle(
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
      return _buildPositionedPlanet(child: _buildCorePlanet(context));
    }

    final state = animationState as PlanetOrbitalAnimationReady;

    final animation = state.getAnimation(planet.key);

    AppLogger.log('planet_widget state updated');

    return AnimatedBuilder(
      animation: animation,
      child: _buildCorePlanet(context),
      builder: (_, Widget? child) => _buildPositionedPlanet(
        child: child!,
        theta: animation.value,
      ),
    );
  }
}
