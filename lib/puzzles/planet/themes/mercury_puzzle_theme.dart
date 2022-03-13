import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class MercuryPuzzleTheme extends PlanetPuzzleTheme {
  const MercuryPuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.mercuryLandscape;

  @override
  String get assetForTile => AppAssets.mercuryAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.mercuryImage;

  @override
  String get placeholderThumbnail => AppAssets.mercuryThumb;
}
