import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
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
const Map<int, double> _planetRevolutionFactor = {
  0: 0.50, // 0.24, // mercury
  1: 0.80, // 0.62, // venus
  2: 1, // earth
  3: 1.88, // mars
  4: 6, // 11, // jupiter
  5: 7, // 29, // saturn
  6: 10, // 84, // uranus
  7: 15, // 164, // neptune
  8: 18, // 247, // pluto
};

class PlanetOrbitalAnimationCubit extends Cubit<PlanetOrbitalAnimationState> {
  PlanetOrbitalAnimationCubit(this._parentSize)
      : super(const PlanetOrbitalAnimationLoading());

  late final TickerProvider _tickerProvider;
  late final Size _parentSize;

  final _random = math.Random();

  // <planet-key, animation>
  final Map<int, AnimationController> _animationController = {};
  final Map<int, Animation<double>> _animations = {};

  void setTickerProvider(TickerProvider tickerProvider) {
    _tickerProvider = tickerProvider;
  }

  static const _thresholdDegree = 0;
  static const _thresholdRadian = math.pi / (180 / _thresholdDegree);

  double _getMinAngle(Orbit orbit) {
    if (orbit.planet.key <= 1) return -math.pi / 2 - _thresholdRadian;

    final planet = orbit.planet;

    return math.asin((planet.planetSize / 2 - planet.origin.y) / planet.r2) -
        _thresholdRadian;
  }

  double _getMaxAngle(Orbit orbit) {
    if (orbit.planet.key <= 1) return math.pi / 2 + _thresholdRadian;

    final planet = orbit.planet;

    return math.asin(
          (_parentSize.height + planet.planetSize / 2 - planet.origin.y) /
              planet.r2,
        ) +
        _thresholdRadian;
  }

  Duration _getDuration(int key) {
    return Duration(
      milliseconds:
          ((_planetRevolutionFactor[key]! * _baseRevolutionSeconds) * 1000)
              .toInt(),
    );
  }

  Duration _getPausedDuration(int key) {
    return Duration(seconds: _getDuration(key).inSeconds * 5);
  }

  void playAnimation(Planet planet) {
    final controller = _animationController[planet.key];
    if (controller == null) return;

    controller.stop();
    controller.repeat(period: _getDuration(planet.key));
  }

  void pauseAnimation(Planet planet) {
    final controller = _animationController[planet.key];
    if (controller == null) return;

    controller.stop();
    controller.repeat(period: _getPausedDuration(planet.key));
  }

  void initAnimators(List<Orbit> orbits) {
    for (final orbit in orbits) {
      final key = orbit.planet.key;

      final controller = AnimationController(
        value: _random.nextDouble(),
        vsync: _tickerProvider,
      )..repeat(period: _getDuration(key));

      _animationController[key] = controller;

      final tween = Tween(
        begin: _getMinAngle(orbit),
        end: _getMaxAngle(orbit),
      );

      _animations[key] = tween.animate(controller);
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
