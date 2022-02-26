import 'package:flutter/material.dart';

import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class NeptunePuzzleTheme extends PlanetPuzzleTheme {
  const NeptunePuzzleTheme();

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get surface => Colors.grey;

  @override
  Color get onSurface => Colors.amber;

  @override
  String get backgroundAsset => AppAssets.neptuneLandscape;

  @override
  String get assetForTile => AppAssets.neptuneAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.mercuryImage;

  @override
  String get placeholderThumbnail => AppAssets.neptuneThumb;
}
