part of 'planet_selection_helper_cubit.dart';

class PlanetSelectionHelperState extends Equatable {
  final bool isPaused;

  const PlanetSelectionHelperState({this.isPaused = false});

  PlanetSelectionHelperState copyWith({
    bool? isPaused,
  }) {
    return PlanetSelectionHelperState(
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object> get props => [isPaused];
}
