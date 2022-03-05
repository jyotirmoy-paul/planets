import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:planets/utils/app_logger.dart';
import 'package:planets/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../models/planet.dart';
import '../resource/app_assets.dart';

import '../models/position.dart';
import 'dart:math' as math;

const _paddingOffset = 5.0;
const _roundOffset = 15.0;
const _radius = Radius.circular(_roundOffset);

abstract class Utils {
  static Future<Uint8List?> capturePng(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final ui.Image image = await boundary.toImage(pixelRatio: 1.2);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static String sharableText(String planetName) {
    return 'I just assembled $planetName, It\'s a fun challenge, join the #FlutterPuzzleHack! Check it out here ↓';
  }

  static Future<void> openLink(String url, {VoidCallback? onError}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else if (onError != null) {
      AppLogger.log('cannot open link for url $url');
      onError();
    }
  }

  static void onFacebookTap(final String planetName) {
    final shareText = sharableText(planetName);
    final encodedShareText = Uri.encodeComponent(shareText);
    final facebookUrl =
        'https://www.facebook.com/sharer.php?u=$kUrl&quote=$encodedShareText';
    openLink(facebookUrl);
  }

  static void onTwitterTap(final String planetName) {
    final shareText = sharableText(planetName);
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
        File(applicationDir.path + '/${const Uuid().v1()}.png')
            .writeAsBytes(imageData);
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

  static String get planetRotationAnimationName => 'revolution';

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
