import 'package:flutter/material.dart';

import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class MercuryPuzzleTheme extends PlanetPuzzleTheme {
  const MercuryPuzzleTheme();

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get surface => Colors.grey;

  @override
  Color get onSurface => Colors.amber;

  @override
  String get backgroundAsset => AppAssets.mercuryLandscape;

  @override
  String get assetForTile => AppAssets.mercuryAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.mercuryImage;

  @override
  String get placeholderThumbnail => AppAssets.mercuryThumb;
}
