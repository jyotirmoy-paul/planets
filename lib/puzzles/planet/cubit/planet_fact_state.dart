part of 'planet_fact_cubit.dart';

class PlanetFactState extends Equatable {
  final String fact;

  const PlanetFactState({this.fact = ''});

  @override
  List<Object> get props => [fact];
}
