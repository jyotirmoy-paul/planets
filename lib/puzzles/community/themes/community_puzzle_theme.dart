import 'dart:ui';

import '../../../layout/layout.dart';
import '../layout/community_puzzle_layout_delegate.dart';
import '../../../theme/themes/puzzle_theme.dart';

class CommunityPuzzleTheme extends PuzzleTheme {
  const CommunityPuzzleTheme();

  @override
  String get name => 'Community';

  @override
  PuzzleLayoutDelegate get puzzleLayoutDelegate =>
      CommunityPuzzleLayoutDelegate();

  @override
  String get backgroundAsset => throw UnimplementedError();

  @override
  Color get onPrimary => throw UnimplementedError();

  @override
  Color get onSurface => throw UnimplementedError();

  @override
  Color get primary => throw UnimplementedError();

  @override
  Color get surface => throw UnimplementedError();

  // todo: make a constructor for community puzzle theme and take this asset as an argument
  @override
  String get assetForTile => 'assets/animations/planet_x.riv';
}
