import 'package:flutter/material.dart';

import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class PlutoPuzzleTheme extends PlanetPuzzleTheme {
  const PlutoPuzzleTheme();

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get surface => Colors.grey;

  @override
  Color get onSurface => Colors.amber;

  @override
  String get backgroundAsset => AppAssets.plutoLandscape;

  @override
  String get assetForTile => AppAssets.plutoAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.plutoImage;

  @override
  String get placeholderThumbnail => AppAssets.plutoThumb;
}
