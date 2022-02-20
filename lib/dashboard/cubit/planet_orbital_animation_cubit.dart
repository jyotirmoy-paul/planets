import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:planets/utils/app_logger.dart';

import '../../models/orbit.dart';
import '../../models/planet.dart';

part 'planet_orbital_animation_state.dart';

/// Revolution periods of all planets - to be used for animation period calculation
// Planet	Period of Revolution
// Mercury	88 days       0.24
// Venus	224.7 days      0.62
// Earth	365 days        1
// Mars	687 days          1.88
// Jupiter	11.9 years    11
// Saturn	29.5 years      29
// Uranus	84 years        84
// Neptune	164.8 years   164
// Pluto	247.7 years     247

const int _baseRevolutionSeconds = 10;
const Map<PlanetType, double> _planetRevolutionFactor = {
  PlanetType.mercury: 0.50, // 0.24,
  PlanetType.venus: 0.80, // 0.62,
  PlanetType.earth: 1,
  PlanetType.mars: 1.88,
  PlanetType.jupiter: 3.0, // 11,
  PlanetType.saturn: 6.1, // 29,
  PlanetType.uranus: 9.3, // 84,
  PlanetType.neptune: 12.0, // 164,
  PlanetType.pluto: 16.0, // 247,
};

const Map<PlanetType, double> _thresholdFactor = {
  PlanetType.mercury: 1.0,
  PlanetType.venus: 1.0,
  PlanetType.earth: 1.2,
  PlanetType.mars: 0.90,
  PlanetType.jupiter: 1.5,
  PlanetType.saturn: 1.2,
  PlanetType.uranus: 0.80,
  PlanetType.neptune: 0.85,
  PlanetType.pluto: 0.50,
};

const Map<PlanetType, double> _pausedPosition = {
  PlanetType.mercury: 0.60,
  PlanetType.venus: 0.35,
  PlanetType.earth: 0.45,
  PlanetType.mars: 0.33,
  PlanetType.jupiter: 0.55,
  PlanetType.saturn: 0.41,
  PlanetType.uranus: 0.30,
  PlanetType.neptune: 0.53,
  PlanetType.pluto: 0.30,
};

class PlanetOrbitalAnimationCubit extends Cubit<PlanetOrbitalAnimationState> {
  PlanetOrbitalAnimationCubit(this._parentSize)
      : super(const PlanetOrbitalAnimationLoading());

  late final TickerProvider _tickerProvider;
  late final Size _parentSize;

  final _random = math.Random();

  // <planet-key, animation>
  final Map<PlanetType, AnimationController> _animationController = {};
  final Map<PlanetType, Animation<double>> _animations = {};

  bool _isStopped = false;

  void setTickerProvider(TickerProvider tickerProvider) {
    _tickerProvider = tickerProvider;
  }

  static const _thresholdDegree = 18;
  static const _thresholdRadian = (math.pi * _thresholdDegree) / 180;

  double _getThresholdFactor(PlanetType type) {
    return _thresholdFactor[type]!;
  }

  double _getMinAngle(Orbit orbit) {
    final planet = orbit.planet;

    final threshold = _thresholdRadian * _getThresholdFactor(planet.type);

    if (planet.key <= 1) return -math.pi / 2 - threshold;
    return math.asin((planet.planetSize / 2 - planet.origin.y) / planet.r2) -
        threshold;
  }

  double _getMaxAngle(Orbit orbit) {
    final planet = orbit.planet;

    final threshold = _thresholdRadian * _getThresholdFactor(planet.type);

    if (planet.key <= 1) return math.pi / 2 + threshold;
    return math.asin(
          (_parentSize.height + planet.planetSize / 2 - planet.origin.y) /
              planet.r2,
        ) +
        threshold;
  }

  Duration _getDuration(PlanetType type) {
    return Duration(
      milliseconds:
          ((_planetRevolutionFactor[type]! * _baseRevolutionSeconds) * 1000)
              .toInt(),
    );
  }

  Duration _getPausedDuration(PlanetType type) {
    return Duration(seconds: _getDuration(type).inSeconds * 5);
  }

  void playAnimation(Planet planet) {
    if (_isStopped) return;
    final controller = _animationController[planet.type];
    if (controller == null) return;

    controller.stop();
    controller.repeat(period: _getDuration(planet.type));
  }

  void pauseAnimation(Planet planet) {
    if (_isStopped) return;
    final controller = _animationController[planet.type];
    if (controller == null) return;

    controller.stop();
    controller.repeat(period: _getPausedDuration(planet.type));
  }

  void stopAll() {
    _isStopped = true;
    _animationController.forEach((planetType, controller) {
      // final v = math.max(math.min(_random.nextDouble(), 0.60), 0.30);
      // AppLogger.log('planetpositionfinding: $planetType :: $v');
      controller.stop();
      controller.animateTo(
        _pausedPosition[planetType]!,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void playAll() {
    _isStopped = false;
    _animationController.forEach((planetType, controller) {
      controller.repeat(period: _getDuration(planetType));
    });
  }

  void initAnimators(List<Orbit> orbits) {
    for (final orbit in orbits) {
      final planet = orbit.planet;

      final controller = AnimationController(
        value: math.max(math.min(_random.nextDouble(), 0.60), 0.30),
        vsync: _tickerProvider,
      )..repeat(period: _getDuration(planet.type));

      _animationController[planet.type] = controller;

      final tween = Tween(
        begin: _getMinAngle(orbit),
        end: _getMaxAngle(orbit),
      );

      _animations[planet.type] = tween.animate(controller);
    }

    emit(PlanetOrbitalAnimationReady(_animations));
  }

  void _disposeAnimations() {
    _animationController.forEach((_, controller) {
      controller.dispose();
    });
  }

  @override
  Future<void> close() {
    _disposeAnimations();
    return super.close();
  }
}

// IDEAS
// 1. Pause animation
// 2. Slow animation - 1x, 0.5x, 0.25x