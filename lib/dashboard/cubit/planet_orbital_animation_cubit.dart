import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/orbit.dart';

part 'planet_orbital_animation_state.dart';

/// Revolution periods of all planets - to be used for animation period calculation
// Planet	Period of Revolution
// Mercury	88 days
// Venus	224.7 days
// Earth	365 days
// Mars	687 days
// Jupiter	11.9 years
// Saturn	29.5 years
// Uranus	84 years
// Neptune	164.8 years
// Pluto	247.7 years

class PlanetOrbitalAnimationCubit extends Cubit<PlanetOrbitalAnimationState> {
  PlanetOrbitalAnimationCubit() : super(const PlanetOrbitalAnimationLoading());

  late final TickerProvider _tickerProvider;
  final _random = math.Random();

  void setTickerProvider(TickerProvider tickerProvider) {
    _tickerProvider = tickerProvider;
  }

  double _getAngle(int key) {
    return math.pi / 2;
  }

  Duration _getDuration(int key) {
    return Duration(seconds: 20);
  }

  void initAnimators(List<Orbit> orbits) {
    // <planet-key, animation>
    Map<int, Animation<double>> animations = {};

    for (final orbit in orbits) {
      final key = orbit.planet.key;

      final controller = AnimationController(
        value: _random.nextDouble(),
        vsync: _tickerProvider,
      )..repeat(period: _getDuration(key));

      final tween = Tween(
        begin: -_getAngle(key),
        end: _getAngle(key),
      );

      animations[key] = tween.animate(controller);
    }

    emit(PlanetOrbitalAnimationReady(animations));
  }
}
