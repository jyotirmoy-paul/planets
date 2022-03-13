import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class PlutoPuzzleTheme extends PlanetPuzzleTheme {
  const PlutoPuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.plutoLandscape;

  @override
  String get assetForTile => AppAssets.plutoAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.plutoImage;

  @override
  String get placeholderThumbnail => AppAssets.plutoThumb;
}
