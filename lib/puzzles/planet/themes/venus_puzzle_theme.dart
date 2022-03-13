import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class VenusPuzzleTheme extends PlanetPuzzleTheme {
  const VenusPuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.venusLandscape;

  @override
  String get assetForTile => AppAssets.venusAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.venusImage;

  @override
  String get placeholderThumbnail => AppAssets.venusThumb;
}
