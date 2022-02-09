part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardInitialized extends DashboardEvent {
  final Size size;

  const DashboardInitialized(this.size);

  @override
  List<Object> get props => [size];
}
