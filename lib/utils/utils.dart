import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:planets/utils/quick_visit_counter.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import '../l10n/l10n.dart';
import 'app_logger.dart';
import 'constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../models/planet.dart';
import '../models/position.dart';
import '../resource/app_assets.dart';

const _paddingOffset = 5.0;
const _roundOffset = 15.0;
const _radius = Radius.circular(_roundOffset);

abstract class Utils {
  static bool isOptimizedPuzzle() {
    /// if in web, run optimized puzzle for mobile browsers
    if (kIsWeb) {
      final userAgent =
          html.window.navigator.userAgent.toString().toLowerCase();

      AppLogger.log('Utils :: isOptimizedPuzzle: userAgent: $userAgent');

      if (userAgent.contains("iphone") || userAgent.contains("android")) {
        return true;
      }
    }

    return false;
  }

  static String planetName(PlanetType type, BuildContext context) {
    switch (type) {
      case PlanetType.mercury:
        return context.l10n.mercury;

      case PlanetType.venus:
        return context.l10n.venus;

      case PlanetType.earth:
        return context.l10n.earth;

      case PlanetType.mars:
        return context.l10n.mars;

      case PlanetType.jupiter:
        return context.l10n.jupiter;

      case PlanetType.saturn:
        return context.l10n.saturn;

      case PlanetType.uranus:
        return context.l10n.uranus;

      case PlanetType.neptune:
        return context.l10n.neptune;

      case PlanetType.pluto:
        return context.l10n.pluto;
    }
  }

  static List<String> planetFacts(PlanetType type, BuildContext context) {
    switch (type) {
      case PlanetType.mercury:
        return [
          context.l10n.mercuryFact1,
          context.l10n.mercuryFact2,
          context.l10n.mercuryFact3
        ];

      case PlanetType.venus:
        return [
          context.l10n.venusFact1,
          context.l10n.venusFact2,
          context.l10n.venusFact3
        ];

      case PlanetType.earth:
        return [
          context.l10n.earthFact1,
          context.l10n.earthFact2,
          context.l10n.earthFact3
        ];

      case PlanetType.mars:
        return [
          context.l10n.marsFact1,
          context.l10n.marsFact2,
          context.l10n.marsFact3
        ];

      case PlanetType.jupiter:
        return [
          context.l10n.jupiterFact1,
          context.l10n.jupiterFact2,
          context.l10n.jupiterFact3
        ];

      case PlanetType.saturn:
        return [
          context.l10n.saturnFact1,
          context.l10n.saturnFact2,
          context.l10n.saturnFact3
        ];

      case PlanetType.uranus:
        return [
          context.l10n.uranusFact1,
          context.l10n.uranusFact2,
          context.l10n.uranusFact3
        ];

      case PlanetType.neptune:
        return [
          context.l10n.neptuneFact1,
          context.l10n.neptuneFact2,
          context.l10n.neptuneFact3
        ];

      case PlanetType.pluto:
        return [
          context.l10n.plutoFact1,
          context.l10n.plutoFact2,
          context.l10n.plutoFact3
        ];
    }
  }

  static Future<Widget> buildPageAsync(Widget page) {
    return Future.microtask(() {
      return page;
    });
  }

  static String getSuccessExtraText({
    required int totalSteps,
    required int autoSolverSteps,
  }) {
    final f = autoSolverSteps / totalSteps;

    if (f > 0.85) {
      return '(though we helped a lot)';
    }

    if (f > 0.30) {
      return 'with a fair bit of help';
    }

    if (f > 0) {
      return 'without much aid';
    }

    // haven't used auto solver
    return 'without any aid';
  }

