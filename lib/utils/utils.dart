import 'package:flutter/painting.dart';

import '../models/position.dart';

const _paddingOffset = 5.0;
const _roundOffset = 15.0;
const _radius = Radius.circular(_roundOffset);

abstract class Utils {
  static Color darkenColor(Color color, [double amount = 0.30]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
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
