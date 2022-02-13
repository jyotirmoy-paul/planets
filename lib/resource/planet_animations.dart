import 'package:planets/models/planet.dart';

abstract class PlanetAnimations {
  static const Map<PlanetType, String> _animations = {
    PlanetType.mercury: '',
    PlanetType.venus: '',
    PlanetType.earth: '',
    PlanetType.mars: '',
    PlanetType.jupiter: '',
    PlanetType.saturn: '',
    PlanetType.uranus: '',
    PlanetType.neptune: '',
    PlanetType.pluto: '',
  };

  static animationFor(PlanetType type) => _animations[type]!;
}
