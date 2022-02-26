import 'package:flutter/material.dart';

import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class MarsPuzzleTheme extends PlanetPuzzleTheme {
  const MarsPuzzleTheme();

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get surface => Colors.grey;

  @override
  Color get onSurface => Colors.amber;

  @override
  String get backgroundAsset => AppAssets.marsLandscape;

  @override
  String get assetForTile => AppAssets.marsAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.marsImage;

  @override
  String get placeholderThumbnail => AppAssets.marsThumb;
}
