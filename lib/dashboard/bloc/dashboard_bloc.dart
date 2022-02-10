import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planets/models/coordinate.dart';
import 'package:planets/models/orbit.dart';
import 'package:planets/models/planet.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardLoading()) {
    on<DashboardInitialized>(_onDashboardInit);
  }

  String _getPlanetNameAt(int index) {
    return (index + 1).toString();
  }

  double _getPlanetSizeAt(int index) {
    return 100.0;
  }

  void _onDashboardInit(
    DashboardInitialized event,
    Emitter<DashboardState> emit,
  ) {
    const int totalPlanets = 9;
    final size = event.size;
    final firstRadius = size.height * 0.90;
    final steps = (size.width - firstRadius / 2) / (totalPlanets - 1);

    // TODO: ASSUMING IT'S LARGE SIZE SCREEN

    final orbits = List.generate(
      totalPlanets,
      (i) {
        final r1 = firstRadius + (steps * i * 1.9);
        final r2 = (firstRadius + (steps * i * 1.9)) + (i * i * 1.01);

        final planetSize = _getPlanetSizeAt(i);

        return Orbit(
          planet: Planet(
            parentSize: size,
            name: _getPlanetNameAt(i),
            planetSize: planetSize,
            origin: Coordinate(x: 0, y: size.height / 2),
            r1: r1 / 2,
            r2: r2 / 2,
          ),
          origin: Coordinate(x: -r1 / 2, y: size.height / 2 - (r2 / 2)),
          r1: r1,
          r2: r2,
          orbitWidth: (i > totalPlanets ~/ 2) ? 0.50 : 1.0,
        );
      },
    );

    emit(DashboardInited(orbits));
  }
}
