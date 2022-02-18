part of 'planet_puzzle_bloc.dart';

abstract class PlanetPuzzleEvent extends Equatable {
  const PlanetPuzzleEvent();

  @override
  List<Object?> get props => [];
}

class PlanetPuzzleResetEvent extends PlanetPuzzleEvent {
  const PlanetPuzzleResetEvent();
}

class PlanetCountdownStarted extends PlanetPuzzleEvent {
  const PlanetCountdownStarted();
}

class PlanetCountdownTicked extends PlanetPuzzleEvent {
  const PlanetCountdownTicked();
}

class PlanetCountdownStopped extends PlanetPuzzleEvent {
  const PlanetCountdownStopped();
}

class PlanetCountdownReset extends PlanetPuzzleEvent {
  const PlanetCountdownReset({this.secondsToBegin});

  final int? secondsToBegin;

  @override
  List<Object?> get props => [secondsToBegin];
}
