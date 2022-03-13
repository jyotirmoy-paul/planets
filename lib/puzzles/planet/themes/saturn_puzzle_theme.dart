import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class SaturnPuzzleTheme extends PlanetPuzzleTheme {
  const SaturnPuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.saturnLandscape;

  @override
  String get assetForTile => AppAssets.saturnAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.saturnExtra;

  @override
  String get placeholderThumbnail => AppAssets.saturnExtraThumb;
}
