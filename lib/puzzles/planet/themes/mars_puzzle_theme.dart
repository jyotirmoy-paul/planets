import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class MarsPuzzleTheme extends PlanetPuzzleTheme {
  const MarsPuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.marsLandscape;

  @override
  String get assetForTile => AppAssets.marsAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.marsImage;

  @override
  String get placeholderThumbnail => AppAssets.marsThumb;
}
