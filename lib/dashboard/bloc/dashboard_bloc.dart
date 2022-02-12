import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/coordinate.dart';
import '../../models/orbit.dart';
import '../../models/planet.dart';
import '../dashboard.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

// planet sizes
// 0.383	0.949	1	0.532	11.21	9.45	4.01	3.88	0.187
const double _baseSize = 80.0;
const Map<int, double> planetSizeFactor = {
  0: 0.383, // mercury
  1: 0.949, // venus
  2: 1, // earth
  3: 0.532, // mars
  4: 3.0, // 11.21, // jupiter
  5: 2.3, // 9.45, // saturn
  6: 1.15, //4.01, // uranus
  7: 1.02, // 3.88, // neptune
  8: 0.25, // 0.187, // pluto
};

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final PlanetOrbitalAnimationCubit _planetAnimationCubit;

  DashboardBloc(this._planetAnimationCubit) : super(DashboardLoading()) {
    on<DashboardInitialized>(_onDashboardInit);
    on<DashboardResized>(_onDashboardResized);
  }

  String _getPlanetNameAt(int index) {
    return (index + 1).toString();
  }

  double _getPlanetSizeAt(int index) {
    return _baseSize * planetSizeFactor[index]!;
  }

  List<Orbit> _generateOrbits(Size size) {
    const int totalPlanets = 9;
    final firstRadius = size.width * 0.50;
    final steps = (size.width - firstRadius / 2) / (totalPlanets - 1);

    // generate the orbits and planets
    return List.generate(
      totalPlanets,
      (i) {
        final r1 = firstRadius + (steps * i * 1.9);
        final r2 = (firstRadius + (steps * i * 1.9)) + (i * i * 1.01);

        final planetSize = _getPlanetSizeAt(i);

        return Orbit(
          planet: Planet(
            key: i,
            name: _getPlanetNameAt(i),
            parentSize: size,
            planetSize: planetSize,
            origin: Coordinate(x: 0, y: size.height / 2),
            r1: r1 / 2,
            r2: r2 / 2,
          ),
          origin: Coordinate(x: -r1 / 2, y: size.height / 2 - (r2 / 2)),
          r1: r1,
          r2: r2,
          orbitWidth: (i > totalPlanets ~/ 2) ? 4.0 : 5.0,
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
    // generate orbits
    final orbits = _generateOrbits(event.size);

    // init the animations for planets
    _planetAnimationCubit.initAnimators(orbits);

    emit(DashboardReady(orbits));
  }
}
