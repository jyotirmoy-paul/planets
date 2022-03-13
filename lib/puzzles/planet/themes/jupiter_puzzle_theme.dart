import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class JupiterPuzzleTheme extends PlanetPuzzleTheme {
  const JupiterPuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.jupiterLandscape;

  @override
  String get assetForTile => AppAssets.jupiterAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.jupiterImage;

  @override
  String get placeholderThumbnail => AppAssets.jupiterThumb;
}
