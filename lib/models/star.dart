import 'package:flutter/material.dart';

import '../global/background/star_widget.dart';
import 'position.dart';

class Star {
  final int value;
  final Position pos;
  final double size;
  final double rotation;

  Star({
    required this.value,
    required this.pos,
    required this.size,
    required this.rotation,
  });

  Widget get widget => StarWidget(
        star: this,
        key: ValueKey(value),
      );
}
