import 'package:flutter/material.dart';
import 'package:planets/global/stylized_text.dart';

class StylizedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double strokeWidth;
  final double offset;

  const StylizedIcon({
    Key? key,
    required this.icon,
    this.size = 24.0,
    this.strokeWidth = 6.0,
    this.offset = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StylizedText(
      text: String.fromCharCode(icon.codePoint),
      strokeWidth: strokeWidth,
      offset: offset,
      style: TextStyle(
        inherit: false,
        color: Colors.white,
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );
  }
}
