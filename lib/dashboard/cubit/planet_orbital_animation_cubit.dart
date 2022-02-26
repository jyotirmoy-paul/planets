import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/orbit.dart';
import '../../models/planet.dart';
import '../../utils/constants.dart';

part 'planet_orbital_animation_state.dart';

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
    return kRevolutionThresholdFactor[type]!;
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
          ((kRevolutionFactor[type]! * kBaseRevolutionSeconds) * 1000)
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
        kPausedPosition[planetType]!,
        duration: kMS300,
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