  static Future<Uint8List?> capturePng(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final ui.Image image =
        await boundary.toImage(pixelRatio: kIsWeb ? 1.2 : 2.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static String sharableText(String planetName, BuildContext context) {
    return context.l10n.sharableText(planetName);
  }

  static Future<void> openLink(String url, {VoidCallback? onError}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else if (onError != null) {
      AppLogger.log('cannot open link for url $url');
      onError();
    }
  }

  static void onGithubTap() {
    QuickVisitCounter.viewOnGithubClicked();
    openLink(kGithubUrl);
  }

  static void onFacebookTap(final String planetName, BuildContext context) {
    final shareText = sharableText(planetName, context);
    final encodedShareText = Uri.encodeComponent(shareText);
    final facebookUrl =
        'https://www.facebook.com/sharer.php?u=$kUrl&quote=$encodedShareText';
    openLink(facebookUrl);
  }

  static void onTwitterTap(final String planetName, BuildContext context) {
    final shareText = sharableText(planetName, context);
    final encodedShareText = Uri.encodeComponent(shareText);
    final twitterUrl =
        'https://twitter.com/intent/tweet?url=$kUrl&text=$encodedShareText';
    openLink(twitterUrl);
  }

  static void onDownloadTap(Uint8List? imageData) async {
    if (imageData == null) return;

    try {
      if (kIsWeb) {
        // download the image
        final blob = html.Blob(
          <dynamic>[imageData],
          'application/octet-stream',
        );
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = '${const Uuid().v1()}.png';
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        // save the image
        final applicationDir = await getApplicationDocumentsDirectory();
        final file =
            await File(applicationDir.path + '/${const Uuid().v1()}.png')
                .writeAsBytes(imageData);

        final success = await GallerySaver.saveImage(file.path);

        if (success == true) {
          // todo: show toast
        } else {
          AppLogger.log('Utils :: onDownloadTap :: could not save image');
        }
      }
    } catch (e) {
      AppLogger.log('onDownloadTap: error: $e');
    }
  }

  static int getScore({
    required int secondsTaken,
    required int totalSteps,
    required int autoSolverSteps,
    required int puzzleSize,
  }) {
    int totalScore = 5;

    switch (puzzleSize) {
      case 3:
        if (secondsTaken > k3PuzzleDuration.inSeconds) totalScore--;
        break;

      case 4:
        if (secondsTaken > k4PuzzleDuration.inSeconds) totalScore--;
        break;

      case 5:
        if (secondsTaken > k5PuzzleDuration.inSeconds) totalScore--;
        break;
    }

    // if used autosolver, decrease points
    if (autoSolverSteps != 0) {
      if (totalScore >= 4) {
        totalScore -= 2;
      } else {
        totalScore--;
      }
    }

    // penalty for too many steps
    if (totalSteps > 500) totalScore--;

    // min score a user can get is 1, for worst case scenario
    return math.max(1, totalScore);
  }

  static Color darkenColor(Color color, [double amount = 0.30]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static String get planetRotationAnimationName => 'rotation';

  static String getPlanetImageFor(PlanetType type) {
    switch (type) {
      case PlanetType.mercury:
        return AppAssets.mercuryImage;

      case PlanetType.venus:
        return AppAssets.venusImage;

      case PlanetType.earth:
        return AppAssets.earthImage;

      case PlanetType.mars:
        return AppAssets.marsImage;

      case PlanetType.jupiter:
        return AppAssets.jupiterImage;

      case PlanetType.saturn:
        return AppAssets.saturnImage;

      case PlanetType.uranus:
        return AppAssets.uranusImage;

      case PlanetType.neptune:
        return AppAssets.neptuneImage;

      case PlanetType.pluto:
        return AppAssets.plutoImage;
    }
  }

  static String getPlanetThumbFor(PlanetType type) {
    switch (type) {
      case PlanetType.mercury:
        return AppAssets.mercuryThumb;

      case PlanetType.venus:
        return AppAssets.venusThumb;

      case PlanetType.earth:
        return AppAssets.earthThumb;

      case PlanetType.mars:
        return AppAssets.marsThumb;

      case PlanetType.jupiter:
        return AppAssets.jupiterThumb;

      case PlanetType.saturn:
        return AppAssets.saturnThumb;

      case PlanetType.uranus:
        return AppAssets.uranusThumb;

      case PlanetType.neptune:
        return AppAssets.neptuneThumb;

      case PlanetType.pluto:
        return AppAssets.plutoThumb;
    }
  }

  static String getPlanetAnimationFor(PlanetType type) {
    switch (type) {
      case PlanetType.mercury:
        return AppAssets.mercuryAnimation;

      case PlanetType.venus:
        return AppAssets.venusAnimation;

      case PlanetType.earth:
        return AppAssets.earthAnimation;

      case PlanetType.mars:
        return AppAssets.marsAnimation;

      case PlanetType.jupiter:
        return AppAssets.jupiterAnimation;

      case PlanetType.saturn:
        return AppAssets.saturnAnimation;

      case PlanetType.uranus:
        return AppAssets.uranusAnimation;

      case PlanetType.neptune:
        return AppAssets.neptuneAnimation;

      case PlanetType.pluto:
        return AppAssets.plutoAnimation;
    }
  }

  static String getFormattedElapsedSeconds(int elapsedSeconds) {
    final duration = Duration(seconds: elapsedSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  static Path getPuzzlePath(
    Size size,
    int puzzleSize,
    Position correctPosition,
  ) {
    double width = (size.width / puzzleSize);
    double height = (size.height / puzzleSize);

    double offsetX = correctPosition.x * width;
    double offsetY = correctPosition.y * height;

    width -= _paddingOffset;
    height -= _paddingOffset;

    final path = Path();

    path.moveTo(offsetX + _roundOffset, offsetY);
    path.lineTo(offsetX + width - _roundOffset, offsetY);

    path.arcToPoint(
      Offset(offsetX + width, offsetY + _roundOffset),
      radius: _radius,
    );

    path.lineTo(offsetX + width, offsetY + height - _roundOffset);

    path.arcToPoint(
      Offset(offsetX + width - _roundOffset, offsetY + height),
      radius: _radius,
    );

    path.lineTo(offsetX + _roundOffset, offsetY + height);

    path.arcToPoint(
      Offset(offsetX, offsetY + height - _roundOffset),
      radius: _radius,
    );

    path.lineTo(offsetX, offsetY + _roundOffset);

    path.arcToPoint(
      Offset(offsetX + _roundOffset, offsetY),
      radius: _radius,
    );

    return path;
  }
}
