import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../layout/layout.dart';
import '../../models/coordinate.dart';
import '../../models/orbit.dart';
import '../../models/planet.dart';
import '../../utils/constants.dart';
import '../dashboard.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final PlanetOrbitalAnimationCubit _planetAnimationCubit;

  DashboardBloc(this._planetAnimationCubit) : super(DashboardLoading()) {
    on<DashboardInitialized>(_onDashboardInit);
    on<DashboardResized>(_onDashboardResized);
  }

  PlanetType _getPlanetTypeAt(int index) {
    return PlanetType.values[index];
  }

  double _getPlanetSizeAt(int index, Size size) {
    return size.width * 0.055 * kPlanetSizeFactor[_getPlanetTypeAt(index)]!;
  }

  List<Orbit> _generateOrbits(Size size) {
    const int totalPlanets = kTotalPlanets;
    final firstRadius = size.width * 0.50;
    final steps = (size.width - firstRadius / 2) / (totalPlanets - 1);

    // generate the orbits and planets
    return List.generate(
      totalPlanets,
      (i) {
        final r1 = firstRadius + (steps * i * 1.9);
        final r2 = (firstRadius + (steps * i * 1.9)) + (i * i * 1.01);

        final planetSize = _getPlanetSizeAt(i, size);

        return Orbit(
          planet: Planet(
            key: i,
            type: _getPlanetTypeAt(i),
            parentSize: size,
            planetSize: planetSize,
            origin: Coordinate(x: 0, y: size.height / 2),
            r1: r1 / 2,
            r2: r2 / 2,
          ),
          origin: Coordinate(x: -r1 / 2, y: size.height / 2 - (r2 / 2)),
          r1: r1,
          r2: r2,
          orbitWidth: (i > totalPlanets ~/ 2) ? 2.0 : 2.5,
        );
      },
    );
  }

  void _onDashboardResized(
    DashboardResized event,
    Emitter<DashboardState> emit,
  ) {
    // generate new orbits
    final orbits = _generateOrbits(event.size);

    emit(DashboardReady(orbits));
  }

  void _onDashboardInit(
    DashboardInitialized event,
    Emitter<DashboardState> emit,
  ) {
    Size size = event.size;

    if (event.size.width < AppBreakpoints.medium) {
      size = Size(AppBreakpoints.medium, event.size.height);
    }

    // generate orbits
    final orbits = _generateOrbits(size);

    // init the animations for planets
    _planetAnimationCubit.initAnimators(orbits);

    emit(DashboardReady(orbits));
  }
}
