part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardReady extends DashboardState {
  final List<Orbit> orbits;

  const DashboardReady(this.orbits);

  @override
  List<Object> get props => [orbits];
}
