part of 'planet_orbital_animation_cubit.dart';

abstract class PlanetOrbitalAnimationState extends Equatable {
  const PlanetOrbitalAnimationState();

  @override
  List<Object> get props => [];
}

class PlanetOrbitalAnimationLoading extends PlanetOrbitalAnimationState {
  const PlanetOrbitalAnimationLoading();
}

class PlanetOrbitalAnimationReady extends PlanetOrbitalAnimationState {
  final Map<int, Animation<double>> _planetOrbitAnimation;

  const PlanetOrbitalAnimationReady(this._planetOrbitAnimation);

  Animation<double> getAnimation(int key) => _planetOrbitAnimation[key]!;

  @override
  List<Object> get props => [_planetOrbitAnimation];
}
