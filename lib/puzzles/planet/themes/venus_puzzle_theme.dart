import 'package:flutter/material.dart';

import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class VenusPuzzleTheme extends PlanetPuzzleTheme {
  const VenusPuzzleTheme();

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get surface => Colors.grey;

  @override
  Color get onSurface => Colors.amber;

  @override
  String get backgroundAsset => AppAssets.venusLandscape;

  @override
  String get assetForTile => AppAssets.venusAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.venusImage;

  @override
  String get placeholderThumbnail => AppAssets.venusThumb;
}
