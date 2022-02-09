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
        final width = firstRadius + (steps * i * 1.9);
        final height = (firstRadius + (steps * i * 1.9)) + (i * i * 1.01);

        return Orbit(
          planet: Planet(name: i.toString()),
          origin: Coordinate(
            x: -width / 2,
            y: size.height / 2 - (height / 2),
          ),
          r1: width,
          r2: height,
          width: (i > totalPlanets ~/ 2) ? 0.50 : 1.0,
        );
      },
    );

    emit(DashboardInited(orbits));
  }
}
