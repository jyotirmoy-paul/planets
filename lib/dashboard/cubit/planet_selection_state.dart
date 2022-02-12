part of 'planet_selection_cubit.dart';

abstract class PlanetSelectionState extends Equatable {
  const PlanetSelectionState();

  @override
  List<Object> get props => [];
}

class NoPlanetSelected extends PlanetSelectionState {}

class PlanetSelected extends PlanetSelectionState {
  final Planet planet;

  const PlanetSelected({required this.planet});

  @override
  List<Object> get props => [planet];
}
