import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class EarthPuzzleTheme extends PlanetPuzzleTheme {
  const EarthPuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.earthLandscape;

  @override
  String get assetForTile => AppAssets.earthAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.earthImage;

  @override
  String get placeholderThumbnail => AppAssets.earthThumb;
}
