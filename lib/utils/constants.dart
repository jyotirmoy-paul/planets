import 'package:flutter/material.dart';

import '../models/planet.dart';
import '../models/puzzle.dart';

// theme
const kFontFamily = 'Freshman';

const kProjectDomain = 'fph-planets.web.app';
const kUrl = 'https://$kProjectDomain/#/';
const kGithubUrl = 'https://github.com/jyotirmoy-paul/planets';

// puzzle solving durations expected for perfect score
const k3PuzzleDuration = Duration(minutes: 2);
const k4PuzzleDuration = Duration(minutes: 5);
const k5PuzzleDuration = Duration(minutes: 8);

// durations
const kMS50 = Duration(milliseconds: 50);
const kMS100 = Duration(milliseconds: 100);
const kMS150 = Duration(milliseconds: 150);
const kMS200 = Duration(milliseconds: 200);
const kMS250 = Duration(milliseconds: 250);
const kMS300 = Duration(milliseconds: 300);
const kMS350 = Duration(milliseconds: 350);
const kMS400 = Duration(milliseconds: 400);
const kMS500 = Duration(milliseconds: 500);
const kMS800 = Duration(milliseconds: 800);
const kS1 = Duration(seconds: 1);
const kS20 = Duration(seconds: 20);

// fractional offset
const kFOTopLeft = FractionalOffset(0.05, 0.05);
const kFOTopRight = FractionalOffset(0.95, 0.05);
const kFOTopCenter = FractionalOffset(0.5, 0.05);
const kFOBottomLeft = FractionalOffset(0.05, 0.98);
const kFOBottomRight = FractionalOffset(0.95, 0.98);
const kFOBottomCenter = FractionalOffset(0.50, 0.98);

// background
const kBaseStarSize = 10.0;
const kMinStarPercentage = 0.20;
const kNoStars = 40;
const kBackgroundGradient = [
  Color(0xff0a0826),
  Color(0xff251f45),
  Color(0xff242021),
  Color(0xff251f58),
];

// dashboard
/// I know Pluto is not a planet, but I feel bad excluding him,
/// besides, it's just a game, no need to be so strict about Pluto :-D
const kTotalPlanets = 9;

const Map<PuzzleLevel, int> kPuzzleLevel = {
  PuzzleLevel.easy: 3,
  PuzzleLevel.medium: 4,
  PuzzleLevel.hard: 5,
};

// planet sizes
// 0.383	0.949	1	0.532	11.21	9.45	4.01	3.88	0.187
const Map<PlanetType, double> kPlanetSizeFactor = {
  PlanetType.mercury: 0.383,
  PlanetType.venus: 0.949, // venus
  PlanetType.earth: 1, // earth
  PlanetType.mars: 0.532, // mars
  PlanetType.jupiter: 3.0, // 11.21,
  PlanetType.saturn: 2.3, // 9.45,
  PlanetType.uranus: 1.15, //4.01,
  PlanetType.neptune: 1.02, // 3.88,
  PlanetType.pluto: 0.25, // 0.187,
};

/// Revolution periods of all planets - to be used for animation period calculation
// Planet	Period of Revolution
// Mercury	88 days       0.24
// Venus	224.7 days      0.62
// Earth	365 days        1
// Mars	687 days          1.88
// Jupiter	11.9 years    11
// Saturn	29.5 years      29
// Uranus	84 years        84
// Neptune	164.8 years   164
// Pluto	247.7 years     247

const int kBaseRevolutionSeconds = 10;

const Map<PlanetType, double> kRevolutionFactor = {
  PlanetType.mercury: 0.50, // 0.24,
  PlanetType.venus: 0.80, // 0.62,
  PlanetType.earth: 1,
  PlanetType.mars: 1.88,
  PlanetType.jupiter: 3.0, // 11,
  PlanetType.saturn: 6.1, // 29,
  PlanetType.uranus: 9.3, // 84,
  PlanetType.neptune: 12.0, // 164,
  PlanetType.pluto: 16.0, // 247,
};

const Map<PlanetType, double> kRevolutionThresholdFactor = {
  PlanetType.mercury: 1.0,
  PlanetType.venus: 1.0,
  PlanetType.earth: 1.2,
  PlanetType.mars: 0.90,
  PlanetType.jupiter: 1.5,
  PlanetType.saturn: 1.2,
  PlanetType.uranus: 0.80,
  PlanetType.neptune: 0.85,
  PlanetType.pluto: 0.50,
};

const Map<PlanetType, double> kPausedPosition = {
  PlanetType.mercury: 0.60,
  PlanetType.venus: 0.35,
  PlanetType.earth: 0.58,
  PlanetType.mars: 0.46,
  PlanetType.jupiter: 0.55,
  PlanetType.saturn: 0.41,
  PlanetType.uranus: 0.30,
  PlanetType.neptune: 0.53,
  PlanetType.pluto: 0.30,
};

const kMinSunSize = 350.0;
