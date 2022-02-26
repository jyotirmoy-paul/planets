import 'package:flutter/material.dart';

import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class SaturnPuzzleTheme extends PlanetPuzzleTheme {
  const SaturnPuzzleTheme();

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get surface => Colors.grey;

  @override
  Color get onSurface => Colors.amber;

  @override
  String get backgroundAsset => AppAssets.saturnLandscape;

  @override
  String get assetForTile => AppAssets.saturnAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.saturnImage;

  @override
  String get placeholderThumbnail => AppAssets.saturnThumb;
}
