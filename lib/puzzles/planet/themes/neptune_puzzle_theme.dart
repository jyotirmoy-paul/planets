import '../../../resource/app_assets.dart';
import 'planet_puzzle_theme.dart';

class NeptunePuzzleTheme extends PlanetPuzzleTheme {
  const NeptunePuzzleTheme();

  @override
  String get backgroundAsset => AppAssets.neptuneLandscape;

  @override
  String get assetForTile => AppAssets.neptuneAnimation;

  @override
  String get placeholderAssetForTile => AppAssets.neptuneImage;

  @override
  String get placeholderThumbnail => AppAssets.neptuneThumb;
}
