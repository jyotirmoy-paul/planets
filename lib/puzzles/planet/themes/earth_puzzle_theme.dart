import 'package:flutter/material.dart';
import '../../../resource/app_assets.dart';

import 'planet_puzzle_theme.dart';

class EarthPuzzleTheme extends PlanetPuzzleTheme {
  const EarthPuzzleTheme();

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get surface => Colors.grey;

  @override
  Color get onSurface => Colors.amber;

  @override
  String get backgroundAsset => AppAssets.earthLandscape;

  @override
  String get assetForTile => AppAssets.earthAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.earthImage;

  @override
  String get placeholderThumbnail => AppAssets.earthThumb;
}
