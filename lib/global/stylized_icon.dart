import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'stylized_text.dart';

class StylizedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double strokeWidth;
  final double offset;
  final Color color;

  const StylizedIcon({
    Key? key,
    required this.icon,
    this.size = 24.0,
    this.strokeWidth = 6.0,
    this.offset = 2.0,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StylizedText(
      text: String.fromCharCode(icon.codePoint),
      strokeWidth: strokeWidth,
      strokeColor:
          color == Colors.white ? Colors.black : Utils.darkenColor(color),
      offset: offset,
      style: TextStyle(
        inherit: false,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );
  }
}
