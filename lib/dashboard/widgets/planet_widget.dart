import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/planet.dart';
import '../../utils/utils.dart';
import '../cubit/planet_selection_cubit.dart';
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
      return _buildPositionedPlanet(
        child: _CorePlanet(key: ValueKey(planet.type), planet: planet),
      );
    }

    final state = animationState as PlanetOrbitalAnimationReady;
    final animation = state.getAnimation(planet.type);

    return AnimatedBuilder(
      animation: animation,
      child: _CorePlanet(key: ValueKey(planet.type), planet: planet),
      builder: (_, Widget? child) => _buildPositionedPlanet(
        child: child!,
        theta: animation.value,
      ),
    );
  }
}

class _CorePlanet extends StatelessWidget {
  final Planet planet;

  const _CorePlanet({Key? key, required this.planet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        context.read<PlanetSelectionCubit>().onPlanetSelected(planet);
      },
      child: Transform.rotate(
        angle: planet.type == PlanetType.saturn ? 0 : math.pi / 10,
        child: Image.asset(Utils.getPlanetThumbFor(planet.type)),
      ),
    );
  }
}
