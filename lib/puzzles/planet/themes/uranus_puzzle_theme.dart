import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class UranusPuzzleTheme extends PlanetPuzzleTheme {
  const UranusPuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.uranusLandscape;

  @override
  String get assetForTile => AppAssets.uranusAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.uranusImage;

  @override
  String get placeholderThumbnail => AppAssets.uranusThumb;
}
